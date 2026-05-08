import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_user_profile_use_case.dart';
import '../../domain/usecases/update_user_profile_use_case.dart';

// ---------------------------------------------------------------------------
// Data-layer providers
// ---------------------------------------------------------------------------

/// Provides the [ProfileRemoteDataSource] backed by the shared [ApiClient].
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteDataSourceImpl(apiClient);
});

/// Provides the [ProfileRepository] implementation.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
});

// ---------------------------------------------------------------------------
// Domain-layer providers
// ---------------------------------------------------------------------------

/// Provides the [GetUserProfileUseCase].
final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetUserProfileUseCase(repository);
});

/// Provides the [UpdateUserProfileUseCase].
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
});
