/// Abstract environment configuration.
/// Each environment (dev, staging, prod) provides its own implementation.
abstract class EnvConfig {
  /// Base URL for all API requests.
  String get baseUrl;

  /// Human-readable environment name (e.g. "dev", "staging", "prod").
  String get envName;

  /// Base URL for media/storage assets (MinIO, S3, etc.).
  /// Used to rewrite localhost URLs returned by the API when running on a device.
  String get mediaBaseUrl;
}
