import 'package:flutter/material.dart';

import 'models.dart';

/// Displays the outcome of a single answered question.
///
/// This screen is pushed by [QuestionScreen] after [QuizService.submitAnswer]
/// completes. It pops with a [bool] to tell [QuestionScreen] whether to
/// continue to the next question (`true`) or end the game (`false`).
///
/// Exercise 3 is implemented in this file.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final AnswerResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // no back button — use the buttons below
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO 3c: Display the answer result.
            //
            // Show all of the following (order and exact styling are up to you):
            //
            //   • A large icon:
            //       result.isCorrect → Icons.check_circle (green)
            //       otherwise        → Icons.cancel       (red)
            //
            //   • A headline:
            //       result.isCorrect → 'Correct!'
            //       otherwise        → 'Incorrect!'
            //
            //   • The correct answer (always show this, even when correct):
            //       Text('The correct answer was: ${result.correctAnswer}')
            //
            //   • Points earned:
            //       result.isCorrect → Text('+${result.pointsEarned} points')
            //       otherwise        → Text('No points this round')
            const Placeholder(),
            const SizedBox(height: 40),
            // TODO 3d: Add two buttons.
            //
            // 1. A FilledButton labelled 'Next Question' that pops this screen
            //    with the value true:
            //      Navigator.pop(context, true)
            //
            // 2. An OutlinedButton labelled 'End Game' that pops this screen
            //    with the value false:
            //      Navigator.pop(context, false)
            //
            // Add a SizedBox(height: 12) between the buttons.
            const Placeholder(),
          ],
        ),
      ),
    );
  }
}
