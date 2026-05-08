import 'package:fpdart/fpdart.dart';

import '../../../../core/error/api_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/storage/preferences_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_state_entity.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementation of [AuthRepository] that integrates with remote data source
/// and local storage services for OTP-based authentication with JWT tokens.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;
  final PreferencesService _preferences;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._preferences,
  );

  @override
  Future<Either<Failure, UserEntity>> login(String phone, String password) {
    // This method is deprecated and not used in OTP authentication flow
    // Keeping it for interface compatibility
    return Future.value(
      const Left(ServerFailure('Password login is not supported')),
    );
  }

  @override
  Future<Either<Failure, void>> requestOtp(String phoneNumber) async {
    try {
      await _remoteDataSource.requestOtp(phoneNumber);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> verifyOtp(
    String phoneNumber,
    String otpCode,
  ) async {
    try {
      final response = await _remoteDataSource.verifyOtp(phoneNumber, otpCode);

      // Validate response before storing
      if (response.accessToken.isEmpty || 
          response.refreshToken.isEmpty || 
          response.userId.isEmpty) {
        await _clearAuthData();
        return const Left(ServerFailure('Invalid response from server'));
      }

      // Calculate token expiry
      final tokenExpiry = DateTime.now().add(Duration(seconds: response.expiresIn));

      // Store auth data in secure storage and shared preferences
      try {
        await _secureStorage.saveAccessToken(response.accessToken);
        await _secureStorage.saveRefreshToken(response.refreshToken);
        await _preferences.saveTokenExpiry(tokenExpiry);
        await _preferences.setString('user_id', response.userId);
        await _preferences.setString('phone_number', response.phoneNumber);
        await _preferences.setBool('is_logged_in', true);
        await _preferences.setBool('is_guest', false);
      } catch (storageError) {
        // If storage fails, clean up and return error
        await _clearAuthData();
        return const Left(ServerFailure('Failed to store authentication data'));
      }

      return Right(response.toEntity());
    } on ApiException catch (e) {
      // Ensure auth data is cleared on error
      await _clearAuthData();
      return Left(ServerFailure(e.message));
    } catch (_) {
      await _clearAuthData();
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> refreshSession() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        return const Left(ServerFailure('No refresh token available'));
      }

      final response = await _remoteDataSource.refreshToken(refreshToken);

      // Calculate new expiry
      final tokenExpiry = DateTime.now().add(Duration(seconds: response.expiresIn));

      // Save new access token and expiry
      await _secureStorage.saveAccessToken(response.accessToken);
      await _preferences.saveTokenExpiry(tokenExpiry);

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  /// Clears all authentication data from storage.
  /// Used when verification fails or errors occur.
  Future<void> _clearAuthData() async {
    try {
      await _secureStorage.deleteAccessToken();
      await _secureStorage.deleteRefreshToken();
      await _preferences.deleteTokenExpiry();
      await _preferences.remove('user_id');
      await _preferences.remove('phone_number');
      await _preferences.setBool('is_logged_in', false);
    } catch (_) {
      // Ignore cleanup errors
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Get access token for backend logout call
      final accessToken = await _secureStorage.getAccessToken();

      // Call backend logout if token exists
      if (accessToken != null) {
        try {
          await _remoteDataSource.logout(accessToken);
        } catch (_) {
          // Continue with local logout even if backend call fails
        }
      }

      // Clear all auth data
      await _clearAuthData();

      return const Right(null);
    } catch (_) {
      return const Left(ServerFailure('Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, AuthStateEntity>> restoreSession() async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      final refreshToken = await _secureStorage.getRefreshToken();
      final isLoggedIn = _preferences.getBool('is_logged_in') ?? false;
      final isGuest = _preferences.getBool('is_guest') ?? false;

      // Check if user is in guest mode
      if (isGuest) {
        return Right(AuthStateEntity.guest());
      }

      // Check if user has valid tokens and is logged in
      if (accessToken != null && refreshToken != null && isLoggedIn) {
        final userId = _preferences.getString('user_id') ?? '';
        final phoneNumber = _preferences.getString('phone_number') ?? '';
        final tokenExpiry = _preferences.getTokenExpiry() ?? 
            DateTime.now().add(const Duration(minutes: 15));

        return Right(
          AuthStateEntity.authenticated(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenExpiry: tokenExpiry,
            user: AuthUserEntity(
              userId: userId,
              phoneNumber: phoneNumber,
              isNewUser: false,
            ),
          ),
        );
      }

      // Return initial state if no valid session found
      return Right(AuthStateEntity.initial());
    } catch (_) {
      return const Left(ServerFailure('Failed to restore session'));
    }
  }
}
