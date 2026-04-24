/// Sealed class representing typed domain and API errors.
/// All failures carry a human-readable [message].
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// Failure caused by a network connectivity issue (no internet, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Failure returned by the server (4xx / 5xx HTTP responses).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure caused by invalid input or business-rule violations.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
