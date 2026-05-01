// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtpResponseModelImpl _$$OtpResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpResponseModelImpl(
      authToken: json['token'] as String,
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      isNewUser: json['isNewUser'] as bool,
    );

Map<String, dynamic> _$$OtpResponseModelImplToJson(
        _$OtpResponseModelImpl instance) =>
    <String, dynamic>{
      'token': instance.authToken,
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'isNewUser': instance.isNewUser,
    };
