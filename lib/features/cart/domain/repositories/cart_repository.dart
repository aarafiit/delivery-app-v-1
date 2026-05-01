import '../entities/cart_item_entity.dart';

abstract interface class CartRepository {
  Future<List<CartItemEntity>> getCart();
  Future<void> addToCart(int productId, int quantity);
  Future<void> updateQuantity(int cartItemId, int quantity);
  Future<void> removeItem(int cartItemId);
  Future<void> clearCart();
}
