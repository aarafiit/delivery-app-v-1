import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';

/// Abstract repository interface for authentication operations.
/// Implementations live in the data layer.
abstract interface class AuthRepository {
  /// Authenticates a user with [phone] and [password].
  /// Returns [UserEntity] on success or a typed [Failure] on error.
  Future<Either<Failure, UserEntity>> login(String phone, String password);

  /// Logs out the current user and clears stored credentials.
  Future<Either<Failure, Unit>> logout();
}
