// ignore_for_file: avoid_setters_without_getters
import 'package:shared_preferences/shared_preferences.dart';

/// A typed wrapper around [SharedPreferences] that centralises key constants
/// and provides named getters and setters for each persisted value.
///
/// ## Exercise 1.1
///
/// Implement this class following the pattern from the lecture slides:
///
/// 1. Declare `static const` string keys for each preference (see fields
///    below).
/// 2. Add a `final SharedPreferences _prefs` field and a private named
///    constructor `AppSettings._(this._prefs)`.
/// 3. Implement the `AppSettings.load()` async factory that obtains the
///    [SharedPreferences] singleton and returns an [AppSettings] instance.
/// 4. Implement typed getters and setters for [displayName] and [dailyGoal].
///
/// See the slide deck (§ SharedPreferences → "A Settings Wrapper") for the
/// full pattern.
class AppSettings {
  // ---- TODO 1.1a -----------------------------------------------------------
  // Add a `final SharedPreferences _prefs` field here.
  // Add a private named constructor:  AppSettings._(this._prefs);
  // -------------------------------------------------------------------------

  // ---- Key constants -------------------------------------------------------
  // TODO 1.1b: declare these as  static const String _keyXxx = 'xxx';
  //
  //   key for displayName  →  'displayName'
  //   key for dailyGoal    →  'dailyGoal'
  // -------------------------------------------------------------------------

  /// Default value returned when [dailyGoal] has never been written.
  static const int defaultDailyGoal = 10;

  // ---- Factory constructor -------------------------------------------------

  /// Loads the [SharedPreferences] singleton and returns a ready-to-use
  /// [AppSettings] instance.
  ///
  /// Call once at app startup (in [main]) and pass the result wherever
  /// settings are needed.
  ///
  /// TODO 1.1c: implement this method.
  static Future<AppSettings> load() async {
    throw UnimplementedError('AppSettings.load() is not yet implemented.');
  }

  // ---- Getters & setters ---------------------------------------------------

  /// The user's chosen display name. Returns an empty string if never set.
  ///
  /// TODO 1.1d: implement getter — return _prefs.getString(_keyDisplayName) ?? ''
  String get displayName =>
      throw UnimplementedError('displayName getter not implemented.');

  /// Persists [value] as the display name.
  ///
  /// TODO 1.1d: implement setter — call _prefs.setString(_keyDisplayName, value)
  set displayName(String value) =>
      throw UnimplementedError('displayName setter not implemented.');

  /// The user's daily study-card goal. Defaults to [defaultDailyGoal].
  ///
  /// TODO 1.1e: implement getter — return _prefs.getInt(_keyDailyGoal) ?? defaultDailyGoal
  int get dailyGoal =>
      throw UnimplementedError('dailyGoal getter not implemented.');

  /// Persists [value] as the daily goal.
  ///
  /// TODO 1.1e: implement setter — call _prefs.setInt(_keyDailyGoal, value)
  set dailyGoal(int value) =>
      throw UnimplementedError('dailyGoal setter not implemented.');
}
