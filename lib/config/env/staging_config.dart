import 'env_config.dart';

/// Staging environment configuration.
class StagingConfig implements EnvConfig {
  const StagingConfig();

  @override
  String get baseUrl => 'https://staging-api.deliveryapp.com';

  @override
  String get envName => 'staging';
}
