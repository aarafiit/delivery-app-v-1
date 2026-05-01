import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for verifying an OTP code.
class VerifyOtpUseCase extends BaseUseCase<AuthUserEntity, VerifyOtpParams> {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(params.phoneNumber, params.otpCode);
  }
}

/// Parameters for verifying an OTP.
class VerifyOtpParams {
  final String phoneNumber;
  final String otpCode;

  const VerifyOtpParams(this.phoneNumber, this.otpCode);
}
