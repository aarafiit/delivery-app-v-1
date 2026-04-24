/// Abstract environment configuration.
/// Each environment (dev, staging, prod) provides its own implementation.
abstract class EnvConfig {
  /// Base URL for all API requests.
  String get baseUrl;

  /// Human-readable environment name (e.g. "dev", "staging", "prod").
  String get envName;
}
