// Tests for Exercise 2.1 & 2.2 — DeckStore (File I/O: YAML → JSON)
//
// Run with:  flutter test test/ex02_test.dart
//
// Strategy
// --------
// path_provider's getApplicationDocumentsDirectory() is not available in the
// test environment, so DeckStore is tested via a thin subclass that overrides
// the documents directory with a real temp directory created by the test
// harness.  This means the actual file-read and file-write code runs against a
// real filesystem — no mocks needed.
//
// The YAML asset (assets/decks.yaml) is not available via rootBundle in unit
// tests.  The helper [_TestDeckStore] overrides _loadFromAsset() so that tests
// can inject raw YAML strings directly, isolating the YAML-parsing and
// fallback logic without requiring the Flutter asset pipeline.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:la08_persistence/deck_store.dart';
import 'package:la08_persistence/models.dart';

// ---------------------------------------------------------------------------
// Test helper — overrides I/O paths so tests stay in a temp directory
// ---------------------------------------------------------------------------

/// A [DeckStore] subclass used in tests.
///
/// - [directory] replaces `getApplicationDocumentsDirectory()`.
/// - [assetYaml] is returned instead of reading from rootBundle; pass `null`
///   to simulate a missing asset (should not happen in practice).
class _TestDeckStore extends DeckStore {
  _TestDeckStore({required this.directory, this.assetYaml});

  final Directory directory;
  final String? assetYaml;

  @override
  Future<Directory> getDocsDirectory() async => directory;

  @override
  Future<String> loadYamlAsset() async {
    if (assetYaml == null) throw Exception('No asset configured for test');
    return assetYaml!;
  }
}

// ---------------------------------------------------------------------------
// Sample YAML used in tests (mirrors the real assets/decks.yaml format)
// ---------------------------------------------------------------------------

const _sampleYaml = '''
- title: Sample Deck
  category: Testing
  cards:
    - front: What is 2 + 2?
      back: "4"
    - front: What colour is the sky?
      back: Blue
''';

const _sampleYaml2 = '''
- title: Deck Alpha
  category: Math
  cards:
    - front: "1 + 1"
      back: "2"
- title: Deck Beta
  category: Science
  cards:
    - front: H2O is the formula for what?
      back: Water
''';

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('cardify_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  // ---------------------------------------------------------------------------
  // loadTemplates — YAML fallback path
  // ---------------------------------------------------------------------------

  group('loadTemplates (YAML fallback)', () {
    test('returns templates from YAML when no JSON override exists', () async {
      final store =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      final templates = await store.loadTemplates();

      expect(templates, hasLength(1));
      expect(templates.first.title, 'Sample Deck');
      expect(templates.first.category, 'Testing');
      expect(templates.first.cards, hasLength(2));
    });

    test('first card front and back are parsed correctly', () async {
      final store =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      final templates = await store.loadTemplates();
      final card = templates.first.cards.first;

      expect(card.front, 'What is 2 + 2?');
      expect(card.back, '4');
    });

    test('parses multiple decks from YAML', () async {
      final store =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml2);
      final templates = await store.loadTemplates();

      expect(templates, hasLength(2));
      expect(templates.map((t) => t.title), containsAll(['Deck Alpha', 'Deck Beta']));
    });
  });

  // ---------------------------------------------------------------------------
  // saveTemplates + loadTemplates round-trip
  // ---------------------------------------------------------------------------

  group('saveTemplates + loadTemplates (JSON override)', () {
    test('saves templates and reads them back via JSON path', () async {
      final store =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);

      final original = await store.loadTemplates();
      await store.saveTemplates(original);

      // JSON file must now exist
      final jsonFile = File(p.join(tempDir.path, 'decks.json'));
      expect(await jsonFile.exists(), isTrue);

      // A fresh store (same directory) must prefer the JSON file
      final store2 =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      final reloaded = await store2.loadTemplates();

      expect(reloaded, hasLength(original.length));
      expect(reloaded.first.title, original.first.title);
    });

    test('JSON file contains valid JSON after save', () async {
      final store =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      await store.saveTemplates(await store.loadTemplates());

      final jsonFile = File(p.join(tempDir.path, 'decks.json'));
      final raw = await jsonFile.readAsString();
      // Must not throw
      final decoded = jsonDecode(raw);
      expect(decoded, isList);
    });

    test('modified templates survive a save/load round-trip', () async {
      const modified = DeckTemplate(
        title: 'My Custom Deck',
        category: 'Custom',
        cards: [CardTemplate(front: 'Q', back: 'A')],
      );

      final store =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      await store.saveTemplates([modified]);

      final store2 =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      final reloaded = await store2.loadTemplates();

      expect(reloaded.first.title, 'My Custom Deck');
      expect(reloaded.first.cards.first.front, 'Q');
      expect(reloaded.first.cards.first.back, 'A');
    });

    test('saving an empty list produces an empty list on reload', () async {
      final store =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      await store.saveTemplates([]);

      final store2 =
          _TestDeckStore(directory: tempDir, assetYaml: _sampleYaml);
      final reloaded = await store2.loadTemplates();
      expect(reloaded, isEmpty);
    });
  });
}
