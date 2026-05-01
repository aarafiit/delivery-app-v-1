/// Domain entity for a single item in the cart.
class CartItemEntity {
  final int id;
  final int productId;
  final String name;
  final String imageUrl;
  final double price;
  final double discountPrice;
  int quantity;

  CartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discountPrice,
    required this.quantity,
  });

  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  double get effectivePrice => hasDiscount ? discountPrice : price;
  double get lineTotal => effectivePrice * quantity;
}
