import 'package:delivery_app/core/network/auth_interceptor.dart';
import 'package:delivery_app/core/storage/preferences_service.dart';
import 'package:delivery_app/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockPreferencesService extends Mock implements PreferencesService {}

class MockDio extends Mock implements Dio {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('AuthInterceptor', () {
    late MockSecureStorageService mockSecureStorage;
    late MockPreferencesService mockPreferences;
    late MockDio mockDio;
    late AuthInterceptor interceptor;

    setUp(() {
      mockSecureStorage = MockSecureStorageService();
      mockPreferences = MockPreferencesService();
      mockDio = MockDio();
      interceptor = AuthInterceptor(mockSecureStorage, mockPreferences, mockDio);
    });

    test('injects Authorization header when access token is present', () async {
      const String token = 'test-access-token-123';
      when(() => mockSecureStorage.getAccessToken())
          .thenAnswer((_) async => token);

      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test-access-token-123');
      verify(() => handler.next(options)).called(1);
    });

    test('does not inject Authorization header when token is null', () async {
      when(() => mockSecureStorage.getAccessToken())
          .thenAnswer((_) async => null);

      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });

    test('skips auth for public endpoints', () async {
      final options = RequestOptions(path: '/app/auth/phone/login');
      final handler = MockRequestInterceptorHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(options, handler);

      // Should not call getAccessToken for public endpoints
      verifyNever(() => mockSecureStorage.getAccessToken());
      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });
  });
}
