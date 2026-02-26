// These imports and elements are used by code that students will add in the
// exercises. The _isSubmitting field is mutable — students assign to it in ex2.
// ignore_for_file: unused_import, unused_element, prefer_final_fields
import 'package:flutter/material.dart';

import 'leaderboard_screen.dart';
import 'models.dart';
import 'quiz_service.dart';
import 'result_screen.dart';

/// Displays one question at a time and manages the game loop.
///
/// Exercises 1, 2, and 3 are all implemented in this file.
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key, required this.quiz});

  final QuizService quiz;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // ---------------------------------------------------------------------------
  // Exercise 1 — FutureBuilder
  // ---------------------------------------------------------------------------
  //
  // TODO 1a: Declare a field:
  //   late Future<Question> _questionFuture;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // TODO 1b: Initialize _questionFuture here by calling
    //          widget.quiz.fetchQuestion().
  }

  // ---------------------------------------------------------------------------
  // Exercise 2 — async / await
  // ---------------------------------------------------------------------------

  /// Called when the player taps one of the answer buttons.
  ///
  /// TODO 2a: At the start of this method, set [_isSubmitting] to `true`
  ///          inside a [setState] call. This disables the answer buttons and
  ///          shows a loading indicator while the answer is being checked.
  ///
  /// TODO 2b: Use `await` to call [widget.quiz.submitAnswer] with
  ///          [question.id] and [answer]. Store the returned [AnswerResult].
  ///
  /// TODO 2c: At the end of this method (use a `try/finally` block), set
  ///          [_isSubmitting] back to `false` inside a [setState] call.
  ///          Check [mounted] before calling [setState].
  ///
  /// (Exercise 3 extends this method — see TODOs 3a and 3b below.)
  Future<void> _onAnswerSelected(Question question, String answer) async {
    // TODO 2a — set _isSubmitting = true

    try {
      // TODO 2b — await widget.quiz.submitAnswer(question.id, answer)

      // -----------------------------------------------------------------------
      // Exercise 3 — Navigation with Future return
      // -----------------------------------------------------------------------
      //
      // TODO 3a: Push [ResultScreen] onto the navigator and await the result.
      //
      //   final continueGame = await Navigator.push<bool>(
      //     context,
      //     MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
      //   );
      //
      //   Always check [mounted] before using [context] after an await:
      //   if (!mounted) return;
      //
      // TODO 3b: Decide what to do next based on [continueGame]:
      //
      //   • If continueGame == true AND widget.quiz.hasMoreQuestions:
      //       Call setState to update _questionFuture with a fresh call to
      //       widget.quiz.fetchQuestion(). This triggers the FutureBuilder to
      //       show a loading indicator and then display the next question.
      //
      //   • Otherwise (player chose "End Game" or all questions are exhausted):
      //       Navigate to LeaderboardScreen using Navigator.pushReplacement so
      //       the player cannot go back to the quiz:
      //
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(
      //             builder: (_) => LeaderboardScreen(quiz: widget.quiz),
      //           ),
      //         );
      //
      //   Check [mounted] before using [context].
    } finally {
      // TODO 2c — set _isSubmitting = false (check mounted first)
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Question ${widget.quiz.currentQuestion} '
          'of ${QuizService.totalQuestions}',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Score: ${widget.quiz.score}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      // TODO 1c: Replace this Placeholder with a FutureBuilder<Question>.
      //
      // The FutureBuilder should use _questionFuture as its future and:
      //   • While waiting  (snapshot.connectionState == ConnectionState.waiting):
      //       Return a centered CircularProgressIndicator.
      //   • When data is available (snapshot.hasData):
      //       Call _buildQuestion(snapshot.data!) and return its result.
      //   • When an error occurred (snapshot.hasError):
      //       Return a centered Text widget showing snapshot.error.toString().
      body: const Placeholder(),
    );
  }

  /// Builds the question card with answer buttons.
  ///
  /// Called by the FutureBuilder once [question] has loaded.
  Widget _buildQuestion(Question question) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            question.text,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // TODO 1d: Replace this Placeholder with one OutlinedButton per
          //          answer option.
          //
          // For each option in question.options, create:
          //
          //   OutlinedButton(
          //     onPressed: _isSubmitting ? null : () => _onAnswerSelected(question, option),
          //     child: Text(option),
          //   )
          //
          // Setting onPressed to null disables the button — this prevents the
          // player from tapping multiple answers while Exercise 2's submission
          // is in flight.
          //
          // Wrap all buttons in a Column with
          // crossAxisAlignment: CrossAxisAlignment.stretch so they fill the
          // available width, and add a small SizedBox(height: 12) between them.
          const Placeholder(),
          if (_isSubmitting) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
