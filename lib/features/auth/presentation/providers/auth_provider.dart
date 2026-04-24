import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';

// ---------------------------------------------------------------------------
// Data-layer providers
// ---------------------------------------------------------------------------

/// Provides the [AuthRemoteDataSource] backed by the shared [ApiClient].
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

/// Provides the [AuthRepository] implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// ---------------------------------------------------------------------------
// Domain-layer providers
// ---------------------------------------------------------------------------

/// Provides the [LoginUseCase].
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

// ---------------------------------------------------------------------------
// Presentation-layer state
// ---------------------------------------------------------------------------

/// Async state for the login operation.
/// Holds [AsyncValue.data] with [Either<Failure, UserEntity>] after a login attempt.
final loginStateProvider =
    StateProvider<AsyncValue<Either<Failure, UserEntity>>?>((_) => null);
