import '../../domain/entities/search_result_item_entity.dart';
import '../../domain/entities/search_results_entity.dart';
import 'search_result_item_model.dart';

/// Data-layer DTO for the `GET /api/search` response.
/// Each group has the shape `{ "items": [...], "total": n }`.
class SearchResultsModel {
  final String query;
  final List<SearchResultItemModel> products;
  final List<SearchResultItemModel> categories;
  final List<SearchResultItemModel> shops;
  final List<SearchResultItemModel> banners;
  final int totalCount;

  const SearchResultsModel({
    required this.query,
    required this.products,
    required this.categories,
    required this.shops,
    required this.banners,
    required this.totalCount,
  });

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) =>
      SearchResultsModel(
        query: json['query'] as String? ?? '',
        products: _itemsOf(json['products']),
        categories: _itemsOf(json['categories']),
        shops: _itemsOf(json['shops']),
        banners: _itemsOf(json['banners']),
        totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      );

  /// Extracts the `items` array from a result group object.
  static List<SearchResultItemModel> _itemsOf(dynamic group) {
    if (group is! Map<String, dynamic>) return const [];
    final items = group['items'];
    if (items is! List) return const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(SearchResultItemModel.fromJson)
        .toList();
  }

  /// Maps to the domain entity, applying [mapImageUrl] to every item's image.
  SearchResults toEntity(String Function(String) mapImageUrl) {
    List<SearchResultItem> map(List<SearchResultItemModel> models) => models
        .map((m) => m.toEntity())
        .map((e) => SearchResultItem(
              id: e.id,
              type: e.type,
              title: e.title,
              subtitle: e.subtitle,
              imageUrl: mapImageUrl(e.imageUrl),
              price: e.price,
              discountPrice: e.discountPrice,
              unit: e.unit,
              avgRating: e.avgRating,
              totalReviews: e.totalReviews,
            ))
        .toList();

    return SearchResults(
      query: query,
      products: map(products),
      categories: map(categories),
      shops: map(shops),
      banners: map(banners),
      totalCount: totalCount,
    );
  }
}
