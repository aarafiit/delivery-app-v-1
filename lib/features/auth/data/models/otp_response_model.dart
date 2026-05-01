import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_user_entity.dart';

part 'otp_response_model.freezed.dart';
part 'otp_response_model.g.dart';

@freezed
class OtpResponseModel with _$OtpResponseModel {
  const OtpResponseModel._();
  
  const factory OtpResponseModel({
    @JsonKey(name: 'token') required String authToken,
    required String userId,
    required String phoneNumber,
    required bool isNewUser,
  }) = _OtpResponseModel;

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseModelFromJson(json);
  
  AuthUserEntity toEntity() => AuthUserEntity(
    userId: userId,
    phoneNumber: phoneNumber,
    isNewUser: isNewUser,
  );
}
