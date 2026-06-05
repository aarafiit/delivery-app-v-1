import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_user_entity.dart';

part 'otp_response_model.freezed.dart';
part 'otp_response_model.g.dart';

/// Response from `POST /app/auth/otp/verify`.
///
/// The backend returns a single opaque [token] — there is no separate refresh
/// token or expiry. The app treats [token] as the access token.
@freezed
class OtpResponseModel with _$OtpResponseModel {
  const OtpResponseModel._();

  const factory OtpResponseModel({
    required String userId,
    required String phoneNumber,
    required String token,
    @Default(false) bool isNewUser,
  }) = _OtpResponseModel;

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseModelFromJson(json);

  /// The app stores the opaque [token] as its access token.
  String get accessToken => token;

  AuthUserEntity toEntity() => AuthUserEntity(
        userId: userId,
        phoneNumber: phoneNumber,
        isNewUser: isNewUser,
      );
}
