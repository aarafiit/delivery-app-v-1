import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service wrapper for FlutterSecureStorage
/// Provides secure storage for sensitive data like authentication tokens
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  /// Write a key-value pair to secure storage
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a value from secure storage by key
  /// Returns null if the key doesn't exist
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  /// Delete a specific key from secure storage
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Delete all data from secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // ---------------------------------------------------------------------------
  // JWT Token Methods
  // ---------------------------------------------------------------------------

  /// Save access token to secure storage
  Future<void> saveAccessToken(String token) async {
    await write(key: 'access_token', value: token);
  }

  /// Get access token from secure storage
  Future<String?> getAccessToken() async {
    return await read(key: 'access_token');
  }

  /// Delete access token from secure storage
  Future<void> deleteAccessToken() async {
    await delete(key: 'access_token');
  }

  /// Save refresh token to secure storage
  Future<void> saveRefreshToken(String token) async {
    await write(key: 'refresh_token', value: token);
  }

  /// Get refresh token from secure storage
  Future<String?> getRefreshToken() async {
    return await read(key: 'refresh_token');
  }

  /// Delete refresh token from secure storage
  Future<void> deleteRefreshToken() async {
    await delete(key: 'refresh_token');
  }
}
