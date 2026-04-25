import 'env_config.dart';

/// Development environment configuration.
class DevConfig implements EnvConfig {
  const DevConfig();

  @override
  // Physical device: use the host machine's LAN IP so the phone can reach it over WiFi.
  // Emulator: swap back to http://10.0.2.2:8080
  String get baseUrl => 'http://172.19.59.194:8080';

  @override
  String get mediaBaseUrl => 'http://172.19.59.194:9000';

  @override
  String get envName => 'dev';
}
