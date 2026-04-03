// Tests for Exercise 1.1 & 1.2 — AppSettings (SharedPreferences)
//
// Run with:  flutter test test/ex01_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:la08_persistence/app_settings.dart';

void main() {
  // Reset SharedPreferences to a clean slate before every test so that tests
  // are fully isolated from each other.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ---------------------------------------------------------------------------
  // displayName
  // ---------------------------------------------------------------------------

  group('displayName', () {
    test('returns empty string when nothing has been written', () async {
      final settings = await AppSettings.load();
      expect(settings.displayName, '');
    });

    test('persists a non-empty name', () async {
      final settings = await AppSettings.load();
      settings.displayName = 'Alice';

      // Re-load to prove the value came from SharedPreferences, not memory.
      final settings2 = await AppSettings.load();
      expect(settings2.displayName, 'Alice');
    });

    test('persists an empty string', () async {
      final settings = await AppSettings.load();
      settings.displayName = 'Bob';
      settings.displayName = '';

      final settings2 = await AppSettings.load();
      expect(settings2.displayName, '');
    });

    test('two AppSettings instances share the same backing store', () async {
      final a = await AppSettings.load();
      final b = await AppSettings.load();
      a.displayName = 'Carol';
      expect(b.displayName, 'Carol');
    });
  });

  // ---------------------------------------------------------------------------
  // dailyGoal
  // ---------------------------------------------------------------------------

  group('dailyGoal', () {
    test('returns defaultDailyGoal when nothing has been written', () async {
      final settings = await AppSettings.load();
      expect(settings.dailyGoal, AppSettings.defaultDailyGoal);
    });

    test('persists a custom goal', () async {
      final settings = await AppSettings.load();
      settings.dailyGoal = 25;

      final settings2 = await AppSettings.load();
      expect(settings2.dailyGoal, 25);
    });

    test('persisting dailyGoal does not affect displayName', () async {
      final settings = await AppSettings.load();
      settings.displayName = 'Dan';
      settings.dailyGoal = 15;

      final settings2 = await AppSettings.load();
      expect(settings2.displayName, 'Dan');
      expect(settings2.dailyGoal, 15);
    });
  });

  // ---------------------------------------------------------------------------
  // load() factory
  // ---------------------------------------------------------------------------

  group('load()', () {
    test('returns an AppSettings without throwing', () async {
      expect(() => AppSettings.load(), returnsNormally);
    });

    test('successive calls return equivalent instances', () async {
      final a = await AppSettings.load();
      a.displayName = 'Eve';
      final b = await AppSettings.load();
      expect(b.displayName, 'Eve');
    });
  });
}
