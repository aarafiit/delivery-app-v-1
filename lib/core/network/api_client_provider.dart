import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/env/env_config.dart';
import '../../config/env/prod_config.dart';
import 'api_client.dart';

/// Provider for the active [EnvConfig].
///
/// Override this at the entry point (main_dev.dart, main_staging.dart)
/// to inject the correct environment configuration.
final envConfigProvider = Provider<EnvConfig>(
  (ref) => const ProdConfig(),
);

/// Provider for the [ApiClient].
///
/// Reads [envConfigProvider] for the base URL and uses a null token
/// provider by default (no auth token until the auth feature is wired).
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(envConfigProvider);
  return ApiClient(
    config: config,
    // Token provider will be replaced once the auth feature is implemented.
    tokenProvider: () => null,
  );
});
