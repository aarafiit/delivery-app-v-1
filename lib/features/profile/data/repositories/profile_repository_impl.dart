import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

/// Implementation of [ProfileRepository].
/// 
/// Handles data fetching from remote source and error mapping.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(
    String userId,
  ) async {
    try {
      final model = await _remoteDataSource.getUserProfile(userId);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
    String userId,
    UserProfileEntity profile,
  ) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final updatedModel = await _remoteDataSource.updateUserProfile(
        userId,
        model,
      );
      return Right(updatedModel.toEntity());
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Maps exceptions to appropriate Failure types.
  Failure _mapExceptionToFailure(Exception e) {
    final message = e.toString();

    if (message.contains('No internet connection') ||
        message.contains('Connection timeout') ||
        message.contains('Network error')) {
      return NetworkFailure(message);
    } else if (message.contains('Server error')) {
      return ServerFailure(message);
    } else {
      return ServerFailure('An unexpected error occurred: $message');
    }
  }
}
