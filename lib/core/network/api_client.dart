import 'package:dio/dio.dart';

import '../../config/env/env_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

/// Dio-based HTTP client configured with auth, logging, and error interceptors.
///
/// The [baseUrl] is read exclusively from the active [EnvConfig].
/// The [tokenProvider] callback supplies the current auth token (or null).
class ApiClient {
  final Dio dio;

  ApiClient({
    required EnvConfig config,
    required String? Function() tokenProvider,
    Dio? dioOverride,
  }) : dio = dioOverride ??
            Dio(
              BaseOptions(
                baseUrl: config.baseUrl,
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                headers: {'Content-Type': 'application/json'},
              ),
            ) {
    dio.interceptors.addAll([
      AuthInterceptor(tokenProvider: tokenProvider),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }
}
