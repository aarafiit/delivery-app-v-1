import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifier that manages the guest mode flag.
/// 
/// Tracks whether the user is in guest mode (browsing without authentication).
/// Guest mode allows browsing products but blocks protected actions like
/// adding to cart, checkout, and profile editing.
/// 
/// Requirements: 26.3, 33.5
class GuestNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  /// Sets the guest mode flag.
  /// 
  /// When true, the user is in guest mode and can browse but not perform
  /// protected actions.
  void setGuestMode(bool isGuest) {
    state = isGuest;
  }
}

/// Provider for guest mode state.
/// 
/// Exposes a boolean flag indicating whether the user is in guest mode.
/// Requirements: 26.3, 33.5
final guestProvider = NotifierProvider<GuestNotifier, bool>(GuestNotifier.new);
