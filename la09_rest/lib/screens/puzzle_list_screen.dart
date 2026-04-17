// ignore_for_file: use_build_context_synchronously, unused_import, unused_element
import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';
import '../widgets/clue_tile.dart';
import 'auth_screen.dart';
import 'leaderboard_screen.dart';
import 'puzzle_detail_screen.dart';
import 'submit_word_screen.dart';

/// Home screen: the list of all active and solved puzzles.
class PuzzleListScreen extends StatefulWidget {
  final ApiService api;

  const PuzzleListScreen({super.key, required this.api});

  @override
  State<PuzzleListScreen> createState() => _PuzzleListScreenState();
}

class _PuzzleListScreenState extends State<PuzzleListScreen> {
  /// TODO 2.1: Declare a nullable `Future<List<Puzzle>>` field named futurePuzzles.
  // TODO 2.1

  @override
  void initState() {
    super.initState();
    /// TODO 2.2: Assign futurePuzzles = _loadPuzzles() here.
    // TODO 2.2
  }

  /// TODO 2.3: Implement _loadPuzzles() — return widget.api.getPuzzles().
  Future<List<Puzzle>> _loadPuzzles() async {
    // TODO 2.3
    throw UnimplementedError();
  }

  /// TODO 2.4: Implement _refresh() — reassign futurePuzzles inside setState.
  void _refresh() {
    // TODO 2.4
  }

  Future<void> _logout() async {
    await widget.api.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => AuthScreen(api: widget.api)),
    );
  }

  Future<void> _navigateToPuzzle(Puzzle puzzle) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PuzzleDetailScreen(api: widget.api, puzzleId: puzzle.id),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crowdle'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LeaderboardScreen(api: widget.api),
              ),
            ),
            tooltip: 'Leaderboard',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Log out',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubmitWordScreen(api: widget.api),
            ),
          );
          _refresh();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Puzzle'),
      ),
      /// TODO 2.5: Replace the placeholder below with a FutureBuilder.
      ///
      /// - Use futurePuzzles as the future and List<Puzzle> as the type.
      /// - While loading: show a centered CircularProgressIndicator.
      /// - On error: show a centered Text with snapshot.error.
      /// - When data arrives: build a ListView.builder over snapshot.data!.
      ///
      /// Each list item should be a ListTile showing:
      ///   title:    Row with the creator's username and (if solved) a green
      ///             "SOLVED" Chip.
      ///   subtitle: "$guessCount guess${guessCount == 1 ? '' : 'es'}"
      ///   trailing: CluePreview(clue: puzzle.lastClue!) if lastClue != null.
      ///   onTap:    call _navigateToPuzzle(puzzle).
      body: const Center(child: Text('TODO 2.5 — implement the puzzle list')),
    );
  }
}
