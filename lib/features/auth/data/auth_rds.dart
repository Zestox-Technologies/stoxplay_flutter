import 'package:dio/dio.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/app_error.dart';

import 'models/auth_params_model.dart';
import 'models/check_phone_number_model.dart';
import 'models/user_model.dart';

abstract class AuthRds {
  Future<CheckPhoneNumberModel> checkPhoneNumber({required AuthParamsModel params});

  Future<ApiResponse> initiateSignup({required AuthParamsModel params});

  Future<ApiResponse<UserModel?>> verifyOtp({required AuthParamsModel params});

  Future<ApiResponse<UserModel>> completeSignUp({required AuthParamsModel params});

  Future<String> logout({required String params});
}

class AuthRdsImpl implements AuthRds {
  final ApiService client;

  AuthRdsImpl({required this.client});

  @override
  Future<CheckPhoneNumberModel> checkPhoneNumber({required AuthParamsModel params}) async {
    try {
      final response = await client.post(ApiUrls.checkPhone, data: params.toJson());

      final baseResponse = ApiResponse<CheckPhoneNumberModel>.fromJson(
        response.data,
        (json) => CheckPhoneNumberModel.fromJson(json),
      );

      if (baseResponse.isSuccess && baseResponse.data != null) {
        return baseResponse.data!;
      }

      throw NetworkError(message: baseResponse.message);
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse> initiateSignup({required AuthParamsModel params}) async {
    try {
      final response = await client.post(ApiUrls.initiateSignUp, data: params.toJson());

      final baseResponse = ApiResponse.fromJson(response.data, (json) {});

      return baseResponse;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<UserModel?>> verifyOtp({required AuthParamsModel params}) async {
    try {
      final response = await client.post(
        params.isUserExists == true ? ApiUrls.loginWithOTP : ApiUrls.verifyOTP,
        data: params.toJson(),
      );

      if (params.isUserExists == true) {
        return ApiResponse<UserModel>.fromJson(response.data, (json) => UserModel.fromJson(json));
      } else {
        return ApiResponse.fromJson(response.data, (_) => null);
      }
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<UserModel>> completeSignUp({required AuthParamsModel params}) async {
    try {
      final response = await client.post(ApiUrls.completeSignUp, data: params.toJson());

      final baseResponse = ApiResponse<UserModel>.fromJson(response.data, (json) {
        return UserModel.fromJson(json);
      });

      return baseResponse;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<String> logout({required String params}) async {
    try {
      final response = await client.post(ApiUrls.logout, data: {"fcmToken" :params});
      return '';
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred');
    }
  }
}
