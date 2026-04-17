import 'package:flutter/material.dart';
import '../models.dart';

/// A compact row of five colored dots summarizing a clue (no letters).
/// Used in the puzzle list to preview the most recent guess.
class CluePreview extends StatelessWidget {
  final List<ClueResult> clue;

  const CluePreview({super.key, required this.clue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: clue
          .map((r) => Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _clueColor(r),
                  shape: BoxShape.circle,
                ),
              ))
          .toList(),
    );
  }
}

/// A row of five colored letter tiles for one guess in the detail view.
class ClueRow extends StatelessWidget {
  final String word;
  final List<ClueResult> clue;

  const ClueRow({super.key, required this.word, required this.clue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => ClueTile(letter: word[i].toUpperCase(), result: clue[i]),
      ),
    );
  }
}

/// A single colored tile: one letter of a guess with its clue color.
///
/// - Green  (correct) : right letter, right position
/// - Amber  (present) : right letter, wrong position
/// - Grey   (absent)  : letter not in the word
class ClueTile extends StatelessWidget {
  final String letter;
  final ClueResult result;

  const ClueTile({super.key, required this.letter, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _clueColor(result),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

Color _clueColor(ClueResult r) => switch (r) {
      ClueResult.correct => Colors.green[700]!,
      ClueResult.present => Colors.amber[600]!,
      ClueResult.absent  => Colors.grey[600]!,
    };
