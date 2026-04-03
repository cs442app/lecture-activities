// ignore_for_file: unused_import
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'models.dart';

// ---------------------------------------------------------------------------
// Exercise 3.1 — openAppDatabase
// ---------------------------------------------------------------------------

/// Opens (or creates) the SQLite database used by Cardify.
///
/// The database file is stored at `<getDatabasesPath()>/cardify.db`.
///
/// **Schema** (create in the [onCreate] callback):
///
/// ```sql
/// CREATE TABLE decks (
///   id       INTEGER PRIMARY KEY AUTOINCREMENT,
///   title    TEXT    NOT NULL,
///   category TEXT    NOT NULL
/// );
///
/// CREATE TABLE flashcards (
///   id      INTEGER PRIMARY KEY AUTOINCREMENT,
///   deck_id INTEGER NOT NULL,
///   front   TEXT    NOT NULL,
///   back    TEXT    NOT NULL,
///   FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE
/// );
/// ```
///
/// Enable foreign-key enforcement by executing
/// `PRAGMA foreign_keys = ON` inside an [onConfigure] callback:
///
/// ```dart
/// onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
/// ```
///
/// TODO 3.1: implement this function.
Future<Database> openAppDatabase() async {
  throw UnimplementedError('openAppDatabase() is not yet implemented.');
}

// ---------------------------------------------------------------------------
// Exercise 3.2 — DeckProvider
// ---------------------------------------------------------------------------

/// Data-access object for the `decks` table.
///
/// Follow the Provider pattern from the lecture slides: keep all SQL inside
/// this class; never let raw queries leak into widget code.
class DeckProvider {
  DeckProvider(this.db);

  final Database db;

  // ---- TODO 3.2a -----------------------------------------------------------
  /// Returns all decks ordered by title.
  ///
  /// Use `db.query('decks', orderBy: 'title ASC')` and map each row to a
  /// [Deck] via [Deck.fromMap].
  Future<List<Deck>> getAll() async {
    throw UnimplementedError('DeckProvider.getAll() is not yet implemented.');
  }

  // ---- TODO 3.2b -----------------------------------------------------------
  /// Inserts [deck] and returns a copy with the database-assigned [Deck.id].
  ///
  /// Use `db.insert('decks', deck.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)`.
  /// Return `deck.copyWith(id: insertedId)`.
  Future<Deck> insert(Deck deck) async {
    throw UnimplementedError('DeckProvider.insert() is not yet implemented.');
  }

  // ---- TODO 3.2c -----------------------------------------------------------
  /// Deletes the deck with the given [id].
  ///
  /// Because the schema declares `ON DELETE CASCADE`, all flashcards that
  /// belong to this deck are removed automatically.
  ///
  /// Use `db.delete('decks', where: 'id = ?', whereArgs: [id])`.
  Future<void> delete(int id) async {
    throw UnimplementedError('DeckProvider.delete() is not yet implemented.');
  }

  // ---- Bonus ---------------------------------------------------------------
  /// Returns every deck annotated with its card count, ordered by title.
  ///
  /// Use a raw query with a LEFT JOIN and GROUP BY:
  ///
  /// ```sql
  /// SELECT decks.id, decks.title, decks.category,
  ///        COUNT(flashcards.id) AS card_count
  /// FROM decks
  /// LEFT JOIN flashcards ON flashcards.deck_id = decks.id
  /// GROUP BY decks.id
  /// ORDER BY decks.title ASC
  /// ```
  ///
  /// Map each result row to a [DeckWithCount]:
  /// ```dart
  /// DeckWithCount(
  ///   deck: Deck.fromMap(row),
  ///   cardCount: row['card_count'] as int,
  /// )
  /// ```
  ///
  /// TODO Bonus: implement this method.
  Future<List<DeckWithCount>> getAllWithCount() async {
    throw UnimplementedError(
        'DeckProvider.getAllWithCount() is not yet implemented.');
  }
}

// ---------------------------------------------------------------------------
// Exercise 3.3 — FlashcardProvider
// ---------------------------------------------------------------------------

/// Data-access object for the `flashcards` table.
class FlashcardProvider {
  FlashcardProvider(this.db);

  final Database db;

  // ---- TODO 3.3a -----------------------------------------------------------
  /// Returns all flashcards that belong to [deckId], ordered by rowid
  /// (insertion order).
  ///
  /// Use `db.query('flashcards', where: 'deck_id = ?', whereArgs: [deckId])`.
  Future<List<Flashcard>> getForDeck(int deckId) async {
    throw UnimplementedError(
        'FlashcardProvider.getForDeck() is not yet implemented.');
  }

  // ---- TODO 3.3b -----------------------------------------------------------
  /// Inserts [card] and returns a copy with the database-assigned
  /// [Flashcard.id].
  ///
  /// Use `db.insert('flashcards', card.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)`.
  Future<Flashcard> insert(Flashcard card) async {
    throw UnimplementedError(
        'FlashcardProvider.insert() is not yet implemented.');
  }

  // ---- TODO 3.3c -----------------------------------------------------------
  /// Deletes the flashcard with the given [id].
  ///
  /// Use `db.delete('flashcards', where: 'id = ?', whereArgs: [id])`.
  Future<void> delete(int id) async {
    throw UnimplementedError(
        'FlashcardProvider.delete() is not yet implemented.');
  }
}
