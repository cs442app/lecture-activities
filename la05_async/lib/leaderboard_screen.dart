// models.dart is used by code that students will add in the exercises.
// ignore_for_file: unused_import
import 'package:flutter/material.dart';

import 'models.dart';
import 'quiz_service.dart';

/// Displays the leaderboard at the end of a game session.
///
/// Exercise 4 is implemented in this file.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key, required this.quiz});

  final QuizService quiz;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // ---------------------------------------------------------------------------
  // Exercise 4 — FutureBuilder (leaderboard)
  // ---------------------------------------------------------------------------
  //
  // TODO 4a: Declare a field:
  //   late Future<List<LeaderboardEntry>> _leaderboardFuture;
  //
  // Storing the Future in a field (rather than calling fetchLeaderboard()
  // directly inside build) ensures the leaderboard is only fetched once, even
  // if the widget rebuilds for any reason. This is the standard pattern
  // whenever you use FutureBuilder inside a StatefulWidget.

  @override
  void initState() {
    super.initState();
    // TODO 4b: Initialize _leaderboardFuture here by calling
    //          widget.quiz.fetchLeaderboard().
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // end of game — no back button
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Leaderboard'),
      ),
      // TODO 4c: Replace this Placeholder with a FutureBuilder<List<LeaderboardEntry>>.
      //
      // The FutureBuilder should use _leaderboardFuture as its future and:
      //
      //   • While waiting: return a centered CircularProgressIndicator.
      //
      //   • When data is available: build a ListView of the entries.
      //     For each entry at index i, show a ListTile with:
      //       leading  : Text('${i + 1}.')           (rank number)
      //       title    : Text(entry.playerName)
      //       trailing : Text('${entry.score} pts')
      //     Highlight the current player's row by checking
      //     entry.playerName == widget.quiz.playerName.
      //     (Hint: use a different background colour with a ColoredBox or
      //     ListTile's tileColor property.)
      //
      //   • When an error occurred: return a centered Text with the error.
      body: const Placeholder(),
    );
  }
}
