import 'models.dart';

// ---------------------------------------------------------------------------
// Trivia question bank (provided — do not modify)
// ---------------------------------------------------------------------------

const _kQuestions = <Question>[
  Question(
    id: 'q01',
    text: 'What is the capital of Australia?',
    options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
  ),
  Question(
    id: 'q02',
    text: 'How many sides does a hexagon have?',
    options: ['5', '6', '7', '8'],
  ),
  Question(
    id: 'q03',
    text: 'Which planet is known as the Red Planet?',
    options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
  ),
  Question(
    id: 'q04',
    text: 'Who painted the Mona Lisa?',
    options: ['Michelangelo', 'Raphael', 'Leonardo da Vinci', 'Botticelli'],
  ),
  Question(
    id: 'q05',
    text: 'What is the chemical symbol for gold?',
    options: ['Ag', 'Au', 'Gd', 'Gl'],
  ),
  Question(
    id: 'q06',
    text: 'How many bones does the adult human body have?',
    options: ['196', '206', '216', '226'],
  ),
  Question(
    id: 'q07',
    text: 'What year did the first iPhone launch?',
    options: ['2005', '2006', '2007', '2008'],
  ),
  Question(
    id: 'q08',
    text: 'What is the largest ocean on Earth?',
    options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
  ),
  Question(
    id: 'q09',
    text: 'How many legs does a spider have?',
    options: ['6', '8', '10', '12'],
  ),
  Question(
    id: 'q10',
    text: 'Which company created the Flutter framework?',
    options: ['Apple', 'Microsoft', 'Facebook', 'Google'],
  ),
];

// Private map of question ID → correct answer.
// Correct answers are intentionally hidden from the Question model so that
// players must call submitAnswer() to find out whether they were right.
const _kAnswerKey = <String, String>{
  'q01': 'Canberra',
  'q02': '6',
  'q03': 'Mars',
  'q04': 'Leonardo da Vinci',
  'q05': 'Au',
  'q06': '206',
  'q07': '2007',
  'q08': 'Pacific',
  'q09': '8',
  'q10': 'Google',
};

const _kPointsPerCorrect = 10;

// Seeded leaderboard data (the current player's score is appended at runtime).
const _kBaseLeaderboard = <LeaderboardEntry>[
  LeaderboardEntry(playerName: 'Alice', score: 90),
  LeaderboardEntry(playerName: 'Bob', score: 70),
  LeaderboardEntry(playerName: 'Charlie', score: 60),
  LeaderboardEntry(playerName: 'Diana', score: 50),
];

// ---------------------------------------------------------------------------
// QuizException
// ---------------------------------------------------------------------------

/// Thrown by [QuizService] when a simulated network error occurs.
///
/// Only thrown when [QuizService] is constructed with `simulateErrors: true`.
/// See the bonus exercise in the README for details.
class QuizException implements Exception {
  const QuizException(this.message);

  final String message;

  @override
  String toString() => 'QuizException: $message';
}

// ---------------------------------------------------------------------------
// QuizService
// ---------------------------------------------------------------------------

/// Manages quiz state and provides asynchronous quiz operations.
///
/// This class is **provided** — do not modify it.
///
/// Create exactly one instance per game session:
/// ```dart
/// final quiz = QuizService(playerName: 'Alice');
/// ```
///
/// In tests, pass `delay: Duration.zero` so futures resolve instantly:
/// ```dart
/// final quiz = QuizService(playerName: 'Tester', delay: Duration.zero);
/// ```
class QuizService {
  QuizService({
    required this.playerName,
    this.delay = const Duration(milliseconds: 800),
    this.simulateErrors = false,
  });

  /// The player's display name, shown on the leaderboard.
  final String playerName;

  /// Simulated network delay applied to every async operation.
  ///
  /// Defaults to 800 ms. Set to [Duration.zero] in tests.
  final Duration delay;

  /// When `true`, [fetchQuestion] throws a [QuizException] on the 5th question.
  ///
  /// Leave `false` (the default) for normal gameplay.
  /// See the bonus exercise in the README.
  final bool simulateErrors;

  int _score = 0;
  int _questionIndex = 0;

  /// The player's accumulated score.
  int get score => _score;

  /// The number of the question currently being played (1-based).
  ///
  /// Increments as soon as [fetchQuestion] is called, so the AppBar can show
  /// the correct question number even while the question is still loading.
  int get currentQuestion => _questionIndex;

  /// The total number of questions in a game session.
  static const totalQuestions = 10;

  /// Whether there are still questions remaining in this session.
  bool get hasMoreQuestions => _questionIndex < _kQuestions.length;

  /// Returns the next [Question] for this session.
  ///
  /// Simulates a network delay of [delay].
  ///
  /// Throws [StateError] if no questions remain.
  /// Throws [QuizException] if [simulateErrors] is `true` and this is the 5th
  /// question — use this to practice error handling in Exercise 1's bonus.
  Future<Question> fetchQuestion() async {
    if (!hasMoreQuestions) {
      throw StateError('No more questions available.');
    }
    // Increment before the delay so currentQuestion is correct immediately.
    final index = _questionIndex++;
    await Future.delayed(delay);
    if (simulateErrors && index == 4) {
      throw const QuizException('Failed to load question. Please try again.');
    }
    return _kQuestions[index];
  }

  /// Submits [answer] for the question identified by [questionId].
  ///
  /// Returns an [AnswerResult] that includes whether the answer was correct,
  /// the correct answer text, and the points earned.
  ///
  /// Simulates a network delay of [delay].
  Future<AnswerResult> submitAnswer(String questionId, String answer) async {
    await Future.delayed(delay);
    final correct = _kAnswerKey[questionId]!;
    final isCorrect = answer == correct;
    final points = isCorrect ? _kPointsPerCorrect : 0;
    _score += points;
    return AnswerResult(
      selectedAnswer: answer,
      correctAnswer: correct,
      isCorrect: isCorrect,
      pointsEarned: points,
    );
  }

  /// Returns the leaderboard sorted by score (descending), including the
  /// current player's entry.
  ///
  /// Simulates a network delay of [delay].
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    await Future.delayed(delay);
    final entries = List<LeaderboardEntry>.from(_kBaseLeaderboard)
      ..add(LeaderboardEntry(playerName: playerName, score: _score));
    entries.sort((a, b) => b.score.compareTo(a.score));
    return entries;
  }
}
