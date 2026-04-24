import '../error/failure.dart';

/// Maps [Failure] subtypes to user-facing display strings.
/// Always returns a non-empty, non-null string.
class ErrorHandler {
  const ErrorHandler._();

  static String toUserMessage(Failure failure) => switch (failure) {
        NetworkFailure() => 'No internet connection. Please check your network.',
        ServerFailure(message: final m) =>
          m.isNotEmpty ? m : 'An unexpected server error occurred.',
        ValidationFailure(message: final m) =>
          m.isNotEmpty ? m : 'Invalid input. Please check your details.',
      };
}
