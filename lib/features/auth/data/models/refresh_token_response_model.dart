import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_response_model.freezed.dart';
part 'refresh_token_response_model.g.dart';

@freezed
class RefreshTokenResponseModel with _$RefreshTokenResponseModel {
  const factory RefreshTokenResponseModel({
    required String accessToken,
    required int expiresIn,
  }) = _RefreshTokenResponseModel;

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseModelFromJson(json);
}
