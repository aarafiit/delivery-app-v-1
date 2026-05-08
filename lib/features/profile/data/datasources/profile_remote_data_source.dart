import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

/// Remote data source interface for profile operations.
abstract class ProfileRemoteDataSource {
  /// Fetches user profile from backend.
  Future<UserProfileModel> getUserProfile(String userId);

  /// Updates user profile on backend.
  Future<UserProfileModel> updateUserProfile(
    String userId,
    UserProfileModel profile,
  );
}

/// Implementation of [ProfileRemoteDataSource] using Dio HTTP client.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.dio.get(
        '/app/consumer/$userId/profile',
      );

      return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(
    String userId,
    UserProfileModel profile,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        '/app/consumer/$userId/profile',
        data: profile.toJson(),
      );

      return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Handles Dio exceptions and converts them to meaningful error messages.
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
