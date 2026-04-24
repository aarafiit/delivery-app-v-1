import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Parameters required by [LoginUseCase].
class LoginParams {
  final String phone;
  final String password;

  const LoginParams({required this.phone, required this.password});
}

/// Use case for authenticating a user with phone and password.
/// Delegates to [AuthRepository.login].
class LoginUseCase extends BaseUseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) =>
      _repository.login(params.phone, params.password);
}
