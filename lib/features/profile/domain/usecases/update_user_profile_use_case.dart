import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Parameters for updating user profile.
class UpdateProfileParams {
  final String userId;
  final UserProfileEntity profile;

  const UpdateProfileParams({
    required this.userId,
    required this.profile,
  });
}

/// Use case for updating user profile data.
/// 
/// Takes UpdateProfileParams and returns updated UserProfileEntity.
class UpdateUserProfileUseCase 
    extends BaseUseCase<UserProfileEntity, UpdateProfileParams> {
  final ProfileRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(
    UpdateProfileParams params,
  ) async {
    return await _repository.updateUserProfile(
      params.userId,
      params.profile,
    );
  }
}
