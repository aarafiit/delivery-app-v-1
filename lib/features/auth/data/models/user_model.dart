import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data-layer DTO for a user returned by the API.
/// Uses freezed for immutability and json_serializable for JSON mapping.
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String phone,
    String? email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Maps this DTO to the domain [UserEntity].
  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        phone: phone,
        email: email,
      );
}
