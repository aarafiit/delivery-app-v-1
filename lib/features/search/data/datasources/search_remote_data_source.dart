import '../../../../core/network/api_client.dart';
import '../models/search_results_model.dart';

abstract interface class SearchRemoteDataSource {
  Future<SearchResultsModel> search(String query, {int limit});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient _apiClient;

  const SearchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<SearchResultsModel> search(String query, {int limit = 10}) async {
    final response = await _apiClient.dio.get(
      '/api/search',
      queryParameters: {'q': query, 'limit': limit},
    );
    return SearchResultsModel.fromJson(response.data as Map<String, dynamic>);
  }
}
