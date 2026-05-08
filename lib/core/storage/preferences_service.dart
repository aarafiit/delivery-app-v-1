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

  /// Store an integer value
  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  /// Retrieve an integer value
  /// Returns null if the key doesn't exist
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Remove a specific key
  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  /// Clear all stored preferences
  Future<bool> clear() {
    return _prefs.clear();
  }

  // ---------------------------------------------------------------------------
  // JWT Token Expiry Methods
  // ---------------------------------------------------------------------------

  /// Save token expiry timestamp
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await setInt('token_expiry', expiry.millisecondsSinceEpoch);
  }

  /// Get token expiry timestamp
  /// Returns null if not set
  DateTime? getTokenExpiry() {
    final timestamp = getInt('token_expiry');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Delete token expiry timestamp
  Future<void> deleteTokenExpiry() async {
    await remove('token_expiry');
  }

  /// Check if access token is expired
  bool isAccessTokenExpired() {
    final expiry = getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }
}
