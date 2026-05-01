import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifier that manages the intended route for post-authentication redirect.
/// 
/// When a user attempts to access a protected route or action while unauthenticated,
/// the intended destination is stored here. After successful authentication, the
/// user is redirected to this stored route.
/// 
/// Requirements: 27.6, 33.6
class AuthRedirectNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  /// Stores the intended route for post-authentication redirect.
  /// 
  /// Called when a user attempts to access a protected route or action
  /// while unauthenticated.
  void setIntendedRoute(String route) {
    state = route;
  }

  /// Retrieves and clears the intended route.
  /// 
  /// Returns the stored route and sets the state to null.
  /// Used after successful authentication to redirect the user to their
  /// intended destination.
  String? getAndClearIntendedRoute() {
    final route = state;
    state = null;
    return route;
  }
}

/// Provider for auth redirect state.
/// 
/// Exposes the intended route for post-authentication redirect.
/// Requirements: 27.6, 33.6
final authRedirectProvider =
    NotifierProvider<AuthRedirectNotifier, String?>(AuthRedirectNotifier.new);
