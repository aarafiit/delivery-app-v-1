import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_state_entity.dart';
import '../entities/auth_user_entity.dart';
import '../entities/user_entity.dart';

/// Abstract repository interface for authentication operations.
/// Implementations live in the data layer.
abstract interface class AuthRepository {
  /// Authenticates a user with [phone] and [password].
  /// Returns [UserEntity] on success or a typed [Failure] on error.
  Future<Either<Failure, UserEntity>> login(String phone, String password);

  /// Requests an OTP to be sent to the provided [phoneNumber].
  /// Returns void on success or a typed [Failure] on error.
  Future<Either<Failure, void>> requestOtp(String phoneNumber);

  /// Verifies the OTP code for the provided [phoneNumber] and [otpCode].
  /// Returns [AuthUserEntity] on success or a typed [Failure] on error.
  Future<Either<Failure, AuthUserEntity>> verifyOtp(
    String phoneNumber,
    String otpCode,
  );

  /// Refreshes the access token using the stored refresh token.
  /// Returns void on success or a typed [Failure] on error.
  Future<Either<Failure, void>> refreshSession();

  /// Logs out the current user and clears stored credentials.
  Future<Either<Failure, void>> logout();

  /// Restores the authentication session from stored credentials.
  /// Returns [AuthStateEntity] on success or a typed [Failure] on error.
  Future<Either<Failure, AuthStateEntity>> restoreSession();
}
