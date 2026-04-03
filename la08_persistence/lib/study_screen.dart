/// Fully provided — do not modify this file.
// ignore_for_file: unused_field
library;

import 'package:flutter/material.dart';

import 'models.dart';

/// A flip-card study session for a single [Deck].
///
/// Cards are presented one at a time. Tapping the card or the "Flip" button
/// reveals the answer. The user advances with "Got it" (correct) or
/// "Try again" (incorrect). A summary is shown when all cards have been seen.
class StudyScreen extends StatefulWidget {
  const StudyScreen({
    super.key,
    required this.deck,
    required this.cards,
  });

  final Deck deck;
  final List<Flashcard> cards;

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late final List<Flashcard> _queue;
  int _index = 0;
  bool _flipped = false;
  int _correct = 0;
  int _incorrect = 0;

  @override
  void initState() {
    super.initState();
    _queue = List.of(widget.cards)..shuffle();
  }

  bool get _done => _index >= _queue.length;

  void _flip() => setState(() => _flipped = !_flipped);

  void _answer(bool correct) {
    setState(() {
      if (correct) {
        _correct++;
      } else {
        _incorrect++;
      }
      _index++;
      _flipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Studying: ${widget.deck.title}'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: _done ? _buildSummary(context) : _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    final card = _queue[_index];
    final colorScheme = Theme.of(context).colorScheme;
    final total = _queue.length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(value: _index / total),
          const SizedBox(height: 8),
          Text(
            '${_index + 1} / $total',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // Card face
          Expanded(
            child: GestureDetector(
              onTap: _flip,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _flipped
                      ? colorScheme.secondaryContainer
                      : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _flipped ? 'Answer' : 'Question',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _flipped
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _flipped ? card.back : card.front,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _flipped
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onPrimaryContainer,
                          ),
                    ),
                    if (!_flipped) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Tap to flip',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withAlpha(150),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          if (!_flipped)
            FilledButton.icon(
              onPressed: _flip,
              icon: const Icon(Icons.flip),
              label: const Text('Flip'),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _answer(false),
                    icon: const Icon(Icons.replay, color: Colors.red),
                    label: const Text('Try again'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _answer(true),
                    icon: const Icon(Icons.check),
                    label: const Text('Got it'),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final total = _queue.length;
    final pct = total == 0 ? 0 : (_correct * 100 ~/ total);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Session complete!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('$_correct / $total correct ($pct%)'),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to deck'),
            ),
          ],
        ),
      ),
    );
  }
}
