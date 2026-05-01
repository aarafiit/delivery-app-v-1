// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verify_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtpVerifyRequestModel _$OtpVerifyRequestModelFromJson(
    Map<String, dynamic> json) {
  return _OtpVerifyRequestModel.fromJson(json);
}

/// @nodoc
mixin _$OtpVerifyRequestModel {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get otpCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpVerifyRequestModelCopyWith<OtpVerifyRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerifyRequestModelCopyWith<$Res> {
  factory $OtpVerifyRequestModelCopyWith(OtpVerifyRequestModel value,
          $Res Function(OtpVerifyRequestModel) then) =
      _$OtpVerifyRequestModelCopyWithImpl<$Res, OtpVerifyRequestModel>;
  @useResult
  $Res call({String phoneNumber, String otpCode});
}

/// @nodoc
class _$OtpVerifyRequestModelCopyWithImpl<$Res,
        $Val extends OtpVerifyRequestModel>
    implements $OtpVerifyRequestModelCopyWith<$Res> {
  _$OtpVerifyRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? otpCode = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      otpCode: null == otpCode
          ? _value.otpCode
          : otpCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpVerifyRequestModelImplCopyWith<$Res>
    implements $OtpVerifyRequestModelCopyWith<$Res> {
  factory _$$OtpVerifyRequestModelImplCopyWith(
          _$OtpVerifyRequestModelImpl value,
          $Res Function(_$OtpVerifyRequestModelImpl) then) =
      __$$OtpVerifyRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber, String otpCode});
}

/// @nodoc
class __$$OtpVerifyRequestModelImplCopyWithImpl<$Res>
    extends _$OtpVerifyRequestModelCopyWithImpl<$Res,
        _$OtpVerifyRequestModelImpl>
    implements _$$OtpVerifyRequestModelImplCopyWith<$Res> {
  __$$OtpVerifyRequestModelImplCopyWithImpl(_$OtpVerifyRequestModelImpl _value,
      $Res Function(_$OtpVerifyRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? otpCode = null,
  }) {
    return _then(_$OtpVerifyRequestModelImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      otpCode: null == otpCode
          ? _value.otpCode
          : otpCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpVerifyRequestModelImpl implements _OtpVerifyRequestModel {
  const _$OtpVerifyRequestModelImpl(
      {required this.phoneNumber, required this.otpCode});

  factory _$OtpVerifyRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpVerifyRequestModelImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final String otpCode;

  @override
  String toString() {
    return 'OtpVerifyRequestModel(phoneNumber: $phoneNumber, otpCode: $otpCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifyRequestModelImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.otpCode, otpCode) || other.otpCode == otpCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, otpCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifyRequestModelImplCopyWith<_$OtpVerifyRequestModelImpl>
      get copyWith => __$$OtpVerifyRequestModelImplCopyWithImpl<
          _$OtpVerifyRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpVerifyRequestModelImplToJson(
      this,
    );
  }
}

abstract class _OtpVerifyRequestModel implements OtpVerifyRequestModel {
  const factory _OtpVerifyRequestModel(
      {required final String phoneNumber,
      required final String otpCode}) = _$OtpVerifyRequestModelImpl;

  factory _OtpVerifyRequestModel.fromJson(Map<String, dynamic> json) =
      _$OtpVerifyRequestModelImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String get otpCode;
  @override
  @JsonKey(ignore: true)
  _$$OtpVerifyRequestModelImplCopyWith<_$OtpVerifyRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
