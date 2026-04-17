// ignore_for_file: unused_field, unused_element
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

/// Thrown when the server responds with a non-2xx status code.
///
/// [statusCode] is the HTTP status (e.g. 401, 410, 422).
/// [message]    is the human-readable error string from the response body.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

/// Central HTTP client for the Crowdle REST API.
///
/// A single instance is created in [main] (via [init]) and passed to every
/// screen as a constructor argument.  All JWT management is handled here —
/// screens never touch SharedPreferences directly.
class ApiService {
  static const String _baseUrl = 'https://crowdle.onrender.com';

  static const String _tokenKey    = 'jwt_token';
  static const String _usernameKey = 'username';

  String? _token;
  String? _username;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Loads a previously saved JWT from SharedPreferences.
  /// Must be called once after construction, before any API calls.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token    = prefs.getString(_tokenKey);
    _username = prefs.getString(_usernameKey);
  }

  /// Whether a JWT is currently stored (user is logged in).
  bool get isLoggedIn => _token != null;

  /// The username of the currently logged-in user, or null if not logged in.
  String? get currentUsername => _username;

  // ── Token management (provided) ────────────────────────────────────────────

  Future<void> _saveToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
    _token    = token;
    _username = username;
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    _token    = null;
    _username = null;
  }

  /// Headers for requests that require a valid JWT.
  Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  /// Headers for unauthenticated requests.
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  // ── Helper (provided) ──────────────────────────────────────────────────────

  /// Decodes the JSON response body and returns it on success (2xx).
  /// Throws [ApiException] for any non-2xx status code.
  dynamic _decode(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    final msg = body is Map
        ? (body['error'] ?? body['message'] ?? 'Request failed')
        : 'Request failed';
    throw ApiException(response.statusCode, msg as String);
  }

  // ── Exercise 1: Auth ───────────────────────────────────────────────────────

  /// Registers a new account with [username] and [password].
  ///
  /// On success the returned JWT is saved automatically.
  /// Throws [ApiException] on failure — notably:
  ///   409  username already taken
  ///
  /// TODO 1.1: Implement this method.
  ///   a. POST to '$_baseUrl/register' with JSON body {'username': username, 'password': password}.
  ///      Use _jsonHeaders (no JWT yet).
  ///   b. Decode the response with _decode() — this throws on any error status.
  ///   c. On success, call _saveToken(data['access_token'], data['username']).
  Future<void> register(String username, String password) async {
    // TODO 1.1
    throw UnimplementedError();
  }

  /// Logs in with [username] and [password].
  ///
  /// Throws [ApiException] on failure — notably:
  ///   401  wrong credentials
  ///
  /// TODO 1.2: Implement this method.
  ///   Same structure as register: POST to '$_baseUrl/login', save the token on success.
  Future<void> login(String username, String password) async {
    // TODO 1.2
    throw UnimplementedError();
  }

  /// Clears the stored JWT, effectively logging the user out.
  ///
  /// TODO 1.3: Implement this one-liner — call _clearToken().
  Future<void> logout() async {
    // TODO 1.3
    throw UnimplementedError();
  }

  // ── Exercise 2: Puzzle list ────────────────────────────────────────────────

  /// Returns all puzzles (active and solved), newest first.
  ///
  /// No authentication required.
  ///
  /// TODO 2.1: Implement this method.
  ///   a. GET '$_baseUrl/puzzles'.  Use _jsonHeaders.
  ///   b. Decode with _decode(), cast to List, map each element to Puzzle.fromJson().
  Future<List<Puzzle>> getPuzzles() async {
    // TODO 2.1
    throw UnimplementedError();
  }

  // ── Exercise 3: Puzzle detail & guessing ──────────────────────────────────

  /// Returns a single puzzle with its full guess history.
  ///
  /// TODO 3.1: Implement this method.
  ///   GET '$_baseUrl/puzzles/$id', decode, return Puzzle.fromJson(data).
  Future<Puzzle> getPuzzle(int id) async {
    // TODO 3.1
    throw UnimplementedError();
  }

  /// Submits [word] as a guess for puzzle [puzzleId].
  ///
  /// Returns a map with:
  ///   'clue'          → `List<ClueResult>`
  ///   'solved'        → bool
  ///   'points_earned' → int  (only present when solved is true)
  ///
  /// Throws [ApiException] — notably:
  ///   403  you are the puzzle creator
  ///   410  puzzle is already solved
  ///   422  not a valid English word
  ///
  /// TODO 3.2: Implement this method.
  ///   a. POST '$_baseUrl/puzzles/$puzzleId/guesses' with JSON body {'word': word}.
  ///      Use _authHeaders.
  ///   b. Decode with _decode().
  ///   c. Parse the clue list:
  ///        final clue = (data['clue'] as List)
  ///            .map((s) => ClueResult.values.byName(s as String))
  ///            .toList();
  ///   d. Return a map with 'clue', 'solved', and (if present) 'points_earned'.
  Future<Map<String, dynamic>> submitGuess(int puzzleId, String word) async {
    // TODO 3.2
    throw UnimplementedError();
  }

  // ── Exercise 4: Submitting a word ─────────────────────────────────────────

  /// Submits [word] as a new puzzle for others to solve.
  ///
  /// Throws [ApiException] — notably:
  ///   422  wrong length, not a real word, or inappropriate content
  ///
  /// TODO 4.1: Implement this method.
  ///   POST '$_baseUrl/puzzles' with JSON body {'word': word}.
  ///   Use _authHeaders.  Return Puzzle.fromJson(data).
  Future<Puzzle> createPuzzle(String word) async {
    // TODO 4.1
    throw UnimplementedError();
  }

  // ── Exercise 5: Leaderboard ───────────────────────────────────────────────

  /// Returns the current user's profile (id, username, score).
  ///
  /// TODO 5.1: Implement this method.
  ///   GET '$_baseUrl/me', use _authHeaders, return User.fromJson(data).
  Future<User> getMe() async {
    // TODO 5.1
    throw UnimplementedError();
  }

  /// Returns all players ranked by score, highest first.
  ///
  /// TODO 5.2: Implement this method.
  ///   GET '$_baseUrl/leaderboard'.  No auth needed.
  ///   Map each entry to LeaderboardEntry.fromJson() and return the list.
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    // TODO 5.2
    throw UnimplementedError();
  }
}
