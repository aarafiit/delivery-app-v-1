import 'package:dio/dio.dart';

import '../../../../core/error/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/otp_request_model.dart';
import '../models/otp_response_model.dart';
import '../models/otp_verify_request_model.dart';
import '../models/refresh_token_request_model.dart';
import '../models/refresh_token_response_model.dart';

/// Abstract interface for authentication remote data source.
/// Defines methods for OTP-based authentication API calls.
abstract interface class AuthRemoteDataSource {
  /// Requests an OTP to be sent to the provided [phoneNumber].
  /// Throws [ApiException] on API errors.
  Future<void> requestOtp(String phoneNumber);

  /// Verifies the OTP code for the provided [phoneNumber] and [otpCode].
  /// Returns [OtpResponseModel] on success.
  /// Throws [ApiException] on API errors.
  Future<OtpResponseModel> verifyOtp(String phoneNumber, String otpCode);

  /// Refreshes the access token using the provided [refreshToken].
  /// Returns [RefreshTokenResponseModel] with new access token.
  /// Throws [ApiException] on API errors.
  Future<RefreshTokenResponseModel> refreshToken(String refreshToken);

  /// Logs out the user by invalidating the access token on the backend.
  /// Throws [ApiException] on API errors.
  Future<void> logout(String accessToken);
}

/// Dio-backed implementation of [AuthRemoteDataSource].
/// Makes HTTP requests to the backend API for OTP authentication.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      await _apiClient.dio.post(
        '/app/auth/phone/login',
        data: OtpRequestModel(phoneNumber: phoneNumber).toJson(),
      );
    } on DioException catch (e) {
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Failed to send OTP',
      );
    }
  }

  @override
  Future<OtpResponseModel> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final response = await _apiClient.dio.post(
        '/app/auth/otp/verify',
        data: OtpVerifyRequestModel(
          phoneNumber: phoneNumber,
          otpCode: otpCode,
        ).toJson(),
      );
      return OtpResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Invalid OTP',
      );
    }
  }

  @override
  Future<RefreshTokenResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.dio.post(
        '/app/auth/refresh-token',
        data: RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
      );
      return RefreshTokenResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Failed to refresh token',
      );
    }
  }

  @override
  Future<void> logout(String accessToken) async {
    try {
      await _apiClient.dio.post(
        '/app/auth/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
    } on DioException catch (e) {
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Failed to logout',
      );
    }
  }
}
