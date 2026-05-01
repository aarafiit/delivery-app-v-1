import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_state_entity.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for restoring the authentication session from stored credentials.
class RestoreSessionUseCase extends BaseUseCase<AuthStateEntity, NoParams> {
  final AuthRepository _repository;

  const RestoreSessionUseCase(this._repository);

  @override
  Future<Either<Failure, AuthStateEntity>> call(NoParams params) {
    return _repository.restoreSession();
  }
}
