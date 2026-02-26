import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la05_async/question_screen.dart';
import 'package:la05_async/quiz_service.dart';
import 'package:la05_async/result_screen.dart';

QuizService _makeQuiz() =>
    QuizService(playerName: 'Tester', delay: Duration.zero);

void main() {
  group('Exercise 3 — Navigation with Future return (ResultScreen)', () {
    // -------------------------------------------------------------------------
    // ResultScreen content
    // -------------------------------------------------------------------------

    testWidgets('ResultScreen shows "Correct!" for a correct answer',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle(); // load Q1

      await tester.tap(find.text('Canberra')); // correct answer
      await tester.pumpAndSettle(); // submit + navigate to ResultScreen

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('Correct!'), findsOneWidget);
    });

    testWidgets('ResultScreen shows "Incorrect!" for a wrong answer',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sydney')); // wrong answer
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('Incorrect!'), findsOneWidget);
    });

    testWidgets('ResultScreen always shows the correct answer text',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();

      // Answer incorrectly so we definitely need to see the correct answer.
      await tester.tap(find.text('Sydney'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Canberra'), findsOneWidget);
    });

    testWidgets('ResultScreen has a "Next Question" button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Canberra'));
      await tester.pumpAndSettle();

      expect(find.text('Next Question'), findsOneWidget);
    });

    testWidgets('ResultScreen has an "End Game" button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Canberra'));
      await tester.pumpAndSettle();

      expect(find.text('End Game'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Navigation
    // -------------------------------------------------------------------------

    testWidgets('"Next Question" loads the second question', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle(); // load Q1

      await tester.tap(find.text('Canberra')); // answer Q1
      await tester.pumpAndSettle(); // navigate to ResultScreen

      await tester.tap(find.text('Next Question'));
      await tester.pumpAndSettle(); // pop ResultScreen + load Q2

      // Q2 from the question bank.
      expect(find.text('How many sides does a hexagon have?'), findsOneWidget);
    });

    testWidgets('"End Game" navigates to the leaderboard', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Canberra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('End Game'));
      await tester.pumpAndSettle();

      // QuestionScreen should no longer be visible.
      expect(find.byType(QuestionScreen), findsNothing);
      // LeaderboardScreen headline or appBar title should appear.
      expect(find.text('Leaderboard'), findsOneWidget);
    });

    testWidgets('score increases after a correct answer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Canberra')); // correct
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next Question'));
      await tester.pumpAndSettle(); // back on QuestionScreen

      // Score in the AppBar should now show 10.
      expect(find.text('Score: 10'), findsOneWidget);
    });

    testWidgets('score does not increase after a wrong answer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuestionScreen(quiz: _makeQuiz())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sydney')); // wrong
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next Question'));
      await tester.pumpAndSettle();

      expect(find.text('Score: 0'), findsOneWidget);
    });
  });
}
