import 'package:delivery_app/core/error/failure.dart';
import 'package:delivery_app/core/utils/error_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure subtypes', () {
    test('NetworkFailure has default message', () {
      const f = NetworkFailure();
      expect(f.message, 'No internet connection.');
    });

    test('NetworkFailure accepts custom message', () {
      const f = NetworkFailure('Request was cancelled.');
      expect(f.message, 'Request was cancelled.');
    });

    test('ServerFailure stores message', () {
      const f = ServerFailure('Internal server error.');
      expect(f.message, 'Internal server error.');
    });

    test('ValidationFailure stores message', () {
      const f = ValidationFailure('Email is invalid.');
      expect(f.message, 'Email is invalid.');
    });
  });

  group('ErrorHandler.toUserMessage', () {
    test('returns non-empty string for NetworkFailure', () {
      final msg = ErrorHandler.toUserMessage(const NetworkFailure());
      expect(msg, isNotEmpty);
    });

    test('returns non-empty string for ServerFailure with message', () {
      final msg = ErrorHandler.toUserMessage(const ServerFailure('Oops'));
      expect(msg, 'Oops');
    });

    test('returns fallback for ServerFailure with empty message', () {
      final msg = ErrorHandler.toUserMessage(const ServerFailure(''));
      expect(msg, isNotEmpty);
    });

    test('returns non-empty string for ValidationFailure with message', () {
      final msg = ErrorHandler.toUserMessage(const ValidationFailure('Bad input'));
      expect(msg, 'Bad input');
    });

    test('returns fallback for ValidationFailure with empty message', () {
      final msg = ErrorHandler.toUserMessage(const ValidationFailure(''));
      expect(msg, isNotEmpty);
    });
  });
}
