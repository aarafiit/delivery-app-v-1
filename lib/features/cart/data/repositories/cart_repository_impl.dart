import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';

/// Mock implementation of [CartRepository].
/// Stores cart in memory. Replace with API calls when backend is ready.
class CartRepositoryImpl implements CartRepository {
  final List<CartItemEntity> _items = [];
  int _nextId = 1;

  @override
  Future<List<CartItemEntity>> getCart() async => List.from(_items);

  @override
  Future<void> addToCart(int productId, int quantity) async {
    final existing = _items.where((i) => i.productId == productId);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      // Item data is passed in via addToCartWithDetails for mock
    }
  }

  /// Extended method used by the provider to add a full item.
  Future<void> addItemWithDetails({
    required int productId,
    required String name,
    required String imageUrl,
    required double price,
    required double discountPrice,
    required int quantity,
  }) async {
    final existing = _items.where((i) => i.productId == productId);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _items.add(CartItemEntity(
        id: _nextId++,
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        discountPrice: discountPrice,
        quantity: quantity,
      ));
    }
  }

  @override
  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final item = _items.firstWhere((i) => i.id == cartItemId);
    item.quantity = quantity;
  }

  @override
  Future<void> removeItem(int cartItemId) async {
    _items.removeWhere((i) => i.id == cartItemId);
  }

  @override
  Future<void> clearCart() async => _items.clear();
}
