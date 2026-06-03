/// Domain entity representing a promotional banner.
/// Pure Dart class — no framework dependencies.
class BannerEntity {
  final String id;
  final String imageUrl;
  final String promotionTitle;
  final String promotionDetails;

  /// Active date range for the promotion. May be null when the API omits them.
  final DateTime? fromDate;
  final DateTime? toDate;

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    required this.promotionTitle,
    required this.promotionDetails,
    this.fromDate,
    this.toDate,
  });

  /// Whether [now] falls within the banner's active date range.
  /// Missing bounds are treated as unbounded, so a banner with no dates
  /// is always considered active.
  bool isActiveOn(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    if (fromDate != null && today.isBefore(fromDate!)) return false;
    if (toDate != null && today.isAfter(toDate!)) return false;
    return true;
  }
}
