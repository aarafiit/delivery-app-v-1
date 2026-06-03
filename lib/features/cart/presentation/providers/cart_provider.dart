import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/storage/preferences_service.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/cart_local_data_source.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../domain/entities/cart_item_entity.dart';

// ── Data-source providers ────────────────────────────────────────────────────

/// Local persistence for the cart. Null until SharedPreferences resolves;
/// once it does, this rebuilds and [CartNotifier] reloads the stored cart.
final cartLocalDataSourceProvider = Provider<CartLocalDataSource?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).valueOrNull;
  if (prefs == null) return null;
  return CartLocalDataSource(PreferencesService(prefs));
});

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSource(ref.watch(apiClientProvider));
});

// ── Cart state notifier ──────────────────────────────────────────────────────

/// Cart state. Local-first: the on-device list is the display source of truth
/// and is persisted for guests. For authenticated users, adds are also pushed
/// to the server, and a guest's cart is merged on sign-in.
class CartNotifier extends Notifier<List<CartItemEntity>> {
  CartLocalDataSource? get _local => ref.read(cartLocalDataSourceProvider);
  CartRemoteDataSource get _remote => ref.read(cartRemoteDataSourceProvider);

  bool get _isAuthenticated =>
      ref.read(authProvider).value?.isAuthenticated ?? false;

  String get _consumerId => ref.read(authProvider).value?.user?.userId ?? '';

  @override
  List<CartItemEntity> build() {
    // Reloads automatically once SharedPreferences (and thus the local data
    // source) becomes available.
    final local = ref.watch(cartLocalDataSourceProvider);
    if (local == null) return [];
    return local.load();
  }

  Future<void> _persist() async {
    await _local?.save(state);
  }

  /// Adds [quantity] of a product to the cart. Merges with an existing line
  /// for the same product. Persists locally and, when authenticated, pushes
  /// the addition to the server (best-effort — local stays authoritative).
  Future<void> addItem({
    required int productId,
    required String name,
    required String imageUrl,
    required double price,
    required double discountPrice,
    required int quantity,
  }) async {
    final index = state.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      state[index].quantity += quantity;
      state = [...state];
    } else {
      state = [
        ...state,
        CartItemEntity(
          id: productId,
          productId: productId,
          name: name,
          imageUrl: imageUrl,
          price: price,
          discountPrice: discountPrice,
          quantity: quantity,
        ),
      ];
    }
    await _persist();

    if (_isAuthenticated && _consumerId.isNotEmpty) {
      try {
        await _remote.addItem(
          consumerId: _consumerId,
          item: CartItemEntity(
            id: productId,
            productId: productId,
            name: name,
            imageUrl: imageUrl,
            price: price,
            discountPrice: discountPrice,
            quantity: quantity,
          ),
        );
        // Reconcile with the server's authoritative cart.
        await refreshFromServer();
      } catch (_) {
        // Keep the local cart; server sync is best-effort.
      }
    }
  }

  /// Replaces the cart with the authenticated user's server cart
  /// (GET /app/consumer/{consumerId}/cart) and caches it locally.
  /// No-op for guests or when the call fails (keeps the current cart).
  Future<void> refreshFromServer([String? consumerId]) async {
    final id = consumerId ?? _consumerId;
    if (id.isEmpty || !_isAuthenticated) return;
    try {
      state = await _remote.getCart(id);
      await _persist();
    } catch (_) {
      // Keep the current cart if the fetch fails.
    }
  }

  Future<void> increment(int cartItemId) async {
    final index = state.indexWhere((i) => i.id == cartItemId);
    if (index < 0) return;
    state[index].quantity += 1;
    state = [...state];
    await _persist();
  }

  Future<void> decrement(int cartItemId) async {
    final index = state.indexWhere((i) => i.id == cartItemId);
    if (index < 0) return;
    final item = state[index];
    if (item.quantity <= 1) {
      state = state.where((i) => i.id != cartItemId).toList();
    } else {
      item.quantity -= 1;
      state = [...state];
    }
    await _persist();
  }

  Future<void> remove(int cartItemId) async {
    state = state.where((i) => i.id != cartItemId).toList();
    await _persist();
  }

  Future<void> clear() async {
    state = [];
    await _persist();
  }

  /// Merges the current (guest) cart into the authenticated user's server
  /// cart. Called once after a guest signs in. The local cart remains the
  /// on-device source of truth.
  Future<void> mergeOnLogin(String consumerId) async {
    if (consumerId.isEmpty) return;
    try {
      // Push the guest's local items first (if any), then adopt the server's
      // authoritative merged cart. Order matters: merge before any GET so the
      // local items aren't overwritten before they reach the server.
      if (state.isNotEmpty) {
        await _remote.mergeCart(consumerId: consumerId, items: state);
      }
      await refreshFromServer(consumerId);
    } catch (_) {
      // Best-effort: keep the local cart if the merge call fails.
    }
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItemEntity>>(
  CartNotifier.new,
);

// ── Derived providers ────────────────────────────────────────────────────────

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, item) => sum + item.quantity);
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(0.0, (sum, item) => sum + item.lineTotal);
});
