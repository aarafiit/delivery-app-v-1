// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtpVerifyRequestModelImpl _$$OtpVerifyRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpVerifyRequestModelImpl(
      phoneNumber: json['phoneNumber'] as String,
      otpCode: json['otpCode'] as String,
    );

Map<String, dynamic> _$$OtpVerifyRequestModelImplToJson(
        _$OtpVerifyRequestModelImpl instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'otpCode': instance.otpCode,
    };
