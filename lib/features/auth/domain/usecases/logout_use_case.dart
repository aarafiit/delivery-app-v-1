import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for logging out the current user.
class LogoutUseCase extends BaseUseCase<void, NoParams> {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.logout();
  }
}
