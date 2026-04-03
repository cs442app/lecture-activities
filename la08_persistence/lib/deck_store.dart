// ignore_for_file: unused_import, unused_field
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:yaml/yaml.dart';

import 'models.dart';

/// Manages the file-based starter deck library.
///
/// The library lives in one of two places, checked in this order:
///
/// 1. `<documents>/decks.json` — a user-customised copy saved by
///    [saveTemplates].
/// 2. `assets/decks.yaml` — the read-only defaults bundled with the app.
///
/// Call [loadTemplates] to get the current list of [DeckTemplate]s and
/// [saveTemplates] to persist a modified list.
///
/// ## Exercise 2.1 — [loadTemplates]
///
/// Implement [loadTemplates] so that it:
///
/// 1. Obtains the documents directory via [getDocsDirectory] (which calls
///    [getApplicationDocumentsDirectory] in production).
/// 2. Constructs a [File] for `decks.json` inside that directory using
///    [p.join].
/// 3. If the file **exists**, reads it with [File.readAsString], decodes the
///    JSON with [jsonDecode], casts to `List`, and maps each entry to a
///    [DeckTemplate] via [DeckTemplate.fromMap].
/// 4. If the file does **not** exist, falls back to the bundled asset by
///    calling [loadYamlAsset], parsing the result with [loadYaml], and
///    converting each `YamlMap` entry to a [DeckTemplate] via
///    [DeckTemplate.fromMap] (the YAML and JSON keys are identical, so
///    [fromMap] works for both formats).
///
/// ## Exercise 2.2 — [saveTemplates]
///
/// Implement [saveTemplates] so that it:
///
/// 1. Obtains the documents directory via [getDocsDirectory].
/// 2. Constructs the same `decks.json` [File].
/// 3. Serialises the list to JSON:
///    `jsonEncode(templates.map((t) => t.toMap()).toList())`
/// 4. Writes the JSON string to the file with [File.writeAsString].
///
/// After [saveTemplates] completes, a subsequent call to [loadTemplates] must
/// return the newly saved templates (the JSON override path is now present).
class DeckStore {
  /// The file name used for the user-customised library override.
  static const _fileName = 'decks.json';

  /// The asset path for the read-only default library.
  static const _assetPath = 'assets/decks.yaml';

  // ---- Overridable I/O helpers (overridden in tests) -----------------------

  /// Returns the directory in which [_fileName] is read and written.
  ///
  /// Production code uses [getApplicationDocumentsDirectory]; tests override
  /// this to return a temporary directory so no real app sandbox is needed.
  Future<Directory> getDocsDirectory() => getApplicationDocumentsDirectory();

  /// Loads the raw YAML string from the bundled asset.
  ///
  /// Production code calls `rootBundle.loadString(_assetPath)`; tests
  /// override this to inject a YAML string directly.
  Future<String> loadYamlAsset() => rootBundle.loadString(_assetPath);

  // ---- TODO 2.1 ------------------------------------------------------------
  // Implement this method following the steps in the doc comment above.
  // Use getDocsDirectory() instead of getApplicationDocumentsDirectory() and
  // loadYamlAsset() instead of rootBundle.loadString() directly.
  // -------------------------------------------------------------------------
  Future<List<DeckTemplate>> loadTemplates() async {
    throw UnimplementedError('DeckStore.loadTemplates() is not yet implemented.');
  }

  // ---- TODO 2.2 ------------------------------------------------------------
  // Implement this method following the steps in the doc comment above.
  // Use getDocsDirectory() instead of getApplicationDocumentsDirectory().
  // -------------------------------------------------------------------------
  Future<void> saveTemplates(List<DeckTemplate> templates) async {
    throw UnimplementedError('DeckStore.saveTemplates() is not yet implemented.');
  }
}
