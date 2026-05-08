import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_profile_entity.dart';

/// Repository interface for user profile operations.
/// 
/// Defines contracts for fetching and updating user profile data.
abstract class ProfileRepository {
  /// Fetches user profile from the backend.
  /// 
  /// Returns [Right(UserProfileEntity)] on success.
  /// Returns [Left(Failure)] on error.
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String userId);

  /// Updates user profile on the backend.
  /// 
  /// Returns [Right(UserProfileEntity)] with updated data on success.
  /// Returns [Left(Failure)] on error.
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
    String userId,
    UserProfileEntity profile,
  );
}
