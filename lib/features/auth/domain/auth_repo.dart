import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/features/auth/data/auth_rds.dart';
import 'package:stoxplay/features/auth/data/models/auth_params_model.dart';
import 'package:stoxplay/features/auth/data/models/check_phone_number_model.dart';
import 'package:stoxplay/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<AppError, CheckPhoneNumberModel>> checkPhoneNumber({required AuthParamsModel params});

  Future<Either<AppError, ApiResponse>> initiateSignUp({required AuthParamsModel params});

  Future<Either<AppError, ApiResponse<UserModel?>>> verifyOtp({required AuthParamsModel params});

  Future<Either<AppError, ApiResponse<UserModel>>> completeSignUp({required AuthParamsModel params});

  Future<Either<AppError, String>> logout({required String params});
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRds authRds;

  AuthRepositoryImpl({required this.authRds});

  @override
  Future<Either<AppError, CheckPhoneNumberModel>> checkPhoneNumber({required AuthParamsModel params}) async {
    try {
      final result = await authRds.checkPhoneNumber(params: params);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError, ApiResponse>> initiateSignUp({required AuthParamsModel params}) async {
    try {
      final result = await authRds.initiateSignup(params: params);

      if (result.success != true) {
        return Left(UnknownError(message: result.message));
      }

      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError, ApiResponse<UserModel?>>> verifyOtp({required AuthParamsModel params}) async {
    try {
      final result = await authRds.verifyOtp(params: params);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError, ApiResponse<UserModel>>> completeSignUp({required AuthParamsModel params}) async {
    try {
      final result = await authRds.completeSignUp(params: params);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError, String>> logout({required String params}) async {
    try {
      final result = await authRds.logout(params: params);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }
}
