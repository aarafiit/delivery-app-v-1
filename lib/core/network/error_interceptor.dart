import 'package:dio/dio.dart';

import '../error/failure.dart';

/// Catches [DioException] and converts it into a typed [Failure],
/// then rejects the handler with a [DioException] whose [error] field
/// holds the mapped [Failure].
///
/// This ensures no raw exceptions bubble up past the network layer.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
        message: failure.message,
      ),
    );
  }

  Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final message = _extractMessage(err.response) ??
            'Server error ($statusCode).';
        return ServerFailure(message);

      case DioExceptionType.cancel:
        return const NetworkFailure('Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const NetworkFailure('SSL certificate error.');

      case DioExceptionType.unknown:
      default:
        return ServerFailure(err.message ?? 'An unexpected error occurred.');
    }
  }

  String? _extractMessage(Response? response) {
    if (response == null) return null;
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String?;
    }
    return null;
  }
}
