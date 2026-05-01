import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_verify_request_model.freezed.dart';
part 'otp_verify_request_model.g.dart';

@freezed
class OtpVerifyRequestModel with _$OtpVerifyRequestModel {
  const factory OtpVerifyRequestModel({
    required String phoneNumber,
    required String otpCode,
  }) = _OtpVerifyRequestModel;

  factory OtpVerifyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestModelFromJson(json);
}
