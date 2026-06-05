import 'package:dio/dio.dart';

import '../../../../core/error/api_exception.dart';
import '../../../../core/error/failure.dart';
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

  /// Safely converts a [DioException] into an [ApiException].
  ///
  /// Never throws while extracting the message — the response body may be
  /// null, a String, or a Map without a `message` key (e.g. a bare 404), so
  /// it must not be blindly indexed. Falls back to the typed [Failure] the
  /// [ErrorInterceptor] attaches, then to [fallback].
  ApiException _toApiException(DioException e, String fallback) {
    final status = e.response?.statusCode ?? 500;

    String? message;
    final data = e.response?.data;
    if (data is Map) {
      final m = data['message'] ?? data['error'];
      if (m is String && m.isNotEmpty) message = m;
    }
    if (message == null) {
      final mapped = e.error;
      if (mapped is Failure && mapped.message.isNotEmpty) {
        message = mapped.message;
      }
    }

    return ApiException(statusCode: status, message: message ?? fallback);
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      await _apiClient.dio.post(
        '/app/auth/phone/login',
        data: OtpRequestModel(phoneNumber: phoneNumber).toJson(),
      );
    } on DioException catch (e) {
      throw _toApiException(e, 'Failed to send OTP');
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
      throw _toApiException(e, 'Invalid OTP');
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
      throw _toApiException(e, 'Failed to refresh token');
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
      throw _toApiException(e, 'Failed to logout');
    }
  }
}
