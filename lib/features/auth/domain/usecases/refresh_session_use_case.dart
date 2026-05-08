import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for refreshing the access token using the stored refresh token.
/// 
/// This use case is called when:
/// - The access token is expired or about to expire
/// - A 401 Unauthorized error is received from the API
/// 
/// Returns [Right(null)] on success or [Left(Failure)] on error.
class RefreshSessionUseCase extends BaseUseCase<void, NoParams> {
  final AuthRepository _repository;

  RefreshSessionUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.refreshSession();
  }
}
