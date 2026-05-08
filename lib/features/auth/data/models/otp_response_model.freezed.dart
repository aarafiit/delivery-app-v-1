// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtpResponseModel _$OtpResponseModelFromJson(Map<String, dynamic> json) {
  return _OtpResponseModel.fromJson(json);
}

/// @nodoc
mixin _$OtpResponseModel {
  String get userId => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  bool get isNewUser => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpResponseModelCopyWith<OtpResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpResponseModelCopyWith<$Res> {
  factory $OtpResponseModelCopyWith(
          OtpResponseModel value, $Res Function(OtpResponseModel) then) =
      _$OtpResponseModelCopyWithImpl<$Res, OtpResponseModel>;
  @useResult
  $Res call(
      {String userId,
      String phoneNumber,
      String accessToken,
      String refreshToken,
      int expiresIn,
      bool isNewUser});
}

/// @nodoc
class _$OtpResponseModelCopyWithImpl<$Res, $Val extends OtpResponseModel>
    implements $OtpResponseModelCopyWith<$Res> {
  _$OtpResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? phoneNumber = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? isNewUser = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpResponseModelImplCopyWith<$Res>
    implements $OtpResponseModelCopyWith<$Res> {
  factory _$$OtpResponseModelImplCopyWith(_$OtpResponseModelImpl value,
          $Res Function(_$OtpResponseModelImpl) then) =
      __$$OtpResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String phoneNumber,
      String accessToken,
      String refreshToken,
      int expiresIn,
      bool isNewUser});
}

/// @nodoc
class __$$OtpResponseModelImplCopyWithImpl<$Res>
    extends _$OtpResponseModelCopyWithImpl<$Res, _$OtpResponseModelImpl>
    implements _$$OtpResponseModelImplCopyWith<$Res> {
  __$$OtpResponseModelImplCopyWithImpl(_$OtpResponseModelImpl _value,
      $Res Function(_$OtpResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? phoneNumber = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? isNewUser = null,
  }) {
    return _then(_$OtpResponseModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpResponseModelImpl extends _OtpResponseModel {
  const _$OtpResponseModelImpl(
      {required this.userId,
      required this.phoneNumber,
      required this.accessToken,
      required this.refreshToken,
      required this.expiresIn,
      required this.isNewUser})
      : super._();

  factory _$OtpResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpResponseModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String phoneNumber;
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final int expiresIn;
  @override
  final bool isNewUser;

  @override
  String toString() {
    return 'OtpResponseModel(userId: $userId, phoneNumber: $phoneNumber, accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, isNewUser: $isNewUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpResponseModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, phoneNumber, accessToken,
      refreshToken, expiresIn, isNewUser);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpResponseModelImplCopyWith<_$OtpResponseModelImpl> get copyWith =>
      __$$OtpResponseModelImplCopyWithImpl<_$OtpResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpResponseModelImplToJson(
      this,
    );
  }
}

abstract class _OtpResponseModel extends OtpResponseModel {
  const factory _OtpResponseModel(
      {required final String userId,
      required final String phoneNumber,
      required final String accessToken,
      required final String refreshToken,
      required final int expiresIn,
      required final bool isNewUser}) = _$OtpResponseModelImpl;
  const _OtpResponseModel._() : super._();

  factory _OtpResponseModel.fromJson(Map<String, dynamic> json) =
      _$OtpResponseModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get phoneNumber;
  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  int get expiresIn;
  @override
  bool get isNewUser;
  @override
  @JsonKey(ignore: true)
  _$$OtpResponseModelImplCopyWith<_$OtpResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
