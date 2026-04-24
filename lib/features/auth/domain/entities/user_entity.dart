/// Domain entity representing an authenticated user.
/// Pure Dart class — no framework dependencies.
class UserEntity {
  final String id;
  final String name;
  final String phone;
  final String? email;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });
}
