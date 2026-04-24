import 'package:dio/dio.dart';

/// Injects an [Authorization] header into every outgoing request
/// when an auth token is available.
///
/// The token is supplied via [tokenProvider], making this interceptor
/// testable without depending on secure storage directly.
class AuthInterceptor extends Interceptor {
  /// Returns the current auth token, or null if the user is not authenticated.
  final String? Function() tokenProvider;

  const AuthInterceptor({required this.tokenProvider});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
