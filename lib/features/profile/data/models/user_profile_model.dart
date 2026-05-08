import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Data model for user profile with JSON serialization.
/// 
/// Maps to backend `/app/consumer/{userId}/profile` response.
@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @JsonKey(name: 'id') required String userId,
    required String phoneNumber,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImage,
    required bool isActive,
    DateTime? createdAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Converts model to domain entity.
  UserProfileEntity toEntity() => UserProfileEntity(
        userId: userId,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        email: email,
        profileImage: profileImage,
        isActive: isActive,
        createdAt: createdAt,
      );

  /// Creates model from domain entity.
  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      userId: entity.userId,
      phoneNumber: entity.phoneNumber,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      profileImage: entity.profileImage,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
