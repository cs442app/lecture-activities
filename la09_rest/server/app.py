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

import json
import os
import urllib.request
from datetime import timedelta

import psycopg2
import psycopg2.pool
import psycopg2.errors
from psycopg2.extras import RealDictCursor
from flask import Flask, g, request, jsonify, render_template_string
from flask_cors import CORS
from flask_jwt_extended import (
    JWTManager, jwt_required, create_access_token, get_jwt_identity,
)
from flask_bcrypt import Bcrypt
from better_profanity import profanity


app = Flask(__name__)
CORS(app)
bcrypt = Bcrypt(app)

app.config['JWT_SECRET_KEY'] = os.environ.get(
    'JWT_SECRET_KEY',
    'crowdle-cs442-local-dev-key-not-for-production',
)
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

DATABASE_URL = os.environ.get('DATABASE_URL', 'postgresql://localhost/crowdle')

# Render's DATABASE_URL uses postgres:// scheme; psycopg2 requires postgresql://
if DATABASE_URL.startswith('postgres://'):
    DATABASE_URL = DATABASE_URL.replace('postgres://', 'postgresql://', 1)

_pool = psycopg2.pool.ThreadedConnectionPool(
    minconn=1,
    maxconn=10,
    dsn=DATABASE_URL,
)


def get_db():
    """Return the per-request database connection (checked out from pool)."""
    if 'db' not in g:
        g.db = _pool.getconn()
        g.db.autocommit = False
    return g.db


@app.teardown_appcontext
def return_db(exc):
    db = g.pop('db', None)
    if db is not None:
        if exc is None:
            db.commit()
        else:
            db.rollback()
        _pool.putconn(db)


def _cursor():
    """Return a RealDictCursor for the current request's connection."""
    return get_db().cursor(cursor_factory=RealDictCursor)


def _init_db():
    """Create tables if they don't exist. Uses a direct connection, not the pool/g."""
    conn = psycopg2.connect(DATABASE_URL)
    try:
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS crowdle_users (
                id            SERIAL PRIMARY KEY,
                username      TEXT   NOT NULL UNIQUE,
                password_hash TEXT   NOT NULL,
                score         INTEGER NOT NULL DEFAULT 0
            )
        ''')
        cur.execute('''
            CREATE TABLE IF NOT EXISTS crowdle_puzzles (
                id         SERIAL PRIMARY KEY,
                word       TEXT    NOT NULL,
                creator_id INTEGER NOT NULL REFERENCES crowdle_users(id),
                status     TEXT    NOT NULL DEFAULT 'active',
                created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                solved_at  TIMESTAMPTZ,
                solver_id  INTEGER REFERENCES crowdle_users(id)
            )
        ''')
        cur.execute('''
            CREATE TABLE IF NOT EXISTS crowdle_guesses (
                id         SERIAL PRIMARY KEY,
                puzzle_id  INTEGER NOT NULL REFERENCES crowdle_puzzles(id),
                user_id    INTEGER NOT NULL REFERENCES crowdle_users(id),
                word       TEXT    NOT NULL,
                clue       TEXT    NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            )
        ''')
        conn.commit()
    finally:
        conn.close()


_init_db()


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
    cur = _cursor()
    data = request.get_json(silent=True) or {}
    username = (data.get('username') or '').strip()
    password = data.get('password') or ''

    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400

    password_hash = bcrypt.generate_password_hash(password).decode()
    try:
        cur.execute(
            'INSERT INTO crowdle_users (username, password_hash) VALUES (%s, %s) RETURNING id',
            (username, password_hash),
        )
        user_id = cur.fetchone()['id']
        get_db().commit()
    except psycopg2.errors.UniqueViolation:
        get_db().rollback()
        return jsonify({'error': 'Username already taken'}), 409

    return jsonify({
        'message': 'Registered successfully',
        'access_token': create_access_token(identity=str(user_id)),
        'username': username,
    })


@app.route('/login', methods=['POST'])
def login():
    cur = _cursor()
    data = request.get_json(silent=True) or {}
    username = (data.get('username') or '').strip()
    password = data.get('password') or ''

    cur.execute('SELECT id, password_hash FROM crowdle_users WHERE username = %s', (username,))
    row = cur.fetchone()
    if not row or not bcrypt.check_password_hash(row['password_hash'], password):
        return jsonify({'error': 'Invalid username or password'}), 401

    return jsonify({
        'message': 'Login successful',
        'access_token': create_access_token(identity=str(row['id'])),
        'username': username,
    })


@app.route('/me')
@jwt_required()
def me():
    cur = _cursor()
    user_id = int(get_jwt_identity())
    cur.execute('SELECT id, username, score FROM crowdle_users WHERE id = %s', (user_id,))
    row = cur.fetchone()
    if not row:
        return jsonify({'error': 'User not found'}), 404
    return jsonify(dict(row))


# ── Puzzle routes ──────────────────────────────────────────────────────────────

def _puzzle_summary(cur, row) -> dict:
    """Build the list-view representation of a puzzle row."""
    cur.execute(
        'SELECT crowdle_guesses.word, crowdle_guesses.clue, crowdle_users.username '
        'FROM crowdle_guesses JOIN crowdle_users ON crowdle_guesses.user_id = crowdle_users.id '
        'WHERE crowdle_guesses.puzzle_id = %s ORDER BY crowdle_guesses.id DESC LIMIT 1',
        (row['id'],),
    )
    last = cur.fetchone()
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
    cur = _cursor()
    cur.execute('''
        SELECT crowdle_puzzles.id, crowdle_users.username AS creator, crowdle_puzzles.creator_id,
               crowdle_puzzles.status, crowdle_puzzles.word,
               COUNT(crowdle_guesses.id) AS guess_count
        FROM crowdle_puzzles
        JOIN crowdle_users ON crowdle_puzzles.creator_id = crowdle_users.id
        LEFT JOIN crowdle_guesses ON crowdle_guesses.puzzle_id = crowdle_puzzles.id
        GROUP BY crowdle_puzzles.id, crowdle_users.username, crowdle_puzzles.creator_id, crowdle_puzzles.status, crowdle_puzzles.word
        ORDER BY crowdle_puzzles.id DESC
    ''')
    rows = cur.fetchall()
    return jsonify([_puzzle_summary(cur, r) for r in rows])


@app.route('/puzzles/<int:puzzle_id>')
def get_puzzle(puzzle_id):
    cur = _cursor()
    cur.execute('''
        SELECT crowdle_puzzles.id, crowdle_users.username AS creator, crowdle_puzzles.creator_id,
               crowdle_puzzles.status, crowdle_puzzles.word,
               COUNT(crowdle_guesses.id) AS guess_count
        FROM crowdle_puzzles
        JOIN crowdle_users ON crowdle_puzzles.creator_id = crowdle_users.id
        LEFT JOIN crowdle_guesses ON crowdle_guesses.puzzle_id = crowdle_puzzles.id
        WHERE crowdle_puzzles.id = %s
        GROUP BY crowdle_puzzles.id, crowdle_users.username, crowdle_puzzles.creator_id, crowdle_puzzles.status, crowdle_puzzles.word
    ''', (puzzle_id,))
    puzzle = cur.fetchone()
    if not puzzle:
        return jsonify({'error': 'Puzzle not found'}), 404

    cur.execute('''
        SELECT crowdle_guesses.id, crowdle_users.username, crowdle_guesses.word, crowdle_guesses.clue, crowdle_guesses.created_at
        FROM crowdle_guesses
        JOIN crowdle_users ON crowdle_guesses.user_id = crowdle_users.id
        WHERE crowdle_guesses.puzzle_id = %s
        ORDER BY crowdle_guesses.id ASC
    ''', (puzzle_id,))
    guesses = [
        {
            'id':         g['id'],
            'username':   g['username'],
            'word':       g['word'],
            'clue':       json.loads(g['clue']),
            'created_at': g['created_at'].isoformat(),
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
    cur = _cursor()
    user_id = int(get_jwt_identity())
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
        'INSERT INTO crowdle_puzzles (word, creator_id) VALUES (%s, %s) RETURNING id',
        (word, user_id),
    )
    puzzle_id = cur.fetchone()['id']
    get_db().commit()

    cur.execute('SELECT username FROM crowdle_users WHERE id = %s', (user_id,))
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
    cur = _cursor()
    user_id = int(get_jwt_identity())
    data = request.get_json(silent=True) or {}
    word = (data.get('word') or '').strip().lower()

    # Validate the puzzle
    cur.execute('SELECT * FROM crowdle_puzzles WHERE id = %s', (puzzle_id,))
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
        'SELECT user_id FROM crowdle_guesses WHERE puzzle_id = %s ORDER BY id DESC LIMIT 1',
        (puzzle_id,),
    )
    last_guess = cur.fetchone()
    if last_guess and last_guess['user_id'] == user_id:
        return jsonify({'error': 'Wait for another player to guess before guessing again'}), 409

    # Compute clue and save guess
    clue = compute_clue(puzzle['word'], word)
    cur.execute(
        'INSERT INTO crowdle_guesses (puzzle_id, user_id, word, clue) VALUES (%s, %s, %s, %s) RETURNING id',
        (puzzle_id, user_id, word, json.dumps(clue)),
    )
    guess_id = cur.fetchone()['id']
    get_db().commit()

    solved = (word == puzzle['word'])
    response: dict = {
        'id':     guess_id,
        'word':   word,
        'clue':   clue,
        'solved': solved,
    }

    if solved:
        # Count total guesses (including the winning one)
        cur.execute('SELECT COUNT(*) AS n FROM crowdle_guesses WHERE puzzle_id = %s', (puzzle_id,))
        total = cur.fetchone()['n']

        solver_points = max(1, 11 - total)
        creator_points = total // 2

        cur.execute(
            'UPDATE crowdle_puzzles SET status = %s, solved_at = NOW(), solver_id = %s WHERE id = %s',
            ('solved', user_id, puzzle_id),
        )
        cur.execute('UPDATE crowdle_users SET score = score + %s WHERE id = %s', (solver_points, user_id))
        cur.execute('UPDATE crowdle_users SET score = score + %s WHERE id = %s', (creator_points, puzzle['creator_id']))
        get_db().commit()

        response['points_earned'] = solver_points

    return jsonify(response), 201


# ── Leaderboard ────────────────────────────────────────────────────────────────

@app.route('/leaderboard')
def leaderboard():
    cur = _cursor()
    cur.execute(
        'SELECT username, score FROM crowdle_users ORDER BY score DESC, username ASC',
    )
    return jsonify([
        {'rank': i + 1, 'username': row['username'], 'score': row['score']}
        for i, row in enumerate(cur.fetchall())
    ])


# ── Browser views ─────────────────────────────────────────────────────────────

_BASE_CSS = '''
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: "Segoe UI", system-ui, sans-serif; background: #121213; color: #e0e0e0; padding: 24px; }
  h1   { font-size: 2rem; letter-spacing: .1em; margin-bottom: 4px; }
  .sub { color: #888; font-size: .9rem; margin-bottom: 24px; }
  a    { color: #538d4e; text-decoration: none; }
  a:hover { text-decoration: underline; }
  .tile {
    display: inline-flex; align-items: center; justify-content: center;
    width: 38px; height: 38px; border-radius: 4px; margin: 2px;
    font-weight: 700; font-size: 1.1rem; color: #fff;
  }
  .correct { background: #538d4e; }
  .present { background: #b59f3b; }
  .absent  { background: #3a3a3c; }
'''

_LEADERBOARD_HTML = '''<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="15">
  <title>Crowdle — Leaderboard</title>
  <style>
    ''' + _BASE_CSS + '''
    table { border-collapse: collapse; width: 100%; max-width: 480px; }
    th, td { padding: 10px 16px; text-align: left; border-bottom: 1px solid #333; }
    th { color: #888; font-size: .8rem; letter-spacing: .08em; text-transform: uppercase; }
    tr.me td { background: #1a2e1a; }
    .rank { font-weight: 700; font-size: 1.1rem; width: 48px; }
    .gold   { color: #ffd700; }
    .silver { color: #c0c0c0; }
    .bronze { color: #cd7f32; }
    .score  { font-weight: 700; color: #538d4e; }
  </style>
</head>
<body>
  <h1>🟩 Crowdle</h1>
  <p class="sub">Leaderboard &mdash; refreshes every 15 s &nbsp;|&nbsp; <a href="/view/puzzles">Puzzles &rarr;</a></p>
  <table>
    <thead><tr><th>Rank</th><th>Player</th><th>Score</th></tr></thead>
    <tbody>
    {% for e in entries %}
      <tr>
        <td class="rank {% if e.rank == 1 %}gold{% elif e.rank == 2 %}silver{% elif e.rank == 3 %}bronze{% endif %}">
          {{ e.rank }}
        </td>
        <td>{{ e.username }}</td>
        <td class="score">{{ e.score }}</td>
      </tr>
    {% else %}
      <tr><td colspan="3" style="color:#555;padding:24px">No players yet.</td></tr>
    {% endfor %}
    </tbody>
  </table>
</body>
</html>'''

_PUZZLES_HTML = '''<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="10">
  <title>Crowdle — Puzzles</title>
  <style>
    ''' + _BASE_CSS + '''
    .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 16px; }
    .card {
      background: #1e1e1f; border: 1px solid #333; border-radius: 8px; padding: 16px;
    }
    .card.solved { border-color: #538d4e; }
    .card-header { display: flex; align-items: baseline; gap: 8px; margin-bottom: 12px; }
    .creator { font-weight: 700; font-size: 1rem; }
    .badge {
      font-size: .7rem; font-weight: 700; letter-spacing: .06em; text-transform: uppercase;
      padding: 2px 7px; border-radius: 3px;
    }
    .badge.active  { background: #333; color: #aaa; }
    .badge.solved  { background: #538d4e; color: #fff; }
    .answer { font-size: 1.4rem; font-weight: 700; letter-spacing: .15em; color: #538d4e; margin-bottom: 8px; }
    .guess-row { display: flex; align-items: center; gap: 8px; margin-bottom: 4px; }
    .guesser   { font-size: .8rem; color: #888; min-width: 80px; }
    .no-guesses { color: #555; font-size: .85rem; }
    .guess-count { font-size: .8rem; color: #666; margin-bottom: 8px; }
  </style>
</head>
<body>
  <h1>🟩 Crowdle</h1>
  <p class="sub">Puzzles &mdash; refreshes every 10 s &nbsp;|&nbsp; <a href="/view/leaderboard">Leaderboard &rarr;</a></p>
  <div class="grid">
  {% for p in puzzles %}
    <div class="card {{ p.status }}">
      <div class="card-header">
        <span class="creator">{{ p.creator }}</span>
        <span class="badge {{ p.status }}">{{ p.status }}</span>
      </div>
      {% if p.status == "solved" %}
        <div class="answer">{{ p.word.upper() }}</div>
      {% endif %}
      <div class="guess-count">{{ p.guesses | length }} guess{{ "es" if p.guesses | length != 1 else "" }}</div>
      {% if p.guesses %}
        {% for g in p.guesses %}
          <div class="guess-row">
            <span class="guesser">{{ g.username }}</span>
            <span>
              {% for i in range(5) %}
                <span class="tile {{ g.clue[i] }}">{{ g.word[i].upper() }}</span>
              {% endfor %}
            </span>
          </div>
        {% endfor %}
      {% else %}
        <p class="no-guesses">No guesses yet.</p>
      {% endif %}
    </div>
  {% else %}
    <p style="color:#555">No puzzles yet.</p>
  {% endfor %}
  </div>
</body>
</html>'''


@app.route('/view/leaderboard')
def view_leaderboard():
    cur = _cursor()
    cur.execute('SELECT username, score FROM crowdle_users ORDER BY score DESC, username ASC')
    entries = [
        {'rank': i + 1, 'username': r['username'], 'score': r['score']}
        for i, r in enumerate(cur.fetchall())
    ]
    return render_template_string(_LEADERBOARD_HTML, entries=entries)


@app.route('/view/puzzles')
def view_puzzles():
    cur = _cursor()
    cur.execute('''
        SELECT crowdle_puzzles.id, crowdle_users.username AS creator, crowdle_puzzles.status, crowdle_puzzles.word
        FROM crowdle_puzzles
        JOIN crowdle_users ON crowdle_puzzles.creator_id = crowdle_users.id
        ORDER BY crowdle_puzzles.id DESC
    ''')
    puzzle_rows = cur.fetchall()

    puzzles = []
    for row in puzzle_rows:
        cur.execute('''
            SELECT crowdle_users.username, crowdle_guesses.word, crowdle_guesses.clue
            FROM crowdle_guesses
            JOIN crowdle_users ON crowdle_guesses.user_id = crowdle_users.id
            WHERE crowdle_guesses.puzzle_id = %s
            ORDER BY crowdle_guesses.id ASC
        ''', (row['id'],))
        guesses = [
            {'username': g['username'], 'word': g['word'], 'clue': json.loads(g['clue'])}
            for g in cur.fetchall()
        ]
        puzzles.append({
            'creator': row['creator'],
            'status':  row['status'],
            'word':    row['word'],
            'guesses': guesses,
        })

    return render_template_string(_PUZZLES_HTML, puzzles=puzzles)


# ── Error handlers ─────────────────────────────────────────────────────────────

# Override flask_jwt_extended's default responses so all errors use 'error' key.
@jwt.invalid_token_loader
def invalid_token_callback(reason):
    return jsonify({'error': f'Invalid token: {reason}'}), 422

@jwt.unauthorized_loader
def missing_token_callback(reason):
    return jsonify({'error': f'Authorization required: {reason}'}), 401

@jwt.expired_token_loader
def expired_token_callback(_header, _payload):
    return jsonify({'error': 'Token has expired — please log in again'}), 401

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
