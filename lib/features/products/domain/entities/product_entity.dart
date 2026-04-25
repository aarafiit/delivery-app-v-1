/// Domain entity representing a product.
/// Pure Dart class — no framework dependencies.
/// (Requirements 24.5)
class ProductEntity {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final bool isAvailable;

  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.isAvailable,
  });
}
