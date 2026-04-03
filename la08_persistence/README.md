# Activity 8: Persistence — Cardify

## Learning Objectives

By the end of this activity you will be able to:

- Store and retrieve simple typed values across app launches using
  `SharedPreferences`, following the settings-wrapper pattern.
- Read a read-only configuration file bundled as an app asset (YAML), detect
  whether a user-modified copy exists in the documents directory (JSON), and
  write changes back to that writable location.
- Open a SQLite database using `sqflite`, define a relational schema with a
  foreign-key relationship in an `onCreate` callback, and implement typed
  data-access objects (Providers) for CRUD operations.
- Explain when to reach for each persistence mechanism and why.

---

## Background

### Why Persistence Matters

All in-memory state — `setState` variables, provider values, list contents —
is lost the moment an app is killed or the device is restarted.  Mobile
operating systems routinely terminate background apps to reclaim memory.
Persistence is the mechanism by which an app survives those events and picks up
where it left off.

Flutter offers several local persistence options.  This activity covers three:

| Mechanism | Best for |
|-----------|----------|
| `SharedPreferences` | Small numbers of typed primitive values (settings, flags) |
| File I/O (`dart:io` + `path_provider`) | Structured text or binary files — config, documents, exported data |
| SQLite (`sqflite`) | Relational data with queries, filters, and relationships |

### SharedPreferences

`SharedPreferences` wraps the native key/value store on each platform
(`NSUserDefaults` on iOS, `SharedPreferences` on Android).  The instance is
obtained once via an async `getInstance()` call; after that, reads are
synchronous and writes are async.

The recommended pattern is a **settings wrapper** class: a single class that
owns the `SharedPreferences` instance, declares all key constants as `static
const` strings, and exposes named typed getters and setters.  This prevents
key-string typos and keeps persistence details out of widget code.

```dart
class AppSettings {
  static const _keyName = 'displayName';
  final SharedPreferences _prefs;
  AppSettings._(this._prefs);

  static Future<AppSettings> load() async =>
      AppSettings._(await SharedPreferences.getInstance());

  String get displayName => _prefs.getString(_keyName) ?? '';
  set displayName(String v) => _prefs.setString(_keyName, v);
}
```

### File I/O and the YAML → JSON Pattern

Flutter apps are sandboxed — they can only read and write within
OS-assigned directories.  The `path_provider` package exposes the correct
paths on every platform.

Assets bundled in `assets/` are read-only; they travel with the app binary.
A common pattern for default configuration is:

1. Ship defaults as a human-readable YAML asset (easy for developers to edit).
2. On first load, check whether a user-modified JSON file already exists in
   the documents directory.
3. If it does, read from JSON; otherwise fall back to the bundled YAML.
4. When the user saves changes, write to the JSON file.

```
assets/decks.yaml     ← read-only defaults (YAML, developer-editable)
documents/decks.json  ← user overrides (JSON, written at runtime)
```

The `yaml` package parses YAML into `YamlMap` / `YamlList` objects.  Because
`DeckTemplate.fromMap()` accepts a plain `Map<String, dynamic>`, and YAML maps
expose the same key/value interface, the same factory works for both formats.

### SQLite and the Provider Pattern

SQLite is a self-contained, serverless database engine.  The `sqflite` package
exposes it through a clean async Dart API.

- **`openDatabase`** opens or creates the `.db` file.  Pass an `onCreate`
  callback for `CREATE TABLE` statements and an `onConfigure` callback to
  enable foreign-key enforcement (`PRAGMA foreign_keys = ON`).
- **Provider classes** encapsulate all SQL for one table.  Widget code calls
  methods like `getAll()`, `insert()`, and `delete()` — raw SQL stays inside
  the provider.  Use `?` placeholders for all dynamic values to prevent SQL
  injection.
- **ORM helpers** (`toMap` / `fromMap` / `copyWith`) convert between Dart
  objects and the `Map<String, dynamic>` rows that `sqflite` works with.

```dart
class DeckProvider {
  final Database db;
  DeckProvider(this.db);

  Future<List<Deck>> getAll() async {
    final rows = await db.query('decks', orderBy: 'title ASC');
    return rows.map(Deck.fromMap).toList();
  }
}
```

---

## The App

**Cardify** is a flashcard study app.  Users manage named decks of question/
answer cards, import starter decks from a bundled library, and study their
cards one at a time with a flip-card interface.

The three persistence mechanisms serve distinct roles:

- **SharedPreferences** stores the user's display name and daily study goal.
- **File I/O** manages a library of starter deck templates (YAML defaults,
  JSON overrides).
- **SQLite** stores the decks and cards the user actively studies.

The exercises build on each other: the settings screen (Set 1) is the first
thing students see; the starter-deck import flow (Set 3, Ex 3.2e) calls the
File I/O layer (Set 2) to seed the database.

---

## File Structure

```
lib/
├── main.dart               # Entry point — provided, do not modify
├── models.dart             # Provided — Deck, Flashcard, DeckTemplate, DeckWithCount
├── study_screen.dart       # Provided — flip-card study UI, do not modify
├── home_screen.dart        # Provided shell — Set 3 TODOs (deck list/add/delete)
├── deck_screen.dart        # Provided shell — Set 3 TODOs (card list/add/delete)
├── settings_screen.dart    # Provided shell — Set 1 TODOs (load & save settings)
├── app_settings.dart       # SKELETON ← Set 1: SharedPreferences wrapper
├── deck_store.dart         # SKELETON ← Set 2: File I/O (YAML/JSON library)
└── database.dart           # SKELETON ← Set 3: SQLite schema + Providers
assets/
└── decks.yaml              # Bundled starter deck data — provided, do not modify
test/
├── ex01_test.dart          # Set 1 tests (6 tests)
├── ex02_test.dart          # Set 2 tests (8 tests)
├── ex03_test.dart          # Set 3 tests (12 tests)
└── bonus_test.dart         # Bonus tests (4 tests)
```

---

## Set 1: SharedPreferences — User Settings

`SharedPreferences` is the right tool for the small number of primitive values
that constitute a user's profile.  In this set you will build an `AppSettings`
wrapper and wire it up to the settings screen.

### Exercise 1.1: The `AppSettings` Wrapper (`lib/app_settings.dart`)

**Goal:** Implement the settings wrapper class that encapsulates all
`SharedPreferences` access behind a typed, key-safe interface.

#### What to implement

**TODO 1.1a** — Add a private field and constructor:

```dart
final SharedPreferences _prefs;
AppSettings._(this._prefs);
```

**TODO 1.1b** — Declare key constants:

```dart
static const String _keyDisplayName = 'displayName';
static const String _keyDailyGoal   = 'dailyGoal';
```

**TODO 1.1c** — Implement the async factory:

```dart
static Future<AppSettings> load() async =>
    AppSettings._(await SharedPreferences.getInstance());
```

**TODO 1.1d** — Implement the `displayName` getter and setter:

```dart
String get displayName => _prefs.getString(_keyDisplayName) ?? '';
set displayName(String value) => _prefs.setString(_keyDisplayName, value);
```

**TODO 1.1e** — Implement the `dailyGoal` getter and setter:

```dart
int get dailyGoal => _prefs.getInt(_keyDailyGoal) ?? defaultDailyGoal;
set dailyGoal(int value) => _prefs.setInt(_keyDailyGoal, value);
```

#### Run and verify

Run the app.  The settings screen (tap the gear icon) should display default
values (`''` name, `10` goal).  Change them, save, and kill/relaunch the app —
the values should be restored.

#### Tests

```bash
flutter test test/ex01_test.dart
```

---

### Exercise 1.2: Wiring Up `SettingsScreen` (`lib/settings_screen.dart`)

**Goal:** Pre-populate the settings form with the current persisted values and
save any changes when the user taps "Save".

#### What to implement

**TODO 1.2a** — In `initState`, read from `widget.settings`:

```dart
_nameController.text = widget.settings.displayName;
_dailyGoal = widget.settings.dailyGoal;
```

**TODO 1.2b** — In `_save()`, write back and show confirmation:

```dart
widget.settings.displayName = _nameController.text.trim();
widget.settings.dailyGoal   = _dailyGoal;
setState(() => _saved = true);
```

#### Run and verify

Open the settings screen.  If you completed Exercise 1.1, the fields should
show whatever values were last saved.  Change the name, save, and navigate
back — the home screen greeting updates immediately.

*Note: Exercise 1.2 has no automated tests — the interaction is verified
manually.*

---

## Set 2: File I/O — Starter Deck Library

The app ships with a bundled YAML file (`assets/decks.yaml`) containing three
starter deck templates.  In this set you will implement `DeckStore`, the
service that loads templates from YAML (or a JSON override if one exists) and
saves user modifications to JSON.

### Background: YAML vs. JSON in this app

| | `assets/decks.yaml` | `documents/decks.json` |
|---|---|---|
| Who writes it? | Developer (at build time) | The app (at runtime) |
| Can the app modify it? | No — bundled assets are read-only | Yes |
| When is it used? | First launch (no JSON yet) | Any launch after the user has saved changes |

`DeckTemplate.fromMap()` accepts a plain `Map<String, dynamic>` and works for
both formats because the YAML and JSON key names are identical.

### Exercise 2.1: Loading Templates (`lib/deck_store.dart`)

**Goal:** Implement `DeckStore.loadTemplates()` so that it prefers the JSON
override when present and falls back to the bundled YAML otherwise.

#### What to implement

Replace `throw UnimplementedError(...)` in `loadTemplates()` with:

```dart
Future<List<DeckTemplate>> loadTemplates() async {
  final dir  = await getDocsDirectory();
  final file = File(p.join(dir.path, _fileName));

  if (await file.exists()) {
    // JSON override path
    final raw = await file.readAsString();
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => DeckTemplate.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // YAML fallback path
  final raw  = await loadYamlAsset();
  final yaml = loadYaml(raw) as YamlList;
  return yaml
      .map((e) => DeckTemplate.fromMap(
            Map<String, dynamic>.from(e as YamlMap)))
      .toList();
}
```

Use `getDocsDirectory()` and `loadYamlAsset()` (not the underlying APIs
directly) so the test subclass can inject test doubles.

`Map<String, dynamic>.from(e as YamlMap)` is required because `YamlMap` is an
immutable read-only type — it cannot be directly cast to `Map<String, dynamic>`
even though it implements `Map`.  `Map.from` creates a plain mutable copy.
`DeckTemplate.fromMap` handles the same conversion for the nested card entries.

#### Run and verify

After completing Set 3, tap "Import starter decks" on the home screen.  The
three decks from `assets/decks.yaml` should be inserted into the database and
appear in the list.

#### Tests

```bash
flutter test test/ex02_test.dart
```

---

### Exercise 2.2: Saving Templates (`lib/deck_store.dart`)

**Goal:** Implement `DeckStore.saveTemplates()` so that the JSON override is
written to the documents directory.

#### What to implement

Replace `throw UnimplementedError(...)` in `saveTemplates()` with:

```dart
Future<void> saveTemplates(List<DeckTemplate> templates) async {
  final dir  = await getDocsDirectory();
  final file = File(p.join(dir.path, _fileName));
  await file.writeAsString(
    jsonEncode(templates.map((t) => t.toMap()).toList()),
  );
}
```

#### Run and verify

After importing starter decks once, a `decks.json` file is written to the
documents directory.  Kill and relaunch the app — `loadTemplates()` now reads
from JSON instead of YAML.  The deck list should be identical.

#### Tests

Covered by `flutter test test/ex02_test.dart` (the round-trip tests verify
that `saveTemplates` writes a file that `loadTemplates` reads back correctly).

---

## Set 3: SQLite — Decks and Cards

SQLite is the right choice for the decks and cards: they are structured,
relational (a deck has many cards), and need to support queries and CRUD
operations.

### Exercise 3.1: Opening the Database (`lib/database.dart`)

**Goal:** Implement `openAppDatabase()` — the function that creates the SQLite
database file, defines the two-table schema, and enables foreign-key
enforcement.

#### What to implement

Replace `throw UnimplementedError(...)` in `openAppDatabase()` with:

```dart
Future<Database> openAppDatabase() async {
  final dir = await getDatabasesPath();
  return openDatabase(
    p.join(dir, 'cardify.db'),
    version: 1,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
    onCreate: (db, version) async {
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
```

`ON DELETE CASCADE` means that when a deck is deleted, all its flashcards are
removed automatically — `DeckProvider.delete()` needs no extra cleanup step.

#### Run and verify

The app should launch without errors.  The home screen shows an empty state
(the providers return empty lists until Exercises 3.2 and 3.3 are complete).

#### Tests

```bash
flutter test test/ex03_test.dart
```

---

### Exercise 3.2: `DeckProvider` (`lib/database.dart`)

**Goal:** Implement the three CRUD methods on `DeckProvider` so the home screen
can list, add, and delete decks.

#### What to implement

**TODO 3.2a** — `getAll()`:

```dart
Future<List<Deck>> getAll() async {
  final rows = await db.query('decks', orderBy: 'title ASC');
  return rows.map(Deck.fromMap).toList();
}
```

**TODO 3.2b** — `insert(Deck deck)`:

```dart
Future<Deck> insert(Deck deck) async {
  final id = await db.insert(
    'decks',
    deck.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return deck.copyWith(id: id);
}
```

**TODO 3.2c** — `delete(int id)`:

```dart
Future<void> delete(int id) async {
  await db.delete('decks', where: 'id = ?', whereArgs: [id]);
}
```

Then wire up `home_screen.dart` by following the five TODO comments (`3.2a`–
`3.2e`).  The most important is **TODO 3.2e** — the "Import starter decks"
flow that ties Set 2 and Set 3 together:

```dart
for (final t in templates) {
  final deck = await _deckProvider.insert(
    Deck(title: t.title, category: t.category),
  );
  for (final c in t.cards) {
    await _flashcardProvider.insert(
      Flashcard(deckId: deck.id!, front: c.front, back: c.back),
    );
  }
}
await _loadDecks();
```

#### Run and verify

Tap "Import starter decks".  The three starter decks should appear.  Tap the
delete icon on any deck — it disappears.  Tap "New deck" and create one — it
appears in alphabetical order.

#### Tests

```bash
flutter test test/ex03_test.dart
```

---

### Exercise 3.3: `FlashcardProvider` (`lib/database.dart`)

**Goal:** Implement the three CRUD methods on `FlashcardProvider` so the deck
detail screen can list, add, and delete cards.

#### What to implement

**TODO 3.3a** — `getForDeck(int deckId)`:

```dart
Future<List<Flashcard>> getForDeck(int deckId) async {
  final rows = await db.query(
    'flashcards',
    where: 'deck_id = ?',
    whereArgs: [deckId],
  );
  return rows.map(Flashcard.fromMap).toList();
}
```

**TODO 3.3b** — `insert(Flashcard card)`:

```dart
Future<Flashcard> insert(Flashcard card) async {
  final id = await db.insert(
    'flashcards',
    card.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return card.copyWith(id: id);
}
```

**TODO 3.3c** — `delete(int id)`:

```dart
Future<void> delete(int id) async {
  await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
}
```

Then wire up `deck_screen.dart` by following the five TODO comments
(`3.3b`–`3.3e`).

#### Run and verify

Tap a deck.  Cards from the import appear in the list.  Add a card with
"Add card" — it appears.  Tap the play button — the flip-card study session
launches.  Delete a card — it disappears.  Delete a deck from the home screen
and verify its cards are gone when you check via a new import.

#### Tests

```bash
flutter test test/ex03_test.dart
```

---

## Bonus: Cross-Table Query (`lib/database.dart`)

**Goal:** Implement `DeckProvider.getAllWithCount()`, which returns every deck
annotated with the number of cards it contains using a single SQL `LEFT JOIN`.

### Background: `LEFT JOIN` vs `JOIN`

A regular `JOIN` (inner join) only returns rows where a match exists in **both**
tables.  A deck with zero cards has no matching `flashcards` row, so an inner
join would silently omit it.  A `LEFT JOIN` keeps every row from the left table
and fills the right side with `NULL` when no match exists.  `COUNT(flashcards.id)`
returns `0` for those nulls — exactly the right result for an empty deck.

### What to implement

Replace `throw UnimplementedError(...)` in `getAllWithCount()` with:

```dart
Future<List<DeckWithCount>> getAllWithCount() async {
  final rows = await db.rawQuery('''
    SELECT decks.id, decks.title, decks.category,
           COUNT(flashcards.id) AS card_count
    FROM decks
    LEFT JOIN flashcards ON flashcards.deck_id = decks.id
    GROUP BY decks.id
    ORDER BY decks.title ASC
  ''');
  return rows
      .map((r) => DeckWithCount(
            deck: Deck.fromMap(r),
            cardCount: r['card_count'] as int,
          ))
      .toList();
}
```

### Tests

```bash
flutter test test/bonus_test.dart
```

---

## Verification

Run all tests:

```bash
flutter test
```

Run tests for a single set:

```bash
flutter test test/ex01_test.dart
flutter test test/ex02_test.dart
flutter test test/ex03_test.dart
flutter test test/bonus_test.dart   # optional
```

Run the analyzer:

```bash
flutter analyze
```

Fix any issues before submitting.

---

## Submission

1. Complete all exercises in Sets 1, 2, and 3 (and optionally the Bonus).
2. Ensure all required tests pass:
   ```bash
   flutter test test/ex01_test.dart test/ex02_test.dart test/ex03_test.dart
   ```
3. Ensure no analyzer issues: `flutter analyze`
4. Complete the `REPORT.md` self-evaluation.
5. Commit and push your changes.
