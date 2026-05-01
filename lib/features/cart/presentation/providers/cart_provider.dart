import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';

// ── Singleton repository (mock in-memory store) ─────────────────────────────

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl();
});

// ── Cart state notifier ──────────────────────────────────────────────────────

class CartNotifier extends Notifier<List<CartItemEntity>> {
  @override
  List<CartItemEntity> build() => [];

  CartRepositoryImpl get _repo =>
      ref.read(cartRepositoryProvider) as CartRepositoryImpl;

  Future<void> addItem({
    required int productId,
    required String name,
    required String imageUrl,
    required double price,
    required double discountPrice,
    required int quantity,
  }) async {
    await _repo.addItemWithDetails(
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      discountPrice: discountPrice,
      quantity: quantity,
    );
    state = await _repo.getCart();
  }

  Future<void> increment(int cartItemId) async {
    final item = state.firstWhere((i) => i.id == cartItemId);
    await _repo.updateQuantity(cartItemId, item.quantity + 1);
    state = await _repo.getCart();
  }

  Future<void> decrement(int cartItemId) async {
    final item = state.firstWhere((i) => i.id == cartItemId);
    if (item.quantity <= 1) {
      await _repo.removeItem(cartItemId);
    } else {
      await _repo.updateQuantity(cartItemId, item.quantity - 1);
    }
    state = await _repo.getCart();
  }

  Future<void> remove(int cartItemId) async {
    await _repo.removeItem(cartItemId);
    state = await _repo.getCart();
  }

  Future<void> clear() async {
    await _repo.clearCart();
    state = [];
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
