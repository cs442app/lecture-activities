/// Data models for the Trivia Quiz activity.
///
/// This file is provided — do not modify it.
library;

/// A single trivia question with multiple-choice answer options.
class Question {
  const Question({
    required this.id,
    required this.text,
    required this.options,
  });

  /// Unique identifier used when submitting an answer.
  final String id;

  /// The question text to display to the player.
  final String text;

  /// The list of answer choices. Always contains exactly 4 options.
  final List<String> options;
}

/// The outcome of submitting an answer to a question.
class AnswerResult {
  const AnswerResult({
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.pointsEarned,
  });

  /// The answer the player selected.
  final String selectedAnswer;

  /// The correct answer for this question.
  final String correctAnswer;

  /// Whether the selected answer was correct.
  final bool isCorrect;

  /// Points earned for this answer (10 if correct, 0 if not).
  final int pointsEarned;
}

/// One row on the leaderboard.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.playerName,
    required this.score,
  });

  final String playerName;
  final int score;
}
