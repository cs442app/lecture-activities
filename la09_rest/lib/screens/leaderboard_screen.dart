// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';

/// Ranked leaderboard screen. The current user's row is highlighted.
class LeaderboardScreen extends StatefulWidget {
  final ApiService api;

  const LeaderboardScreen({super.key, required this.api});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  /// TODO 5.1: Declare two nullable Future fields:
  ///   `Future<List<LeaderboardEntry>>?` futureEntries
  ///   `Future<User>?` futureMe
  // TODO 5.1

  @override
  void initState() {
    super.initState();
    /// TODO 5.2: Assign both futures here:
    ///   futureEntries = widget.api.getLeaderboard()
    ///   futureMe      = widget.api.getMe()
    // TODO 5.2
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),

      /// TODO 5.3: Replace the placeholder below with a FutureBuilder.
      ///
      /// Because we need both the leaderboard AND the current user's info,
      /// use Future.wait to combine the two futures:
      ///
      ///   future: Future.wait([futureEntries!, futureMe!])
      ///
      /// In the builder, unpack:
      ///   final entries = data[0] as List<LeaderboardEntry>;
      ///   final me      = data[1] as User;
      ///
      /// Build a ListView of the entries. For each entry, create a ListTile:
      ///   leading:  Text('${entry.rank}', style: bold)
      ///   title:    Text(entry.username)
      ///   trailing: Text('${entry.score} pts')
      ///
      /// Highlight the current user's row: if entry.username == me.username,
      /// wrap the ListTile in a ColoredBox with a light-green background color,
      /// e.g. Colors.green[50].
      body: const Center(child: Text('TODO 5.3 — implement the leaderboard')),
    );
  }
}
