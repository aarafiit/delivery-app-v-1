import 'package:dio/dio.dart';

import '../storage/preferences_service.dart';
import '../storage/secure_storage_service.dart';

/// Dio interceptor that handles JWT authentication.
/// 
/// Responsibilities:
/// - Adds Authorization header with access token to requests
/// - Handles 401 Unauthorized errors by refreshing the token
/// - Retries failed requests with new token
/// - Forces logout if token refresh fails
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final PreferencesService _preferences;
  final Dio _dio;

  AuthInterceptor(
    this._secureStorage,
    this._preferences,
    this._dio,
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Add access token to Authorization header
    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401 && !_isPublicEndpoint(err.requestOptions.path)) {
      // Try to refresh token
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry original request with new token
        final options = err.requestOptions;
        final accessToken = await _secureStorage.getAccessToken();
        options.headers['Authorization'] = 'Bearer $accessToken';

        try {
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          // Retry failed, pass original error
          return handler.next(err);
        }
      } else {
        // Refresh failed - force logout
        await _forceLogout();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Attempts to refresh the access token using the stored refresh token.
  /// 
  /// Returns true if refresh was successful, false otherwise.
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/app/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'] as String;
      final expiresIn = response.data['expiresIn'] as int;
      final expiry = DateTime.now().add(Duration(seconds: expiresIn));

      await _secureStorage.saveAccessToken(newAccessToken);
      await _preferences.saveTokenExpiry(expiry);

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Forces logout by clearing all authentication data.
  /// 
  /// Called when token refresh fails.
  Future<void> _forceLogout() async {
    try {
      await _secureStorage.deleteAccessToken();
      await _secureStorage.deleteRefreshToken();
      await _preferences.deleteTokenExpiry();
      await _preferences.remove('user_id');
      await _preferences.remove('phone_number');
      await _preferences.setBool('is_logged_in', false);
    } catch (_) {
      // Ignore cleanup errors
    }
  }

  /// Checks if the given path is a public endpoint that doesn't require auth.
  bool _isPublicEndpoint(String path) {
    return path.contains('/auth/phone/login') ||
        path.contains('/auth/otp/verify') ||
        path.contains('/auth/refresh-token');
  }
}
