import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/env/env_config.dart';
import '../../config/env/prod_config.dart';
import '../storage/storage_providers.dart';
import 'api_client.dart';
import 'auth_interceptor.dart';

/// Provider for the active [EnvConfig].
///
/// Override this at the entry point (main_dev.dart, main_staging.dart)
/// to inject the correct environment configuration.
final envConfigProvider = Provider<EnvConfig>(
  (ref) => const ProdConfig(),
);

/// Provider for the [ApiClient].
///
/// Reads [envConfigProvider] for the base URL and adds auth interceptor
/// with storage dependencies for JWT token management.
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(envConfigProvider);
  final apiClient = ApiClient(config: config);

  // Add auth interceptor with storage dependencies
  final secureStorage = ref.watch(secureStorageServiceProvider);
  final preferences = ref.watch(preferencesServiceProvider);
  
  apiClient.dio.interceptors.insert(
    0, // Insert at the beginning to run before other interceptors
    AuthInterceptor(secureStorage, preferences, apiClient.dio),
  );

  return apiClient;
});
