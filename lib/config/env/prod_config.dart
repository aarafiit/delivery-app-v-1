import 'env_config.dart';

/// Production environment configuration.
class ProdConfig implements EnvConfig {
  const ProdConfig();

  @override
  String get baseUrl => 'https://api.deliveryapp.com';

  @override
  String get envName => 'prod';
}
