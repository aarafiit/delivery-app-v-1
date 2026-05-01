import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for requesting an OTP to be sent to a phone number.
class RequestOtpUseCase extends BaseUseCase<void, RequestOtpParams> {
  final AuthRepository _repository;

  const RequestOtpUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(RequestOtpParams params) {
    return _repository.requestOtp(params.phoneNumber);
  }
}

/// Parameters for requesting an OTP.
class RequestOtpParams {
  final String phoneNumber;

  const RequestOtpParams(this.phoneNumber);
}
