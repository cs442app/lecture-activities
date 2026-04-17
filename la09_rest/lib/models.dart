// Data models for Crowdle.

/// The result for one letter position in a Wordle-style clue.
enum ClueResult {
  /// Right letter, right position (green).
  correct,

  /// Right letter, wrong position (yellow).
  present,

  /// Letter not in the word (grey).
  absent,
}

/// A single guess submitted for a puzzle, together with its clue.
class Guess {
  final int id;
  final String username;
  final String word;
  final List<ClueResult> clue;

  const Guess({
    required this.id,
    required this.username,
    required this.word,
    required this.clue,
  });

  factory Guess.fromJson(Map<String, dynamic> json) => Guess(
        id: json['id'] as int,
        username: json['username'] as String,
        word: json['word'] as String,
        clue: (json['clue'] as List)
            .map((s) => ClueResult.values.byName(s as String))
            .toList(),
      );
}

/// A Crowdle puzzle — a 5-letter word submitted by one player for others to guess.
///
/// In list views [guesses] is empty; in detail views it contains the full
/// guess history.  [word] is only non-null when [status] == 'solved'.
class Puzzle {
  final int id;
  final String creator;
  final int creatorId;
  final String status; // 'active' | 'solved'
  final int guessCount;
  final List<ClueResult>? lastClue;
  final String? lastGuesser;
  final String? word;
  final List<Guess> guesses;

  const Puzzle({
    required this.id,
    required this.creator,
    required this.creatorId,
    required this.status,
    required this.guessCount,
    this.lastClue,
    this.lastGuesser,
    this.word,
    this.guesses = const [],
  });

  bool get isSolved => status == 'solved';
  bool get isActive => status == 'active';

  factory Puzzle.fromJson(Map<String, dynamic> json) => Puzzle(
        id: json['id'] as int,
        creator: json['creator'] as String,
        creatorId: json['creator_id'] as int,
        status: json['status'] as String,
        guessCount: json['guess_count'] as int,
        lastClue: json['last_clue'] == null
            ? null
            : (json['last_clue'] as List)
                .map((s) => ClueResult.values.byName(s as String))
                .toList(),
        lastGuesser: json['last_guesser'] as String?,
        word: json['word'] as String?,
        guesses: json['guesses'] == null
            ? const []
            : (json['guesses'] as List)
                .map((g) => Guess.fromJson(g as Map<String, dynamic>))
                .toList(),
      );
}

/// The currently authenticated user's profile.
class User {
  final int id;
  final String username;
  final int score;

  const User({
    required this.id,
    required this.username,
    required this.score,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        username: json['username'] as String,
        score: json['score'] as int,
      );
}

/// One row of the leaderboard.
class LeaderboardEntry {
  final int rank;
  final String username;
  final int score;

  const LeaderboardEntry({
    required this.rank,
    required this.username,
    required this.score,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        rank: json['rank'] as int,
        username: json['username'] as String,
        score: json['score'] as int,
      );
}
