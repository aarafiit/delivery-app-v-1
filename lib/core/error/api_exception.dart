/// Exception thrown when the API returns an error response.
/// Carries the HTTP [statusCode] and a descriptive [message].
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
