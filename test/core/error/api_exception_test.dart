import 'package:delivery_app/core/error/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiException', () {
    test('stores statusCode and message', () {
      const e = ApiException(statusCode: 404, message: 'Not found');
      expect(e.statusCode, 404);
      expect(e.message, 'Not found');
    });

    test('toString includes statusCode and message', () {
      const e = ApiException(statusCode: 500, message: 'Server error');
      expect(e.toString(), contains('500'));
      expect(e.toString(), contains('Server error'));
    });
  });
}
