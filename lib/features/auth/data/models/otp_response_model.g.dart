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
      token: json['token'] as String,
      isNewUser: json['isNewUser'] as bool? ?? false,
    );

Map<String, dynamic> _$$OtpResponseModelImplToJson(
        _$OtpResponseModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'token': instance.token,
      'isNewUser': instance.isNewUser,
    };
