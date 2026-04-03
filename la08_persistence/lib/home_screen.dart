/// Provided shell — implement the TODOs marked with [Set 3] in this file.
// ignore_for_file: unused_field, unused_element, unused_import
library;

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'app_settings.dart';
import 'database.dart';
import 'deck_screen.dart';
import 'deck_store.dart';
import 'models.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.db, required this.settings});

  final Database db;
  final AppSettings settings;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ---- TODO 3.2a -----------------------------------------------------------
  // Declare a DeckProvider field named `_deckProvider` and initialise it in
  // initState using widget.db.
  // --------------------------------------------------------------------------

  List<Deck> _decks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // TODO 3.2a: initialise _deckProvider here.
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    // ---- TODO 3.2b ---------------------------------------------------------
    // Replace the line below with a call to _deckProvider.getAll() and store
    // the result in _decks.
    // ------------------------------------------------------------------------
    final decks = <Deck>[];   // TODO 3.2b: replace with _deckProvider.getAll()
    if (mounted) setState(() { _decks = decks; _loading = false; });
  }

  Future<void> _addDeck() async {
    final result = await showDialog<({String title, String category})>(
      context: context,
      builder: (_) => const _AddDeckDialog(),
    );
    if (result == null) return;

    // ---- TODO 3.2c ---------------------------------------------------------
    // Insert the new deck via _deckProvider.insert() and reload the list.
    // Skeleton: create a Deck with no id, result.title, result.category then
    // call _deckProvider.insert(deck) followed by _loadDecks().
    // ------------------------------------------------------------------------
    // TODO 3.2c: insert the deck and reload.
    debugPrint(result.toString()); // remove this line once you implement the TODO
  }

  Future<void> _deleteDeck(Deck deck) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete deck?'),
        content: Text(
            'Delete "${deck.title}" and all its cards? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;

    // ---- TODO 3.2d ---------------------------------------------------------
    // Delete the deck via _deckProvider.delete(deck.id!) and reload the list.
    // ------------------------------------------------------------------------
    // TODO 3.2d: delete the deck and reload.
  }

  Future<void> _importStarters() async {
    // Load templates from the file-based library (Set 2) and insert each
    // one into SQLite (Set 3). This method ties the two persistence layers
    // together — you must complete Set 2 before this flow works end-to-end.
    final store = DeckStore();
    final templates = await store.loadTemplates();

    // ---- TODO 3.2e ---------------------------------------------------------
    // For each DeckTemplate in templates:
    //   1. Call _deckProvider.insert(Deck(...)) to create the deck and capture
    //      the returned deck (which now has an id).
    //   2. For each CardTemplate in template.cards, call
    //      _flashcardProvider.insert(Flashcard(...)) to persist the card.
    // Then call _loadDecks() to refresh the UI.
    //
    // Note: _flashcardProvider is declared for you below — initialise it in
    // initState the same way you initialised _deckProvider.
    // ------------------------------------------------------------------------
    // TODO 3.2e: import templates into SQLite.
    debugPrint('${templates.length} templates loaded — implement TODO 3.2e'); // remove this line

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Imported ${templates.length} starter deck(s).'),
        ),
      );
    }
  }

  // ---- TODO 3.3a -----------------------------------------------------------
  // Declare a FlashcardProvider field named `_flashcardProvider` and initialise
  // it in initState using widget.db.
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final name = widget.settings.displayName;
    final greeting = name.isNotEmpty ? 'Hi, $name!' : 'Welcome to Cardify';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardify'),
        backgroundColor: colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SettingsScreen(settings: widget.settings),
                ),
              );
              // Refresh so the greeting updates if the name changed.
              setState(() {});
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context, greeting),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDeck,
        icon: const Icon(Icons.add),
        label: const Text('New deck'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String greeting) {
    if (_decks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.style_outlined, size: 72, color: Colors.grey),
              const SizedBox(height: 16),
              Text(greeting,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'No decks yet. Create one with the button below,\n'
                'or import the starter library.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _importStarters,
                icon: const Icon(Icons.download_outlined),
                label: const Text('Import starter decks'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: _decks.length,
      itemBuilder: (context, index) {
        final deck = _decks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.style_outlined),
            ),
            title: Text(deck.title,
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(deck.category),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              tooltip: 'Delete deck',
              onPressed: () => _deleteDeck(deck),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeckScreen(db: widget.db, deck: deck),
                ),
              ).then((_) => _loadDecks());
            },
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Internal dialog widget
// ---------------------------------------------------------------------------

class _AddDeckDialog extends StatefulWidget {
  const _AddDeckDialog();

  @override
  State<_AddDeckDialog> createState() => _AddDeckDialogState();
}

class _AddDeckDialogState extends State<_AddDeckDialog> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New deck'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
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
                title: _titleController.text.trim(),
                category: _categoryController.text.trim(),
              ));
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
