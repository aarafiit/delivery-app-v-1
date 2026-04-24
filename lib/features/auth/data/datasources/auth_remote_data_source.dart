import '../../../../core/error/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Contract for the auth remote data source.
abstract interface class AuthRemoteDataSource {
  /// Calls the login endpoint and returns a [UserModel].
  /// Throws [ApiException] on HTTP errors.
  Future<UserModel> login(String phone, String password);

  /// Calls the logout endpoint.
  /// Throws [ApiException] on HTTP errors.
  Future<void> logout();
}

/// Dio-backed implementation of [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> login(String phone, String password) async {
    // TODO: replace with real endpoint path and request body
    final response = await _apiClient.dio.post(
      '/auth/login',
      data: {'phone': phone, 'password': password},
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    // TODO: replace with real endpoint path
    await _apiClient.dio.post('/auth/logout');
  }
}
