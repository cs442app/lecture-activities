// Tests for Exercises 3.1, 3.2, 3.3 — SQLite (openAppDatabase, DeckProvider,
// FlashcardProvider)
//
// Run with:  flutter test test/ex03_test.dart
//
// Strategy
// --------
// sqflite_common_ffi opens an in-memory SQLite database inside the test
// process — no device or simulator required.  openAppDatabase() is not
// called directly; instead each test group opens a fresh in-memory DB and
// passes it to the provider under test.  This keeps tests fast and isolated.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:la08_persistence/database.dart';
import 'package:la08_persistence/models.dart';

// ---------------------------------------------------------------------------
// Helper — open a fresh in-memory database with the production schema
// ---------------------------------------------------------------------------

Future<dynamic> _openMemoryDb() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // openAppDatabase() resolves a path via getDatabasesPath(); for tests we
  // open inMemoryDatabasePath directly using the same schema callback.
  return openDatabase(
    inMemoryDatabasePath,
    version: 1,
    onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE decks (
          id       INTEGER PRIMARY KEY AUTOINCREMENT,
          title    TEXT    NOT NULL,
          category TEXT    NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE flashcards (
          id      INTEGER PRIMARY KEY AUTOINCREMENT,
          deck_id INTEGER NOT NULL,
          front   TEXT    NOT NULL,
          back    TEXT    NOT NULL,
          FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE
        )
      ''');
    },
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ---------------------------------------------------------------------------
  // Exercise 3.1 — openAppDatabase schema
  // ---------------------------------------------------------------------------

  group('openAppDatabase schema', () {
    late dynamic db;

    setUp(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      db = await openAppDatabase();
    });

    tearDown(() async => await db.close());

    test('decks table exists', () async {
      final rows = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='decks'");
      expect(rows, hasLength(1));
    });

    test('flashcards table exists', () async {
      final rows = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='flashcards'");
      expect(rows, hasLength(1));
    });

    test('decks table has expected columns', () async {
      final rows = await db.rawQuery('PRAGMA table_info(decks)');
      final cols = rows.map((r) => r['name'] as String).toSet();
      expect(cols, containsAll({'id', 'title', 'category'}));
    });

    test('flashcards table has expected columns', () async {
      final rows = await db.rawQuery('PRAGMA table_info(flashcards)');
      final cols = rows.map((r) => r['name'] as String).toSet();
      expect(cols, containsAll({'id', 'deck_id', 'front', 'back'}));
    });
  });

  // ---------------------------------------------------------------------------
  // Exercise 3.2 — DeckProvider
  // ---------------------------------------------------------------------------

  group('DeckProvider', () {
    late dynamic db;
    late DeckProvider provider;

    setUp(() async {
      db = await _openMemoryDb();
      provider = DeckProvider(db);
    });

    tearDown(() async => await db.close());

    test('getAll returns empty list when table is empty', () async {
      expect(await provider.getAll(), isEmpty);
    });

    test('insert returns deck with assigned id', () async {
      const deck = Deck(title: 'Dart', category: 'Programming');
      final saved = await provider.insert(deck);
      expect(saved.id, isNotNull);
      expect(saved.id, greaterThan(0));
      expect(saved.title, 'Dart');
    });

    test('getAll returns inserted deck', () async {
      await provider.insert(const Deck(title: 'Flutter', category: 'Programming'));
      final decks = await provider.getAll();
      expect(decks, hasLength(1));
      expect(decks.first.title, 'Flutter');
    });

    test('getAll returns multiple decks ordered by title', () async {
      await provider.insert(const Deck(title: 'Zebra', category: 'X'));
      await provider.insert(const Deck(title: 'Apple', category: 'X'));
      final decks = await provider.getAll();
      expect(decks.map((d) => d.title).toList(), ['Apple', 'Zebra']);
    });

    test('delete removes the deck', () async {
      final saved =
          await provider.insert(const Deck(title: 'ToDelete', category: 'X'));
      await provider.delete(saved.id!);
      expect(await provider.getAll(), isEmpty);
    });

    test('delete does not affect other decks', () async {
      final a = await provider.insert(const Deck(title: 'A', category: 'X'));
      await provider.insert(const Deck(title: 'B', category: 'X'));
      await provider.delete(a.id!);
      final remaining = await provider.getAll();
      expect(remaining, hasLength(1));
      expect(remaining.first.title, 'B');
    });
  });

  // ---------------------------------------------------------------------------
  // Exercise 3.3 — FlashcardProvider
  // ---------------------------------------------------------------------------

  group('FlashcardProvider', () {
    late dynamic db;
    late DeckProvider deckProvider;
    late FlashcardProvider cardProvider;
    late Deck deck;

    setUp(() async {
      db = await _openMemoryDb();
      deckProvider = DeckProvider(db);
      cardProvider = FlashcardProvider(db);
      deck = await deckProvider.insert(
          const Deck(title: 'Test Deck', category: 'Test'));
    });

    tearDown(() async => await db.close());

    test('getForDeck returns empty list when deck has no cards', () async {
      expect(await cardProvider.getForDeck(deck.id!), isEmpty);
    });

    test('insert returns flashcard with assigned id', () async {
      final card = Flashcard(deckId: deck.id!, front: 'Q', back: 'A');
      final saved = await cardProvider.insert(card);
      expect(saved.id, isNotNull);
      expect(saved.id, greaterThan(0));
      expect(saved.front, 'Q');
      expect(saved.back, 'A');
    });

    test('getForDeck returns inserted cards', () async {
      await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q1', back: 'A1'));
      await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q2', back: 'A2'));
      final cards = await cardProvider.getForDeck(deck.id!);
      expect(cards, hasLength(2));
    });

    test('getForDeck only returns cards for the requested deck', () async {
      final other = await deckProvider.insert(
          const Deck(title: 'Other', category: 'Test'));
      await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q', back: 'A'));
      await cardProvider.insert(
          Flashcard(deckId: other.id!, front: 'X', back: 'Y'));

      final cards = await cardProvider.getForDeck(deck.id!);
      expect(cards, hasLength(1));
      expect(cards.first.front, 'Q');
    });

    test('delete removes the card', () async {
      final saved =
          await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q', back: 'A'));
      await cardProvider.delete(saved.id!);
      expect(await cardProvider.getForDeck(deck.id!), isEmpty);
    });

    test('deleting a deck cascades to its cards', () async {
      await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q', back: 'A'));
      await deckProvider.delete(deck.id!);

      // Cards must be gone even though we deleted via the deck table.
      final cards = await cardProvider.getForDeck(deck.id!);
      expect(cards, isEmpty);
    });
  });
}
