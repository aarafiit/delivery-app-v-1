import 'package:delivery_app/config/env/dev_config.dart';
import 'package:delivery_app/config/env/prod_config.dart';
import 'package:delivery_app/config/env/staging_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvConfig implementations', () {
    test('DevConfig has non-empty baseUrl and envName', () {
      const config = DevConfig();
      expect(config.baseUrl, isNotEmpty);
      expect(config.envName, 'dev');
    });

    test('StagingConfig has non-empty baseUrl and envName', () {
      const config = StagingConfig();
      expect(config.baseUrl, isNotEmpty);
      expect(config.envName, 'staging');
    });

    test('ProdConfig has non-empty baseUrl and envName', () {
      const config = ProdConfig();
      expect(config.baseUrl, isNotEmpty);
      expect(config.envName, 'prod');
    });

    test('each environment has a distinct baseUrl', () {
      const dev = DevConfig();
      const staging = StagingConfig();
      const prod = ProdConfig();

      expect(dev.baseUrl, isNot(staging.baseUrl));
      expect(staging.baseUrl, isNot(prod.baseUrl));
      expect(dev.baseUrl, isNot(prod.baseUrl));
    });
  });
}
