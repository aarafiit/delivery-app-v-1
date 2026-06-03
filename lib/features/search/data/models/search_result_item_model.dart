import '../../domain/entities/search_result_item_entity.dart';

/// Data-layer DTO for a single search result item.
/// Manually parsed — handles the flattened `extra` bag from the API.
class SearchResultItemModel {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double? price;
  final double? discountPrice;
  final String? unit;
  final double? avgRating;
  final int? totalReviews;

  const SearchResultItemModel({
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

  factory SearchResultItemModel.fromJson(Map<String, dynamic> json) {
    final extra = json['extra'];
    final extraMap = extra is Map<String, dynamic> ? extra : const {};
    return SearchResultItemModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: _toDouble(extraMap['price']),
      discountPrice: _toDouble(extraMap['discountPrice']),
      unit: extraMap['unit'] as String?,
      avgRating: _toDouble(extraMap['avgRating']),
      totalReviews: _toInt(extraMap['totalReviews']),
    );
  }

  static double? _toDouble(dynamic value) =>
      value is num ? value.toDouble() : null;

  static int? _toInt(dynamic value) => value is num ? value.toInt() : null;

  SearchResultItem toEntity() => SearchResultItem(
        id: id,
        type: type,
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        price: price,
        discountPrice: discountPrice,
        unit: unit,
        avgRating: avgRating,
        totalReviews: totalReviews,
      );
}
