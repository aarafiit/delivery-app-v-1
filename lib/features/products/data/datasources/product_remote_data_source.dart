import '../../../../core/error/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

/// Contract for the product remote data source.
abstract interface class ProductRemoteDataSource {
  /// Calls GET /api/products and returns a list of [ProductModel].
  /// Throws [ApiException] on HTTP errors.
  Future<List<ProductModel>> getProducts();

  /// Calls GET /api/products/{id} and returns a single [ProductModel].
  /// Throws [ApiException] on HTTP errors.
  Future<ProductModel> getProductById(int id);
}

/// Dio-backed implementation of [ProductRemoteDataSource].
/// (Requirements 24.1)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _apiClient;

  const ProductRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _apiClient.dio.get('/api/products');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await _apiClient.dio.get('/api/products/$id');
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }
}
