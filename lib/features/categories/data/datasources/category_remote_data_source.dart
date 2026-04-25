import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';

abstract interface class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient _apiClient;

  const CategoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.dio.get('/api/categories');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
