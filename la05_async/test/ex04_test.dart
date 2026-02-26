import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la05_async/leaderboard_screen.dart';
import 'package:la05_async/quiz_service.dart';

QuizService _makeQuiz() =>
    QuizService(playerName: 'Tester', delay: Duration.zero);

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  group('Exercise 4 — FutureBuilder (LeaderboardScreen)', () {
    testWidgets('shows a loading indicator while the leaderboard is loading',
        (tester) async {
      await tester.pumpWidget(_wrap(LeaderboardScreen(quiz: _makeQuiz())));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Drain the pending timer so the test framework doesn't complain.
      await tester.pumpAndSettle();
    });

    testWidgets('shows leaderboard entries after loading', (tester) async {
      await tester.pumpWidget(_wrap(LeaderboardScreen(quiz: _makeQuiz())));
      await tester.pumpAndSettle();

      // Seeded entries from QuizService.
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('Diana'), findsOneWidget);
    });

    testWidgets('includes the current player on the leaderboard',
        (tester) async {
      await tester.pumpWidget(_wrap(LeaderboardScreen(quiz: _makeQuiz())));
      await tester.pumpAndSettle();

      expect(find.text('Tester'), findsOneWidget);
    });

    testWidgets('loading indicator disappears after leaderboard loads',
        (tester) async {
      await tester.pumpWidget(_wrap(LeaderboardScreen(quiz: _makeQuiz())));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('entries are displayed as ListTiles', (tester) async {
      await tester.pumpWidget(_wrap(LeaderboardScreen(quiz: _makeQuiz())));
      await tester.pumpAndSettle();

      // 4 seeded entries + the current player = 5 rows.
      expect(find.byType(ListTile), findsNWidgets(5));
    });

    testWidgets('score is displayed for each entry', (tester) async {
      await tester.pumpWidget(_wrap(LeaderboardScreen(quiz: _makeQuiz())));
      await tester.pumpAndSettle();

      // Check that Alice's score appears in some form.
      expect(find.textContaining('90'), findsOneWidget);
    });
  });
}
