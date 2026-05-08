/// User profile entity representing authenticated user data.
/// 
/// Pure Dart class with no framework dependencies.
/// Includes null-safe display name resolution and initials generation.
class UserProfileEntity {
  final String userId;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImage;
  final bool isActive;
  final DateTime? createdAt;

  const UserProfileEntity({
    required this.userId,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    required this.isActive,
    this.createdAt,
  });

  /// Returns a user-friendly display name with null-safe logic.
  /// 
  /// Logic:
  /// - If both firstName and lastName exist: "John Doe"
  /// - If only firstName exists: "John"
  /// - If only lastName exists: "Doe"
  /// - If both are null: "Welcome!"
  String get displayName {
    final first = firstName?.trim();
    final last = lastName?.trim();

    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      return '$first $last';
    } else if (first != null && first.isNotEmpty) {
      return first;
    } else if (last != null && last.isNotEmpty) {
      return last;
    } else {
      return 'Welcome!';
    }
  }

  /// Returns initials for avatar display.
  /// 
  /// Logic:
  /// - If both names exist: "JD"
  /// - If only firstName: "J"
  /// - If only lastName: "D"
  /// - If both null: "?"
  String get initials {
    final first = firstName?.trim();
    final last = lastName?.trim();

    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    } else if (first != null && first.isNotEmpty) {
      return first[0].toUpperCase();
    } else if (last != null && last.isNotEmpty) {
      return last[0].toUpperCase();
    } else {
      return '?';
    }
  }

  /// Returns true if the user has set their name.
  bool get hasName {
    final first = firstName?.trim();
    final last = lastName?.trim();
    return (first != null && first.isNotEmpty) || 
           (last != null && last.isNotEmpty);
  }

  /// Creates a copy with updated fields.
  UserProfileEntity copyWith({
    String? userId,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImage,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserProfileEntity(
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileEntity &&
        other.userId == userId &&
        other.phoneNumber == phoneNumber &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.isActive == isActive &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      phoneNumber,
      firstName,
      lastName,
      email,
      profileImage,
      isActive,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'UserProfileEntity(userId: $userId, phoneNumber: $phoneNumber, '
        'firstName: $firstName, lastName: $lastName, email: $email, '
        'profileImage: $profileImage, isActive: $isActive, createdAt: $createdAt)';
  }
}
