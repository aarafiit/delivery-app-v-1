import 'env_config.dart';

/// Development environment configuration.
class DevConfig implements EnvConfig {
  const DevConfig();

  @override
  // Physical device: use the host machine's LAN IP so the phone can reach it over WiFi.
  // Emulator: swap back to http://10.0.2.2:8080
  // Home IP : 192.168.0.102
  // Mobile Net IP :  172.19.59.194
  String get baseUrl => 'http://192.168.0.103:8080';

  @override
  String get mediaBaseUrl => 'http://192.168.0.103:9000';

  @override
  String get envName => 'dev';
}
