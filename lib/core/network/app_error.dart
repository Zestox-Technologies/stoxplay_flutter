import 'package:dio/dio.dart';

abstract class AppError {
  final String message;
  final String? code;
  final dynamic data;

  const AppError({required this.message, this.code, this.data});
}

class NetworkError extends AppError {
  const NetworkError({required super.message, super.code, super.data});

  factory NetworkError.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkError(
          message: 'Connection timeout. Please try again.',
          code: 'TIMEOUT',
        );
      case DioExceptionType.badResponse:
        return NetworkError(
          message: _getErrorMessage(error.response?.statusCode),
          code: error.response?.statusCode.toString(),
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return const NetworkError(
          message: 'Request cancelled',
          code: 'CANCELLED',
        );
      case DioExceptionType.connectionError:
        return const NetworkError(
          message: 'No internet connection',
          code: 'NO_CONNECTION',
        );
      default:
        return const NetworkError(
          message: 'Something went wrong',
          code: 'UNKNOWN',
        );
    }
  }

  static String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }
}

class ValidationError extends AppError {
  const ValidationError({required super.message, super.code, super.data});
}

class CacheError extends AppError {
  const CacheError({required super.message, super.code, super.data});
}

class AuthError extends AppError {
  const AuthError({required super.message, super.code, super.data});
}

class UnknownError extends AppError {
  const UnknownError({required super.message, super.code, super.data});
}
