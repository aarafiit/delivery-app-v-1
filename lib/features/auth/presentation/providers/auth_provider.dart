import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_state_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/refresh_session_use_case.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../../domain/usecases/restore_session_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';

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
  final secureStorage = ref.watch(secureStorageServiceProvider);
  final preferences = ref.watch(preferencesServiceProvider);
  return AuthRepositoryImpl(dataSource, secureStorage, preferences);
});

// ---------------------------------------------------------------------------
// Domain-layer providers
// ---------------------------------------------------------------------------

/// Provides the [LoginUseCase].
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Provides the [RequestOtpUseCase].
final requestOtpUseCaseProvider = Provider<RequestOtpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RequestOtpUseCase(repository);
});

/// Provides the [VerifyOtpUseCase].
final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyOtpUseCase(repository);
});

/// Provides the [RefreshSessionUseCase].
final refreshSessionUseCaseProvider = Provider<RefreshSessionUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RefreshSessionUseCase(repository);
});

/// Provides the [LogoutUseCase].
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

/// Provides the [RestoreSessionUseCase].
final restoreSessionUseCaseProvider = Provider<RestoreSessionUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RestoreSessionUseCase(repository);
});

// ---------------------------------------------------------------------------
// Presentation-layer state
// ---------------------------------------------------------------------------

/// Async state for the login operation.
/// Holds [AsyncValue.data] with [Either<Failure, UserEntity>] after a login attempt.
final loginStateProvider =
    StateProvider<AsyncValue<Either<Failure, UserEntity>>?>((_) => null);

/// AsyncNotifier that manages the authentication state for JWT authentication.
/// 
/// Handles:
/// - Session restoration on app launch
/// - OTP request and verification
/// - Token refresh
/// - Logout
/// - Guest mode
/// 
/// Requirements: 25.3, 25.5, 25.9, 26.2, 31.5, 33.1, 33.2, 33.3, 33.4, 33.7, 33.8
class AuthNotifier extends AsyncNotifier<AuthStateEntity> {
  @override
  Future<AuthStateEntity> build() async {
    // Restore session on initialization
    return await _restoreSession();
  }

  /// Restores the authentication session from stored credentials.
  /// Called automatically in build() on app launch.
  /// 
  /// Checks if token is expired and attempts refresh if needed.
  /// Fetches user profile if authenticated.
  Future<AuthStateEntity> _restoreSession() async {
    final useCase = ref.read(restoreSessionUseCaseProvider);
    final result = await useCase(const NoParams());

    return await result.fold(
      (failure) async => AuthStateEntity.initial(),
      (authState) async {
        // If not authenticated or guest, return as-is
        if (!authState.isAuthenticated || authState.isGuest) {
          return authState;
        }

        // Check if token is expired
        final preferences = ref.read(preferencesServiceProvider);
        final isExpired = preferences.isAccessTokenExpired();

        if (isExpired) {
          // Try to refresh
          final refreshed = await refreshSession();
          if (refreshed) {
            // Fetch profile after successful refresh
            final userId = preferences.getString('user_id') ?? '';
            if (userId.isNotEmpty) {
              ref.read(profileProvider.notifier).fetchProfile(userId);
            }
            return authState;
          } else {
            // Refresh failed - logout
            await logout();
            return AuthStateEntity.initial();
          }
        }

        // Token is valid - fetch profile
        final userId = preferences.getString('user_id') ?? '';
        if (userId.isNotEmpty) {
          ref.read(profileProvider.notifier).fetchProfile(userId);
        }

        return authState;
      },
    );
  }

  /// Refreshes the access token using the stored refresh token.
  /// 
  /// Returns true on success, false on failure.
  Future<bool> refreshSession() async {
    final useCase = ref.read(refreshSessionUseCaseProvider);
    final result = await useCase(const NoParams());

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Requests an OTP for the given phone number.
  /// 
  /// Throws [Failure] if the request fails.
  /// Requirements: 25.3
  Future<void> requestOtp(String phoneNumber) async {
    final useCase = ref.read(requestOtpUseCaseProvider);
    final result = await useCase(RequestOtpParams(phoneNumber));

    result.fold(
      (failure) => throw failure,
      (_) => null,
    );
  }

  /// Verifies the OTP code for the given phone number.
  /// 
  /// Updates the state to authenticated on success.
  /// Triggers profile fetch after successful authentication.
  /// Throws [Failure] if verification fails.
  /// Requirements: 25.5, 33.1, 33.2, 33.3, 33.4
  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    final useCase = ref.read(verifyOtpUseCaseProvider);
    final result = await useCase(VerifyOtpParams(phoneNumber, otpCode));

    await result.fold(
      (failure) async => throw failure,
      (user) async {
        // Read tokens from secure storage
        final secureStorage = ref.read(secureStorageServiceProvider);
        final preferences = ref.read(preferencesServiceProvider);
        
        final accessToken = await secureStorage.getAccessToken() ?? '';
        final refreshToken = await secureStorage.getRefreshToken() ?? '';
        final tokenExpiry = preferences.getTokenExpiry() ?? 
            DateTime.now().add(const Duration(minutes: 15));

        state = AsyncValue.data(
          AuthStateEntity.authenticated(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenExpiry: tokenExpiry,
            user: user,
          ),
        );

        // Fetch user profile after successful authentication
        ref.read(profileProvider.notifier).fetchProfile(user.userId);
      },
    );
  }

  /// Logs out the current user.
  /// 
  /// Clears all stored authentication data and resets state to initial.
  /// Clears profile data.
  /// Throws [Failure] if logout fails.
  /// Requirements: 25.9, 33.8
  Future<void> logout() async {
    final useCase = ref.read(logoutUseCaseProvider);
    final result = await useCase(const NoParams());

    result.fold(
      (failure) => throw failure,
      (_) {
        // Clear profile data
        ref.read(profileProvider.notifier).clearProfile();
        
        // Clear auth state
        state = AsyncValue.data(AuthStateEntity.initial());
      },
    );
  }

  /// Sets the app to guest mode.
  /// 
  /// Allows users to browse without authentication.
  /// Requirements: 26.2, 33.7
  void setGuestMode() {
    state = AsyncValue.data(AuthStateEntity.guest());
  }

  /// Returns true if the user is authenticated.
  bool get isAuthenticated {
    return state.value?.isAuthenticated ?? false;
  }

  /// Returns true if the user is in guest mode.
  bool get isGuest {
    return state.value?.isGuest ?? false;
  }

  /// Returns the current access token.
  String? get accessToken {
    return state.value?.accessToken;
  }

  /// Returns the current refresh token.
  String? get refreshToken {
    return state.value?.refreshToken;
  }

  /// Checks if the access token is expired.
  bool get isTokenExpired {
    final preferences = ref.read(preferencesServiceProvider);
    return preferences.isAccessTokenExpired();
  }
}

/// The main auth provider consumed by the UI.
/// 
/// Exposes the current authentication state including:
/// - accessToken
/// - refreshToken
/// - tokenExpiry
/// - user (userId, phoneNumber, isNewUser)
/// - isAuthenticated flag
/// - isGuest flag
/// 
/// Requirements: 33.1, 33.2, 33.3, 33.7
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthStateEntity>(AuthNotifier.new);
