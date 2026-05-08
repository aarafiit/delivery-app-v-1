import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Use case for fetching user profile data.
/// 
/// Takes userId as parameter and returns UserProfileEntity.
class GetUserProfileUseCase extends BaseUseCase<UserProfileEntity, String> {
  final ProfileRepository _repository;

  GetUserProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(String userId) async {
    return await _repository.getUserProfile(userId);
  }
}
