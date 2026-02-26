import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la05_async/question_screen.dart';
import 'package:la05_async/quiz_service.dart';

QuizService _makeQuiz() =>
    QuizService(playerName: 'Tester', delay: Duration.zero);

void main() {
  group('Exercise 2 — async/await (answer submission)', () {
    testWidgets('answer buttons are disabled while submission is in flight',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle(); // load Q1

      // Tap an answer.
      await tester.tap(find.text('Canberra'));
      // Pump one frame so setState(_isSubmitting = true) takes effect,
      // but before the submitAnswer future resolves.
      await tester.pump();

      // All four answer buttons should now be disabled.
      final buttons =
          tester.widgetList<OutlinedButton>(find.byType(OutlinedButton));
      for (final btn in buttons) {
        expect(
          btn.onPressed,
          isNull,
          reason: 'Button should be disabled while submitting',
        );
      }
    });

    testWidgets('a submitting indicator appears while the answer is checked',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Canberra'));
      await tester.pump(); // _isSubmitting = true rebuild

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('submitting indicator disappears after answer is processed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Canberra'));
      await tester.pumpAndSettle(); // complete submitAnswer + any navigation

      // The submitting indicator (inside _buildQuestion) should be gone.
      // (There may be a new loading indicator if the next question is loading —
      // but pumpAndSettle will clear that too.)
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
