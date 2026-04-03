# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

### Set 1: SharedPreferences — User Settings

- [ ] **Exercise 1.1a:** `_prefs` field and private constructor
- [ ] **Exercise 1.1b:** `static const` key constants
- [ ] **Exercise 1.1c:** `AppSettings.load()` async factory
- [ ] **Exercise 1.1d:** `displayName` getter and setter
- [ ] **Exercise 1.1e:** `dailyGoal` getter and setter
- [ ] **Exercise 1.2a:** Pre-populate `SettingsScreen` fields from `widget.settings`
- [ ] **Exercise 1.2b:** Save updated values in `_save()`

### Set 2: File I/O — Starter Deck Library

- [ ] **Exercise 2.1:** `DeckStore.loadTemplates()` — JSON override path
- [ ] **Exercise 2.1:** `DeckStore.loadTemplates()` — YAML fallback path
- [ ] **Exercise 2.2:** `DeckStore.saveTemplates()` — write to `decks.json`

### Set 3: SQLite — Decks and Cards

- [ ] **Exercise 3.1:** `openAppDatabase()` — `PRAGMA foreign_keys = ON`
- [ ] **Exercise 3.1:** `openAppDatabase()` — `decks` table schema
- [ ] **Exercise 3.1:** `openAppDatabase()` — `flashcards` table schema with FK
- [ ] **Exercise 3.2a:** `DeckProvider.getAll()`
- [ ] **Exercise 3.2b:** `DeckProvider.insert()`
- [ ] **Exercise 3.2c:** `DeckProvider.delete()`
- [ ] **Exercise 3.2 (screen):** Wire up `home_screen.dart` TODOs 3.2a–3.2e
- [ ] **Exercise 3.3a:** `FlashcardProvider.getForDeck()`
- [ ] **Exercise 3.3b:** `FlashcardProvider.insert()`
- [ ] **Exercise 3.3c:** `FlashcardProvider.delete()`
- [ ] **Exercise 3.3 (screen):** Wire up `deck_screen.dart` TODOs 3.3b–3.3e

### Bonus

- [ ] **Bonus:** `DeckProvider.getAllWithCount()` with `LEFT JOIN` / `GROUP BY`

### Final checks

- [ ] All required tests pass: `flutter test test/ex01_test.dart test/ex02_test.dart test/ex03_test.dart`
- [ ] `flutter analyze` reports no errors

---

## Reflection Questions

1. **Exercise 1.1:** The `AppSettings.load()` factory is `async` even though
   reading values (`getString`, `getInt`) is synchronous. Why? What work does
   `SharedPreferences.getInstance()` perform on the very first call that
   requires it to be async, and why are subsequent reads synchronous?

2. **Exercise 2.1:** The YAML fallback and JSON override paths both call
   `DeckTemplate.fromMap()`.  What property of the YAML package's `YamlMap`
   makes it compatible with a factory that was written for JSON
   (`Map<String, dynamic>`)?  Why do you need to call
   `Map<String, dynamic>.from(e as YamlMap)` rather than passing the `YamlMap`
   directly?

3. **Exercise 2.1 vs 2.2:** `loadTemplates()` is `async` and `saveTemplates()`
   is also `async`.  In each case, what specific I/O operation makes the method
   async?  Could you make either of them synchronous without changing the
   underlying mechanism?  Why or why not?

4. **Exercise 3.1:** The schema declares
   `FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE`, yet SQLite
   does not enforce foreign keys by default.  What must you do to enable
   enforcement, and where in the `openDatabase` call does it go?  What would
   happen if you forgot this step and deleted a deck?

5. **Exercise 3.2 / 3.3:** Both providers use `?` placeholders in `where`
   clauses (`where: 'id = ?', whereArgs: [id]`) rather than string
   interpolation (`where: 'id = $id'`).  Why is this important?  Give an
   example of what could go wrong with string interpolation if the value came
   from user input.

6. **Set 1 vs Set 3:** Both `AppSettings` (SharedPreferences) and
   `DeckProvider`/`FlashcardProvider` (SQLite) persist data, but they are
   structured very differently.  What specifically about the deck and card data
   makes SQLite a better fit than SharedPreferences?  What specifically about
   the settings data makes SharedPreferences a better fit than SQLite?

---

## AI Tool Usage Disclosure

For each set, indicate whether AI tools were used and describe how:

**Set 1 (SharedPreferences):**

**Set 2 (File I/O):**

**Set 3 (SQLite):**
