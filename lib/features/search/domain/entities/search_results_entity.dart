import 'search_result_item_entity.dart';

/// Aggregated global-search results, grouped by result type.
class SearchResults {
  final String query;
  final List<SearchResultItem> products;
  final List<SearchResultItem> categories;
  final List<SearchResultItem> shops;
  final List<SearchResultItem> banners;
  final int totalCount;

  const SearchResults({
    required this.query,
    this.products = const [],
    this.categories = const [],
    this.shops = const [],
    this.banners = const [],
    this.totalCount = 0,
  });

  /// An empty result set for [query] — used before a search is run.
  const SearchResults.empty(this.query)
      : products = const [],
        categories = const [],
        shops = const [],
        banners = const [],
        totalCount = 0;

  bool get isEmpty => totalCount == 0;
}
