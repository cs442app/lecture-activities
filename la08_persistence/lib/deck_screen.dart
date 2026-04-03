/// Provided shell — implement the TODOs marked with [Set 3] in this file.
// ignore_for_file: unused_field, unused_element, unused_import
library;

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'models.dart';
import 'study_screen.dart';

/// Displays the cards in a single [Deck] and allows adding/deleting cards.
class DeckScreen extends StatefulWidget {
  const DeckScreen({super.key, required this.db, required this.deck});

  final Database db;
  final Deck deck;

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  // ---- TODO 3.3b -----------------------------------------------------------
  // Declare a FlashcardProvider field named `_provider` and initialise it in
  // initState using widget.db.
  // --------------------------------------------------------------------------

  List<Flashcard> _cards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // TODO 3.3b: initialise _provider here.
    _loadCards();
  }

  Future<void> _loadCards() async {
    // ---- TODO 3.3c ---------------------------------------------------------
    // Replace the line below with a call to
    //   _provider.getForDeck(widget.deck.id!)
    // and store the result in _cards.
    // ------------------------------------------------------------------------
    final cards = <Flashcard>[];   // TODO 3.3c: replace with provider call
    if (mounted) setState(() { _cards = cards; _loading = false; });
  }

  Future<void> _addCard() async {
    final result = await showDialog<({String front, String back})>(
      context: context,
      builder: (_) => const _AddCardDialog(),
    );
    if (result == null) return;

    // ---- TODO 3.3d ---------------------------------------------------------
    // Insert the new card via _provider.insert() and reload.
    // Skeleton: create a Flashcard with no id, widget.deck.id!, result.front,
    // result.back then call _provider.insert(card) followed by _loadCards().
    // ------------------------------------------------------------------------
    // TODO 3.3d: insert the card and reload.
    debugPrint(result.toString()); // remove this line once you implement the TODO
  }

  Future<void> _deleteCard(Flashcard card) async {
    // ---- TODO 3.3e ---------------------------------------------------------
    // Delete the card via _provider.delete(card.id!) and reload.
    // ------------------------------------------------------------------------
    // TODO 3.3e: delete the card and reload.
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.title),
        backgroundColor: colorScheme.primaryContainer,
        actions: [
          if (_cards.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_arrow_outlined),
              tooltip: 'Study',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudyScreen(
                      deck: widget.deck,
                      cards: _cards,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCard,
        icon: const Icon(Icons.add),
        label: const Text('Add card'),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_cards.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.credit_card_outlined, size: 72, color: Colors.grey),
              SizedBox(height: 16),
              Text('No cards yet. Tap "Add card" to create one.'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card = _cards[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(card.front),
            subtitle: Text(
              card.back,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              tooltip: 'Delete card',
              onPressed: () => _deleteCard(card),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Internal dialog
// ---------------------------------------------------------------------------

class _AddCardDialog extends StatefulWidget {
  const _AddCardDialog();

  @override
  State<_AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<_AddCardDialog> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New card'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _frontController,
              decoration: const InputDecoration(labelText: 'Front (question)'),
              maxLines: 3,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _backController,
              decoration: const InputDecoration(labelText: 'Back (answer)'),
              maxLines: 3,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, (
                front: _frontController.text.trim(),
                back: _backController.text.trim(),
              ));
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
