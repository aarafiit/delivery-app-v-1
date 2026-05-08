import 'auth_user_entity.dart';

/// Domain entity representing the authentication state of the application.
/// Pure Dart class — no framework dependencies.
class AuthStateEntity {
  final String? accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiry;
  final AuthUserEntity? user;
  final bool isAuthenticated;
  final bool isGuest;

  const AuthStateEntity({
    this.accessToken,
    this.refreshToken,
    this.tokenExpiry,
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
    required String accessToken,
    required String refreshToken,
    required DateTime tokenExpiry,
    required AuthUserEntity user,
  }) =>
      AuthStateEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenExpiry: tokenExpiry,
        user: user,
        isAuthenticated: true,
        isGuest: false,
      );
}
