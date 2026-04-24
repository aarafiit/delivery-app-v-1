import 'env_config.dart';

/// Development environment configuration.
class DevConfig implements EnvConfig {
  const DevConfig();

  @override
  String get baseUrl => 'http://localhost:8080';

  @override
  String get envName => 'dev';
}
