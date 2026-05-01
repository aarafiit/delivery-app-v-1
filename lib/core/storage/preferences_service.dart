import 'package:shared_preferences/shared_preferences.dart';

/// Service wrapper for SharedPreferences
/// Provides storage for non-sensitive user preferences and data
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Store a string value
  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  /// Retrieve a string value
  /// Returns null if the key doesn't exist
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Store a boolean value
  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  /// Retrieve a boolean value
  /// Returns null if the key doesn't exist
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Remove a specific key
  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  /// Clear all stored preferences
  Future<bool> clear() {
    return _prefs.clear();
  }
}
