import '../../domain/entities/banner_entity.dart';

/// Data-layer DTO for a banner returned by `GET /api/banners`.
/// Manually parsed — no freezed needed for this simple model.
class BannerModel {
  final String id;
  final String imageUrl;
  final String promotionTitle;
  final String promotionDetails;
  final DateTime? fromDate;
  final DateTime? toDate;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    required this.promotionTitle,
    required this.promotionDetails,
    this.fromDate,
    this.toDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id']?.toString() ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        promotionTitle: json['promotionTitle'] as String? ?? '',
        promotionDetails: json['promotionDetails'] as String? ?? '',
        fromDate: _parseDate(json['fromDate']),
        toDate: _parseDate(json['toDate']),
      );

  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  BannerEntity toEntity() => BannerEntity(
        id: id,
        imageUrl: imageUrl,
        promotionTitle: promotionTitle,
        promotionDetails: promotionDetails,
        fromDate: fromDate,
        toDate: toDate,
      );
}
