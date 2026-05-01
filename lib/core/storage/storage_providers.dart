import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_service.dart';
import 'secure_storage_service.dart';

/// Provider for FlutterSecureStorage instance
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Provider for SecureStorageService
///
/// Wraps FlutterSecureStorage for secure storage of sensitive data
/// like authentication tokens.
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(storage);
});

/// Provider for SharedPreferences instance
///
/// This is an async provider since SharedPreferences.getInstance() is async.
/// Override this provider in tests with a mock instance.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// Provider for PreferencesService
///
/// Wraps SharedPreferences for storage of non-sensitive user preferences
/// and data like user_id, phone_number, and flags.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  // Watch the async SharedPreferences provider
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  
  // Return a PreferencesService when SharedPreferences is ready
  return prefsAsync.when(
    data: (prefs) => PreferencesService(prefs),
    loading: () => throw Exception('SharedPreferences not yet initialized'),
    error: (error, stack) => throw Exception('Failed to initialize SharedPreferences: $error'),
  );
});
