import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la05_async/question_screen.dart';
import 'package:la05_async/quiz_service.dart';

// Use Duration.zero so futures resolve immediately in tests.
QuizService _makeQuiz() =>
    QuizService(playerName: 'Tester', delay: Duration.zero);

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  group('Exercise 1 — FutureBuilder (QuestionScreen)', () {
    testWidgets('shows a loading indicator while the question is loading',
        (tester) async {
      await tester.pumpWidget(_wrap(QuestionScreen(quiz: _makeQuiz())));

      // After the first pump the FutureBuilder is in the waiting state.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Drain the pending timer so the test framework doesn't complain.
      await tester.pumpAndSettle();
    });

    testWidgets('shows the question text once the future resolves',
        (tester) async {
      await tester.pumpWidget(_wrap(QuestionScreen(quiz: _makeQuiz())));
      await tester.pumpAndSettle();

      // The first question in the bank.
      expect(find.text('What is the capital of Australia?'), findsOneWidget);
    });

    testWidgets('shows all four answer options', (tester) async {
      await tester.pumpWidget(_wrap(QuestionScreen(quiz: _makeQuiz())));
      await tester.pumpAndSettle();

      expect(find.text('Sydney'), findsOneWidget);
      expect(find.text('Melbourne'), findsOneWidget);
      expect(find.text('Canberra'), findsOneWidget);
      expect(find.text('Brisbane'), findsOneWidget);
    });

    testWidgets('answer options are rendered as buttons', (tester) async {
      await tester.pumpWidget(_wrap(QuestionScreen(quiz: _makeQuiz())));
      await tester.pumpAndSettle();

      // Each option should be tappable (wrapped in some kind of button widget).
      expect(find.byType(OutlinedButton), findsNWidgets(4));
    });

    testWidgets('loading indicator disappears after question loads',
        (tester) async {
      await tester.pumpWidget(_wrap(QuestionScreen(quiz: _makeQuiz())));

      // Confirm loading is shown first.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // After settling there should be no loading indicator.
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
