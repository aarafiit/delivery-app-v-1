/// Domain entity representing an authenticated user for OTP authentication.
/// Pure Dart class — no framework dependencies.
class AuthUserEntity {
  final String userId;
  final String phoneNumber;
  final bool isNewUser;

  const AuthUserEntity({
    required this.userId,
    required this.phoneNumber,
    required this.isNewUser,
  });
}
