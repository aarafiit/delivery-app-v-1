import '../../../../core/network/api_client.dart';
import '../models/banner_model.dart';

abstract interface class BannerRemoteDataSource {
  Future<List<BannerModel>> getBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final ApiClient _apiClient;

  const BannerRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<BannerModel>> getBanners() async {
    final response = await _apiClient.dio.get('/api/banners');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
