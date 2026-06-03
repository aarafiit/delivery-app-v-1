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

  /// Additional product images for the gallery/carousel (up to 3).
  /// May be empty, in which case [imageUrl] is the only image.
  final List<String> imageUrls;
  final bool isAvailable;

  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.isAvailable,
  });

  /// Images to display in the details carousel. Prefers [imageUrls] when the
  /// API provides them, otherwise falls back to the single [imageUrl].
  List<String> get galleryImages {
    final images = imageUrls.where((u) => u.isNotEmpty).toList();
    if (images.isNotEmpty) return images;
    return imageUrl.isNotEmpty ? [imageUrl] : const [];
  }
}
