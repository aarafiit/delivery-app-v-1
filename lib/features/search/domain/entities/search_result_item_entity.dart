/// A single result returned by the global search endpoint.
///
/// The API returns a uniform shape for every kind of result (product,
/// category, shop, banner) with an optional [type]-specific bag of extras
/// flattened here for convenience.
class SearchResultItem {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String imageUrl;

  // Product-specific extras (null for non-product results).
  final double? price;
  final double? discountPrice;
  final String? unit;
  final double? avgRating;
  final int? totalReviews;

  const SearchResultItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.price,
    this.discountPrice,
    this.unit,
    this.avgRating,
    this.totalReviews,
  });

  bool get isProduct => type.toUpperCase() == 'PRODUCT';

  bool get isCategory => type.toUpperCase() == 'CATEGORY';

  bool get hasDiscount =>
      price != null &&
      discountPrice != null &&
      discountPrice! > 0 &&
      discountPrice! < price!;
}
