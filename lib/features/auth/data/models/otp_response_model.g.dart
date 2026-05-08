// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtpResponseModelImpl _$$OtpResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpResponseModelImpl(
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
      isNewUser: json['isNewUser'] as bool,
    );

Map<String, dynamic> _$$OtpResponseModelImplToJson(
        _$OtpResponseModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'isNewUser': instance.isNewUser,
    };
