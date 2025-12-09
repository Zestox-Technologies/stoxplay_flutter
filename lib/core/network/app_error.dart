import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AppError {
  final String message;
  final String? code;
  final dynamic data;

  const AppError({required this.message, this.code, this.data});

  @override
  String toString() => message; // 👈 this is critical
}

class NetworkError extends AppError {
  const NetworkError({required super.message, super.code, super.data});

  factory NetworkError.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkError(message: AppErrorMessages.connectionTimeout, code: AppErrorMessages.timeoutCode);
      case DioExceptionType.badResponse:
        return NetworkError(
          message: AppErrorMessages.getErrorMessage(error.response?.statusCode),
          code: error.response?.statusCode.toString(),
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return const NetworkError(message: AppErrorMessages.requestCancelled, code: AppErrorMessages.cancelledCode);
      case DioExceptionType.connectionError:
        return const NetworkError(message: AppErrorMessages.noInternet, code: AppErrorMessages.noConnectionCode);
      default:
        return const NetworkError(message: AppErrorMessages.unknownError, code: AppErrorMessages.unknownCode);
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

class AppErrorMessages {
  static const String connectionTimeout = 'Connection timeout. Please try again.';
  static const String requestCancelled = 'Request cancelled';
  static const String noInternet = 'No internet connection';
  static const String unknownError = 'Something went wrong';

  static const String timeoutCode = 'TIMEOUT';
  static const String cancelledCode = 'CANCELLED';
  static const String noConnectionCode = 'NO_CONNECTION';
  static const String unknownCode = 'UNKNOWN';

  static const String badRequest = 'Bad request';
  static const String unauthorized = 'Unauthorized';
  static const String forbidden = 'Forbidden';
  static const String notFound = 'Not found';
  static const String internalServerError = 'Internal server error';

  static String getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return badRequest;
      case 401:
        return unauthorized;
      case 403:
        return forbidden;
      case 404:
        return notFound;
      case 500:
        return internalServerError;
      default:
        return unknownError;
    }
  }
}
Either<AppError, T> handleException<T>(Object e) {
  if (e is DioException) {
    return Left(NetworkError.fromDioError(e));
  } else {
    return Left(NetworkError(message: e.toString()));
  }
}
