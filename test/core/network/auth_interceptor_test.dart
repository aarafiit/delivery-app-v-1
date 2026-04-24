import 'package:delivery_app/core/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthInterceptor', () {
    test('injects Authorization header when token is present', () {
      const String token = 'test-token-123';
      final interceptor = AuthInterceptor(tokenProvider: () => token);

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Authorization'], 'Bearer test-token-123');
    });

    test('does not inject Authorization header when token is null', () {
      final interceptor = AuthInterceptor(tokenProvider: () => null);

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test('does not inject Authorization header when token is empty', () {
      final interceptor = AuthInterceptor(tokenProvider: () => '');

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers.containsKey('Authorization'), isFalse);
    });
  });
}
