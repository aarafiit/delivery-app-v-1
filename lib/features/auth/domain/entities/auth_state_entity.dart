import 'auth_user_entity.dart';

/// Domain entity representing the authentication state of the application.
/// Pure Dart class — no framework dependencies.
class AuthStateEntity {
  final String? authToken;
  final AuthUserEntity? user;
  final bool isAuthenticated;
  final bool isGuest;

  const AuthStateEntity({
    this.authToken,
    this.user,
    required this.isAuthenticated,
    required this.isGuest,
  });

  /// Factory method for initial unauthenticated state
  factory AuthStateEntity.initial() => const AuthStateEntity(
        isAuthenticated: false,
        isGuest: false,
      );

  /// Factory method for guest mode state
  factory AuthStateEntity.guest() => const AuthStateEntity(
        isAuthenticated: false,
        isGuest: true,
      );

  /// Factory method for authenticated state
  factory AuthStateEntity.authenticated({
    required String authToken,
    required AuthUserEntity user,
  }) =>
      AuthStateEntity(
        authToken: authToken,
        user: user,
        isAuthenticated: true,
        isGuest: false,
      );
}
