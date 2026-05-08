import 'package:dio/dio.dart';

import '../../config/env/env_config.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

/// Dio-based HTTP client configured with logging and error interceptors.
///
/// The [baseUrl] is read exclusively from the active [EnvConfig].
/// Auth interceptor is added separately via the provider to access storage services.
class ApiClient {
  final Dio dio;

  ApiClient({
    required EnvConfig config,
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
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }
}
