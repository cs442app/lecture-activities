# Activity 9: REST — Crowdle

## Learning Objectives

By the end of this activity you will be able to:

- Make authenticated HTTP requests from Flutter using the `http` package, attaching a JWT in the `Authorization: Bearer` header.
- Persist a JWT across app launches using `SharedPreferences` and use it to gate navigation at startup.
- Decode JSON responses into typed Dart model objects and propagate server-side error messages to the UI.
- Handle specific HTTP status codes (401, 403, 409, 410, 422) in `catch` blocks to display contextual error messages rather than generic failures.
- Use `FutureBuilder` to load and display data from a REST API.
- Combine multiple concurrent futures with `Future.wait`.

---

## Background

### REST and HTTP

A **REST API** is a web service where each URL represents a *resource* (a puzzle, a user, a leaderboard) and standard HTTP methods express intent:

| Method   | Typical use                  |
|----------|------------------------------|
| `GET`    | Read a resource              |
| `POST`   | Create a new resource        |
| `PUT`    | Replace a resource           |
| `DELETE` | Remove a resource            |

Responses carry an HTTP **status code** alongside the body. The 2xx range signals success; 4xx signals a client error. Your Flutter code must check the status code and handle errors gracefully rather than assuming every response is valid data.

```
200 OK           — success (read, login)
201 Created      — resource was created (new puzzle, new guess)
401 Unauthorized — missing or invalid JWT
403 Forbidden    — authenticated but not allowed (guessing your own puzzle)
404 Not Found    — resource doesn't exist
409 Conflict     — rule violation (consecutive-guess rule)
410 Gone         — resource exists but is no longer actionable (solved puzzle)
422 Unprocessable — request is well-formed but semantically invalid (not a real word)
```

### JWT Authentication

A **JSON Web Token (JWT)** is a signed string that encodes the user's identity. The server issues one on login/register; the client stores it and includes it in every protected request via the `Authorization` header:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

The server verifies the signature and extracts the user ID without a database lookup. Because the token is self-contained, the server can be stateless — no session table required.

### The `http` Package

The `http` package provides simple async functions for making HTTP requests:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// GET
final response = await http.get(Uri.parse('$baseUrl/puzzles'));

// POST with JSON body
final response = await http.post(
  Uri.parse('$baseUrl/puzzles'),
  headers: {'Content-Type': 'application/json',
             'Authorization': 'Bearer $token'},
  body: jsonEncode({'word': 'crane'}),
);

// Decode the body
final data = jsonDecode(response.body);
```

Always check `response.statusCode` before using the body — a 4xx response still has a body (the error message), but it is not the data you expect.

### Persisting the JWT

The JWT must survive app restarts. `SharedPreferences` is the right tool:

```dart
// Save on login
final prefs = await SharedPreferences.getInstance();
await prefs.setString('jwt_token', token);

// Load at startup
final token = prefs.getString('jwt_token'); // null if not logged in

// Clear on logout
await prefs.remove('jwt_token');
```

---

## The App — Crowdle

**Crowdle** is a crowd-sourced Wordle played simultaneously by the whole class.

- Any player can **submit a 5-letter word** as a puzzle for others to guess.
- Anyone can **view all puzzles** and their public guess histories.
- Guesses are **Wordle-style**: each tile turns green (right position), yellow (right letter, wrong position), or grey (not in the word).
- **Consecutive-guess rule**: you must wait for at least one other player to guess before you can guess again on the same puzzle.
- **Scoring**:
  - The player who guesses correctly earns `max(1, 11 − total_guesses)` points.
  - The puzzle creator earns `floor(total_guesses / 2)` points — harder puzzles earn more.

---

## API Reference

Base URL: **`https://your-app.onrender.com`** (replace with the URL on the board).

All request and response bodies are JSON. Endpoints marked **[JWT]** require the `Authorization: Bearer <token>` header.

### Auth

| Method | Path        | Body                         | Response                                         |
|--------|-------------|------------------------------|--------------------------------------------------|
| POST   | `/register` | `{username, password}`       | `{access_token, username, message}`              |
| POST   | `/login`    | `{username, password}`       | `{access_token, username, message}`              |
| GET    | `/me`       | —                       [JWT] | `{id, username, score}`                          |

### Puzzles

| Method | Path                       | Body            | Response                                            |
|--------|----------------------------|-----------------|-----------------------------------------------------|
| GET    | `/puzzles`                 | —               | Array of puzzle summary objects (see below)          |
| GET    | `/puzzles/<id>`            | —               | Puzzle detail object with full `guesses` array       |
| POST   | `/puzzles`                 | `{word}`   [JWT] | Created puzzle object                                |
| POST   | `/puzzles/<id>/guesses`    | `{word}`   [JWT] | `{id, word, clue, solved, points_earned?}`           |

### Leaderboard

| Method | Path           | Body | Response                                        |
|--------|----------------|------|-------------------------------------------------|
| GET    | `/leaderboard` | —    | Array of `{rank, username, score}` objects       |

### Puzzle object (summary)

```json
{
  "id": 3,
  "creator": "alice",
  "creator_id": 1,
  "status": "active",
  "guess_count": 4,
  "last_clue": ["correct", "absent", "present", "absent", "absent"],
  "last_guesser": "bob",
  "word": null
}
```

`word` is `null` while the puzzle is active and revealed once it is `"solved"`.

### Puzzle object (detail — `GET /puzzles/<id>`)

Same fields as the summary, plus a `guesses` array:

```json
{
  "id": 3,
  "creator": "alice",
  "creator_id": 1,
  "status": "active",
  "guess_count": 4,
  "word": null,
  "guesses": [
    {
      "id": 11,
      "username": "bob",
      "word": "crane",
      "clue": ["absent", "correct", "absent", "present", "absent"],
      "created_at": "2026-04-16T14:03:22"
    }
  ]
}
```

### Guess response (`POST /puzzles/<id>/guesses`)

```json
{
  "id": 12,
  "word": "cloud",
  "clue": ["correct", "correct", "correct", "correct", "correct"],
  "solved": true,
  "points_earned": 8
}
```

`points_earned` is only present when `solved` is `true`.

### Error responses

All errors return `{"error": "<message>"}` with the appropriate status code:

| Code | Meaning                                  |
|------|------------------------------------------|
| 401  | Missing or invalid JWT                   |
| 403  | You cannot guess your own puzzle         |
| 404  | Puzzle not found                         |
| 409  | Consecutive-guess rule violated          |
| 410  | Puzzle is already solved                 |
| 422  | Validation failed (bad word, bad length) |

---

## File Structure

```
lib/
├── main.dart                   # Entry point — provided, do not modify
├── models.dart                 # Provided — Guess, Puzzle, User, LeaderboardEntry
├── api_service.dart            # SKELETON ← Exercises 1–5: all API calls
└── widgets/
│   └── clue_tile.dart          # Provided — CluePreview, ClueRow, ClueTile
└── screens/
    ├── auth_screen.dart        # SKELETON ← Exercise 1: login & register
    ├── puzzle_list_screen.dart # SKELETON ← Exercise 2: browse puzzles
    ├── puzzle_detail_screen.dart # SKELETON ← Exercise 3: view clues & guess
    ├── submit_word_screen.dart # SKELETON ← Exercise 4: submit a word
    └── leaderboard_screen.dart # SKELETON ← Exercise 5: rankings
test/
└── widget_test.dart            # No automated tests — verify visually
server/
├── app.py                      # Flask backend (instructor only)
├── requirements.txt
└── Procfile
```

---

## Exercise 1: Authentication (`api_service.dart`, `auth_screen.dart`)

Users must register or log in before they can guess or submit puzzles. The JWT returned by the server is stored in `SharedPreferences` so the user stays logged in across app restarts.

### What to implement

**TODO 1.1 — `ApiService.register()`** (`lib/api_service.dart`):

```dart
Future<void> register(String username, String password) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/register'),
    headers: _jsonHeaders,
    body: jsonEncode({'username': username, 'password': password}),
  );
  final data = _decode(response); // throws ApiException on error
  await _saveToken(data['access_token'] as String, data['username'] as String);
}
```

**TODO 1.2 — `ApiService.login()`**: Same structure as `register` but POST to `/login`.

**TODO 1.3 — `ApiService.logout()`**: One line — call `_clearToken()`.

**TODO 1.1 — `_AuthScreenState._login()`** (`lib/screens/auth_screen.dart`):

```dart
Future<void> _login() async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text;
  _setLoading(true);
  try {
    await widget.api.login(username, password);
    if (!mounted) return;
    _goHome();
  } on ApiException catch (e) {
    if (!mounted) return;
    _showError(e.message);
  }
}
```

**TODO 1.2 — `_AuthScreenState._register()`**: Same structure, call `widget.api.register()`.

### Run and verify

Launch the app. You should land on the login screen. Register with a username and password — you should be taken to the (stub) puzzle list. Kill and relaunch: because the JWT is persisted, you should go straight to the puzzle list without logging in again. Tap Log out and verify you return to the login screen.

---

## Exercise 2: Puzzle List (`api_service.dart`, `puzzle_list_screen.dart`)

### What to implement

**TODO 2.1 — `ApiService.getPuzzles()`** (`lib/api_service.dart`):

```dart
Future<List<Puzzle>> getPuzzles() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/puzzles'),
    headers: _jsonHeaders,
  );
  final data = _decode(response) as List;
  return data.map((e) => Puzzle.fromJson(e as Map<String, dynamic>)).toList();
}
```

**TODO 2.1–2.4** (`lib/screens/puzzle_list_screen.dart`): Declare `futurePuzzles`, assign it in `initState`, implement `_loadPuzzles()`, and implement `_refresh()`.

**TODO 2.5** — Build the `FutureBuilder` body. Each `ListTile` should show the creator's name, guess count, a "SOLVED" chip when appropriate, and a `CluePreview` of the last clue as the trailing widget.

### Run and verify

The puzzle list should load when the app starts. It will be empty until someone submits a word (Exercise 4). Pull-to-refresh or tap the refresh button and verify the list updates.

---

## Exercise 3: Puzzle Detail & Guessing (`api_service.dart`, `puzzle_detail_screen.dart`)

### What to implement

**TODO 3.1 — `ApiService.getPuzzle(int id)`** (`lib/api_service.dart`):

```dart
Future<Puzzle> getPuzzle(int id) async {
  final response = await http.get(Uri.parse('$_baseUrl/puzzles/$id'));
  return Puzzle.fromJson(_decode(response) as Map<String, dynamic>);
}
```

**TODO 3.1a–d** (`lib/screens/puzzle_detail_screen.dart`): Declare `futurePuzzle`, wire up `initState`, implement `_loadPuzzle()`, and implement `_refresh()`.

**TODO 3.2 — `ApiService.submitGuess()`** (`lib/api_service.dart`):

```dart
Future<Map<String, dynamic>> submitGuess(int puzzleId, String word) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/puzzles/$puzzleId/guesses'),
    headers: _authHeaders,
    body: jsonEncode({'word': word}),
  );
  final data = _decode(response) as Map<String, dynamic>;
  final clue = (data['clue'] as List)
      .map((s) => ClueResult.values.byName(s as String))
      .toList();
  return {
    'clue': clue,
    'solved': data['solved'] as bool,
    if (data.containsKey('points_earned'))
      'points_earned': data['points_earned'] as int,
  };
}
```

**TODO 3.2** (`lib/screens/puzzle_detail_screen.dart`): Implement `_submitGuess(puzzle)`. After a successful guess, clear the text field and call `_refresh()`. If `result['solved'] == true`, show a SnackBar with the points earned. On `ApiException`, set `_guessError` to the message (it appears in the text field's `errorText`).

**TODO 3.3** — Replace `future: null` in the `FutureBuilder` with `futurePuzzle`.

### Run and verify

Tap a puzzle from the list. The full clue history should appear as coloured `ClueRow` tiles. Type a 5-letter word and tap Guess. The tiles should update immediately after a successful guess. Verify each error case:
- Try guessing a non-word (e.g. "zzzzz") → "Not a valid English word"
- Guess twice in a row before anyone else guesses → "Wait for another player..."
- Try to guess on a puzzle you created → the input is disabled

---

## Exercise 4: Submitting a Word (`api_service.dart`, `submit_word_screen.dart`)

### What to implement

**TODO 4.1 — `ApiService.createPuzzle()`** (`lib/api_service.dart`):

```dart
Future<Puzzle> createPuzzle(String word) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/puzzles'),
    headers: _authHeaders,
    body: jsonEncode({'word': word}),
  );
  return Puzzle.fromJson(_decode(response) as Map<String, dynamic>);
}
```

**TODO 4.1** (`lib/screens/submit_word_screen.dart`): Implement `_submit()`. On success, set `_success = true` and clear the text field. On `ApiException`, set `_error` to the message (shown as the field's `errorText`).

### Run and verify

Tap the **New Puzzle** FAB from the puzzle list. Submit a valid 5-letter word (e.g. "crane"). You should see the success message. Navigate back to the list and verify your puzzle appears. Test the validation errors:
- A word that is too short or too long → "Word must be exactly 5 letters"
- A nonsense string like "aaaaa" → "Not a valid English word"

---

## Exercise 5: Leaderboard (`api_service.dart`, `leaderboard_screen.dart`)

### What to implement

**TODO 5.1 — `ApiService.getMe()`** (`lib/api_service.dart`):

```dart
Future<User> getMe() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/me'),
    headers: _authHeaders,
  );
  return User.fromJson(_decode(response) as Map<String, dynamic>);
}
```

**TODO 5.2 — `ApiService.getLeaderboard()`**:

```dart
Future<List<LeaderboardEntry>> getLeaderboard() async {
  final response = await http.get(Uri.parse('$_baseUrl/leaderboard'));
  final data = _decode(response) as List;
  return data
      .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

**TODO 5.1–5.3** (`lib/screens/leaderboard_screen.dart`): Declare both futures and assign them in `initState`. Build a `FutureBuilder` with `Future.wait([futureEntries!, futureMe!])`. Highlight the row where `entry.username == me.username` with a `Colors.green[50]` background.

### Run and verify

Open the leaderboard. Your row should appear highlighted. Solve a puzzle and return to the leaderboard — your score should have increased.

---

## Submission

1. Complete all five exercises.
2. Run `flutter analyze` and fix any issues.
3. Complete `REPORT.md`.
4. Commit and push.
