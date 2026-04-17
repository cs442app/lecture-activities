# Crowdle — crowd-sourced Wordle backend
#
# Players register, then submit 5-letter words for others to guess.
# All guesses and their Wordle-style clues are visible to everyone.
# The player who guesses correctly earns points; the puzzle creator
# earns points for difficulty (more total guesses → more creator points).
#
# Scoring:
#   solver  points = max(1, 11 - total_guesses)
#   creator points = total_guesses // 2

import os
import urllib.request
from datetime import timedelta

import sqlite3
from flask import Flask, request, jsonify
from flask_jwt_extended import (
    JWTManager, jwt_required, create_access_token, get_jwt_identity,
)
from flask_bcrypt import Bcrypt
from better_profanity import profanity


app = Flask(__name__)
bcrypt = Bcrypt(app)

app.config['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY', 'crowdle-cs442-dev!')
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=24)
jwt = JWTManager(app)

profanity.load_censor_words()


# ── Word list ──────────────────────────────────────────────────────────────────

def _fetch_word_list():
    """Download ENABLE word list and cache 5-letter words to words.txt."""
    url = 'https://raw.githubusercontent.com/dolph/dictionary/master/enable1.txt'
    with urllib.request.urlopen(url) as r:
        words = {line.decode().strip().lower() for line in r if len(line.strip()) == 5}
    with open('words.txt', 'w') as f:
        f.write('\n'.join(sorted(words)))
    return words


def _load_word_list() -> set[str]:
    if os.path.exists('words.txt'):
        with open('words.txt') as f:
            return {line.strip().lower() for line in f if line.strip()}
    print('words.txt not found — downloading ENABLE word list...')
    return _fetch_word_list()


VALID_WORDS = _load_word_list()
print(f'Loaded {len(VALID_WORDS)} valid 5-letter words.')


# ── Database ───────────────────────────────────────────────────────────────────

db = sqlite3.connect('crowdle.db', check_same_thread=False)
db.row_factory = sqlite3.Row
cur = db.cursor()
cur.executescript('''
    PRAGMA foreign_keys = ON;

    CREATE TABLE IF NOT EXISTS users (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        username      TEXT    NOT NULL UNIQUE,
        password_hash TEXT    NOT NULL,
        score         INTEGER NOT NULL DEFAULT 0
    );

    CREATE TABLE IF NOT EXISTS puzzles (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        word       TEXT    NOT NULL,
        creator_id INTEGER NOT NULL REFERENCES users(id),
        status     TEXT    NOT NULL DEFAULT 'active',
        created_at TEXT    NOT NULL DEFAULT (datetime('now')),
        solved_at  TEXT,
        solver_id  INTEGER REFERENCES users(id)
    );

    CREATE TABLE IF NOT EXISTS guesses (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        puzzle_id  INTEGER NOT NULL REFERENCES puzzles(id),
        user_id    INTEGER NOT NULL REFERENCES users(id),
        word       TEXT    NOT NULL,
        clue       TEXT    NOT NULL,
        created_at TEXT    NOT NULL DEFAULT (datetime('now'))
    );
''')
db.commit()


# ── Clue logic ─────────────────────────────────────────────────────────────────

def compute_clue(answer: str, guess: str) -> list[str]:
    """Return a Wordle-style clue array for guess against answer.

    Each element is 'correct', 'present', or 'absent'.
    Handles duplicate letters the same way Wordle does: correct slots are
    matched first, then remaining answer letters are matched left-to-right
    for 'present' hits.
    """
    result = ['absent'] * 5
    answer_pool = list(answer)
    guess_pool = list(guess)

    # First pass: exact matches
    for i in range(5):
        if guess_pool[i] == answer_pool[i]:
            result[i] = 'correct'
            answer_pool[i] = None
            guess_pool[i] = None

    # Second pass: wrong-position matches
    for i in range(5):
        if guess_pool[i] is not None and guess_pool[i] in answer_pool:
            result[i] = 'present'
            answer_pool[answer_pool.index(guess_pool[i])] = None

    return result


# ── Auth routes ────────────────────────────────────────────────────────────────

@app.route('/register', methods=['POST'])
def register():
    data = request.get_json(silent=True) or {}
    username = (data.get('username') or '').strip()
    password = data.get('password') or ''

    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400

    password_hash = bcrypt.generate_password_hash(password).decode()
    try:
        cur.execute(
            'INSERT INTO users (username, password_hash) VALUES (?, ?)',
            (username, password_hash),
        )
        db.commit()
        user_id = cur.lastrowid
    except sqlite3.IntegrityError:
        return jsonify({'error': 'Username already taken'}), 409

    return jsonify({
        'message': 'Registered successfully',
        'access_token': create_access_token(identity=user_id),
        'username': username,
    })


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json(silent=True) or {}
    username = (data.get('username') or '').strip()
    password = data.get('password') or ''

    cur.execute('SELECT id, password_hash FROM users WHERE username = ?', (username,))
    row = cur.fetchone()
    if not row or not bcrypt.check_password_hash(row['password_hash'], password):
        return jsonify({'error': 'Invalid username or password'}), 401

    return jsonify({
        'message': 'Login successful',
        'access_token': create_access_token(identity=row['id']),
        'username': username,
    })


@app.route('/me')
@jwt_required()
def me():
    user_id = get_jwt_identity()
    cur.execute('SELECT id, username, score FROM users WHERE id = ?', (user_id,))
    row = cur.fetchone()
    if not row:
        return jsonify({'error': 'User not found'}), 404
    return jsonify(dict(row))


# ── Puzzle routes ──────────────────────────────────────────────────────────────

def _puzzle_summary(row) -> dict:
    """Build the list-view representation of a puzzle row."""
    cur.execute(
        'SELECT guesses.word, guesses.clue, users.username '
        'FROM guesses JOIN users ON guesses.user_id = users.id '
        'WHERE guesses.puzzle_id = ? ORDER BY guesses.id DESC LIMIT 1',
        (row['id'],),
    )
    last = cur.fetchone()

    import json
    return {
        'id':           row['id'],
        'creator':      row['creator'],
        'creator_id':   row['creator_id'],
        'status':       row['status'],
        'guess_count':  row['guess_count'],
        'last_clue':    json.loads(last['clue']) if last else None,
        'last_guesser': last['username'] if last else None,
        'word':         row['word'] if row['status'] == 'solved' else None,
    }


@app.route('/puzzles')
def list_puzzles():
    cur.execute('''
        SELECT puzzles.id, users.username AS creator, puzzles.creator_id,
               puzzles.status, puzzles.word,
               COUNT(guesses.id) AS guess_count
        FROM puzzles
        JOIN users ON puzzles.creator_id = users.id
        LEFT JOIN guesses ON guesses.puzzle_id = puzzles.id
        GROUP BY puzzles.id
        ORDER BY puzzles.id DESC
    ''')
    rows = cur.fetchall()
    return jsonify([_puzzle_summary(r) for r in rows])


@app.route('/puzzles/<int:puzzle_id>')
def get_puzzle(puzzle_id):
    import json
    cur.execute('''
        SELECT puzzles.id, users.username AS creator, puzzles.creator_id,
               puzzles.status, puzzles.word,
               COUNT(guesses.id) AS guess_count
        FROM puzzles
        JOIN users ON puzzles.creator_id = users.id
        LEFT JOIN guesses ON guesses.puzzle_id = puzzles.id
        WHERE puzzles.id = ?
        GROUP BY puzzles.id
    ''', (puzzle_id,))
    puzzle = cur.fetchone()
    if not puzzle:
        return jsonify({'error': 'Puzzle not found'}), 404

    cur.execute('''
        SELECT guesses.id, users.username, guesses.word, guesses.clue, guesses.created_at
        FROM guesses
        JOIN users ON guesses.user_id = users.id
        WHERE guesses.puzzle_id = ?
        ORDER BY guesses.id ASC
    ''', (puzzle_id,))
    guesses = [
        {
            'id':         g['id'],
            'username':   g['username'],
            'word':       g['word'],
            'clue':       json.loads(g['clue']),
            'created_at': g['created_at'],
        }
        for g in cur.fetchall()
    ]

    return jsonify({
        'id':          puzzle['id'],
        'creator':     puzzle['creator'],
        'creator_id':  puzzle['creator_id'],
        'status':      puzzle['status'],
        'guess_count': puzzle['guess_count'],
        'word':        puzzle['word'] if puzzle['status'] == 'solved' else None,
        'guesses':     guesses,
    })


@app.route('/puzzles', methods=['POST'])
@jwt_required()
def create_puzzle():
    user_id = get_jwt_identity()
    data = request.get_json(silent=True) or {}
    word = (data.get('word') or '').strip().lower()

    if len(word) != 5:
        return jsonify({'error': 'Word must be exactly 5 letters'}), 422
    if not word.isalpha():
        return jsonify({'error': 'Word must contain only letters'}), 422
    if word not in VALID_WORDS:
        return jsonify({'error': 'Not a valid English word'}), 422
    if profanity.contains_profanity(word):
        return jsonify({'error': 'Word contains inappropriate content'}), 422

    cur.execute(
        'INSERT INTO puzzles (word, creator_id) VALUES (?, ?)',
        (word, user_id),
    )
    db.commit()
    puzzle_id = cur.lastrowid

    cur.execute('SELECT username FROM users WHERE id = ?', (user_id,))
    creator = cur.fetchone()['username']

    return jsonify({
        'id':          puzzle_id,
        'creator':     creator,
        'creator_id':  user_id,
        'status':      'active',
        'guess_count': 0,
        'word':        None,
        'guesses':     [],
    }), 201


@app.route('/puzzles/<int:puzzle_id>/guesses', methods=['POST'])
@jwt_required()
def submit_guess(puzzle_id):
    import json
    user_id = get_jwt_identity()
    data = request.get_json(silent=True) or {}
    word = (data.get('word') or '').strip().lower()

    # Validate the puzzle
    cur.execute('SELECT * FROM puzzles WHERE id = ?', (puzzle_id,))
    puzzle = cur.fetchone()
    if not puzzle:
        return jsonify({'error': 'Puzzle not found'}), 404
    if puzzle['status'] == 'solved':
        return jsonify({'error': 'This puzzle has already been solved'}), 410
    if puzzle['creator_id'] == user_id:
        return jsonify({'error': 'You cannot guess your own puzzle'}), 403

    # Validate the guess word
    if len(word) != 5 or not word.isalpha():
        return jsonify({'error': 'Guess must be exactly 5 letters'}), 422
    if word not in VALID_WORDS:
        return jsonify({'error': 'Not a valid English word'}), 422

    # Enforce the no-consecutive-guesses rule
    cur.execute(
        'SELECT user_id FROM guesses WHERE puzzle_id = ? ORDER BY id DESC LIMIT 1',
        (puzzle_id,),
    )
    last_guess = cur.fetchone()
    if last_guess and last_guess['user_id'] == user_id:
        return jsonify({'error': 'Wait for another player to guess before guessing again'}), 409

    # Compute clue and save guess
    clue = compute_clue(puzzle['word'], word)
    cur.execute(
        'INSERT INTO guesses (puzzle_id, user_id, word, clue) VALUES (?, ?, ?, ?)',
        (puzzle_id, user_id, word, json.dumps(clue)),
    )
    db.commit()

    solved = (word == puzzle['word'])
    response: dict = {
        'id':     cur.lastrowid,
        'word':   word,
        'clue':   clue,
        'solved': solved,
    }

    if solved:
        # Count total guesses (including the winning one)
        cur.execute('SELECT COUNT(*) AS n FROM guesses WHERE puzzle_id = ?', (puzzle_id,))
        total = cur.fetchone()['n']

        solver_points = max(1, 11 - total)
        creator_points = total // 2

        cur.execute(
            'UPDATE puzzles SET status = ?, solved_at = datetime(\'now\'), solver_id = ? WHERE id = ?',
            ('solved', user_id, puzzle_id),
        )
        cur.execute('UPDATE users SET score = score + ? WHERE id = ?', (solver_points, user_id))
        cur.execute('UPDATE users SET score = score + ? WHERE id = ?', (creator_points, puzzle['creator_id']))
        db.commit()

        response['points_earned'] = solver_points

    return jsonify(response), 201


# ── Leaderboard ────────────────────────────────────────────────────────────────

@app.route('/leaderboard')
def leaderboard():
    cur.execute(
        'SELECT username, score FROM users ORDER BY score DESC, username ASC',
    )
    return jsonify([
        {'rank': i + 1, 'username': row['username'], 'score': row['score']}
        for i, row in enumerate(cur.fetchall())
    ])


# ── Error handlers ─────────────────────────────────────────────────────────────

@app.errorhandler(401)
def unauthorized(_):
    return jsonify({'error': 'Unauthorized — provide a valid JWT'}), 401

@app.errorhandler(404)
def not_found(_):
    return jsonify({'error': 'Not found'}), 404

@app.errorhandler(405)
def method_not_allowed(_):
    return jsonify({'error': 'Method not allowed'}), 405


HOST = '0.0.0.0'
PORT = int(os.environ.get('PORT', 5001))

if __name__ == '__main__':
    app.run(host=HOST, port=PORT, debug=True)
