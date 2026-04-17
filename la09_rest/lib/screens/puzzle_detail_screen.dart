// ignore_for_file: use_build_context_synchronously, unused_element, prefer_final_fields
import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';
import '../widgets/clue_tile.dart';

/// Shows the full guess history for one puzzle and lets the user submit a guess.
class PuzzleDetailScreen extends StatefulWidget {
  final ApiService api;
  final int puzzleId;

  const PuzzleDetailScreen({
    super.key,
    required this.api,
    required this.puzzleId,
  });

  @override
  State<PuzzleDetailScreen> createState() => _PuzzleDetailScreenState();
}

class _PuzzleDetailScreenState extends State<PuzzleDetailScreen> {
  final _guessController = TextEditingController();

  /// TODO 3.1a: Declare a nullable `Future<Puzzle>` field named futurePuzzle.
  // TODO 3.1a

  bool _submitting = false;
  String? _guessError;

  @override
  void initState() {
    super.initState();
    /// TODO 3.1b: Assign futurePuzzle = _loadPuzzle() here.
    // TODO 3.1b
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  /// TODO 3.1c: Implement _loadPuzzle().
  ///
  /// Call widget.api.getPuzzle(widget.puzzleId) and return the result.
  Future<Puzzle> _loadPuzzle() async {
    // TODO 3.1c
    throw UnimplementedError();
  }

  void _refresh() {
    /// TODO 3.1d: Reassign futurePuzzle inside setState (same pattern as _refresh
    /// in the list screen).
    // TODO 3.1d
  }

  /// TODO 3.2: Implement _submitGuess(Puzzle puzzle).
  ///
  /// Steps:
  ///   1. Read the guess from _guessController and trim/lowercase it.
  ///   2. Set _submitting = true, clear _guessError.
  ///   3. Call widget.api.submitGuess(puzzle.id, guess) in a try/catch.
  ///   4. On success:
  ///        - Clear the text field.
  ///        - If result['solved'] == true, show a SnackBar:
  ///            "You solved it! +${result['points_earned']} points"
  ///        - Call _refresh() to reload the puzzle.
  ///   5. On ApiException: set _guessError = e.message.
  ///   6. Always check mounted; always reset _submitting = false in setState.
  Future<void> _submitGuess(Puzzle puzzle) async {
    // TODO 3.2
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle')),
      body: FutureBuilder<Puzzle>(
        /// TODO 3.3: Replace the null below with futurePuzzle.
        future: null, // TODO 3.3
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final puzzle = snapshot.data!;
          final canGuess = puzzle.isActive &&
              puzzle.creatorId != _creatorIdPlaceholder(puzzle);

          return Column(
            children: [
              _PuzzleHeader(puzzle: puzzle),
              const Divider(height: 1),
              Expanded(child: _GuessList(puzzle: puzzle)),
              if (puzzle.isActive) ...[
                const Divider(height: 1),
                _GuessInput(
                  controller: _guessController,
                  error: _guessError,
                  submitting: _submitting,
                  enabled: canGuess,
                  disabledReason: puzzle.creatorId ==
                          _creatorIdPlaceholder(puzzle)
                      ? 'You cannot guess your own puzzle'
                      : null,
                  onSubmit: () => _submitGuess(puzzle),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // Placeholder used above until TODO 3.2 fills in real logic.
  // Once _submitGuess reads creatorId from the puzzle correctly this will
  // be superseded — leave it as-is.
  int _creatorIdPlaceholder(Puzzle puzzle) => -1;
}

// ── Sub-widgets (provided) ──────────────────────────────────────────────────

class _PuzzleHeader extends StatelessWidget {
  final Puzzle puzzle;

  const _PuzzleHeader({required this.puzzle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By ${puzzle.creator}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${puzzle.guessCount} guess${puzzle.guessCount == 1 ? '' : 'es'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (puzzle.isSolved)
            Chip(
              label: Text(
                puzzle.word!.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.green[100],
              side: BorderSide(color: Colors.green[700]!),
            )
          else
            const Chip(label: Text('Active')),
        ],
      ),
    );
  }
}

class _GuessList extends StatelessWidget {
  final Puzzle puzzle;

  const _GuessList({required this.puzzle});

  @override
  Widget build(BuildContext context) {
    if (puzzle.guesses.isEmpty) {
      return const Center(child: Text('No guesses yet — be the first!'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: puzzle.guesses.length,
      itemBuilder: (context, i) {
        final guess = puzzle.guesses[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Row(
            children: [
              ClueRow(word: guess.word, clue: guess.clue),
              const SizedBox(width: 12),
              Text(
                guess.username,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GuessInput extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final bool submitting;
  final bool enabled;
  final String? disabledReason;
  final VoidCallback onSubmit;

  const _GuessInput({
    required this.controller,
    required this.error,
    required this.submitting,
    required this.enabled,
    required this.onSubmit,
    this.disabledReason,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (disabledReason != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                disabledReason!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Your 5-letter guess',
                    border: const OutlineInputBorder(),
                    errorText: error,
                  ),
                  maxLength: 5,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: enabled ? (_) => onSubmit() : null,
                  enabled: enabled && !submitting,
                ),
              ),
              const SizedBox(width: 12),
              if (submitting)
                const CircularProgressIndicator()
              else
                FilledButton(
                  onPressed: enabled ? onSubmit : null,
                  child: const Text('Guess'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
