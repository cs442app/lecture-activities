// Tests for the Bonus exercise — DeckProvider.getAllWithCount()
//
// Run with:  flutter test test/bonus_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:la08_persistence/database.dart';
import 'package:la08_persistence/models.dart';

Future<dynamic> _openMemoryDb() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
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

void main() {
  late dynamic db;
  late DeckProvider deckProvider;
  late FlashcardProvider cardProvider;

  setUp(() async {
    db = await _openMemoryDb();
    deckProvider = DeckProvider(db);
    cardProvider = FlashcardProvider(db);
  });

  tearDown(() async => await db.close());

  test('getAllWithCount returns zero for a deck with no cards', () async {
    await deckProvider.insert(const Deck(title: 'Empty', category: 'X'));
    final results = await deckProvider.getAllWithCount();
    expect(results, hasLength(1));
    expect(results.first.cardCount, 0);
    expect(results.first.deck.title, 'Empty');
  });

  test('getAllWithCount reflects the correct card count', () async {
    final deck =
        await deckProvider.insert(const Deck(title: 'Full', category: 'X'));
    await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q1', back: 'A1'));
    await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q2', back: 'A2'));
    await cardProvider.insert(Flashcard(deckId: deck.id!, front: 'Q3', back: 'A3'));

    final results = await deckProvider.getAllWithCount();
    expect(results.first.cardCount, 3);
  });

  test('getAllWithCount returns counts for multiple decks', () async {
    final a =
        await deckProvider.insert(const Deck(title: 'Alchemy', category: 'X'));
    final b =
        await deckProvider.insert(const Deck(title: 'Biology', category: 'X'));

    await cardProvider.insert(Flashcard(deckId: a.id!, front: 'Q', back: 'A'));
    await cardProvider.insert(Flashcard(deckId: b.id!, front: 'Q', back: 'A'));
    await cardProvider.insert(Flashcard(deckId: b.id!, front: 'Q2', back: 'A2'));

    final results = await deckProvider.getAllWithCount();
    // Results are ordered by title ASC
    expect(results[0].deck.title, 'Alchemy');
    expect(results[0].cardCount, 1);
    expect(results[1].deck.title, 'Biology');
    expect(results[1].cardCount, 2);
  });

  test('getAllWithCount count drops to zero after all cards are deleted',
      () async {
    final deck =
        await deckProvider.insert(const Deck(title: 'Shrinking', category: 'X'));
    final card = await cardProvider
        .insert(Flashcard(deckId: deck.id!, front: 'Q', back: 'A'));
    await cardProvider.delete(card.id!);

    final results = await deckProvider.getAllWithCount();
    expect(results.first.cardCount, 0);
  });
}
