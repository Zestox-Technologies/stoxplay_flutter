import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/core/network/use_case.dart';
import 'package:stoxplay/features/auth/data/models/auth_params_model.dart';
import 'package:stoxplay/features/auth/data/models/check_phone_number_model.dart';
import 'package:stoxplay/features/auth/data/models/user_model.dart';
import 'package:stoxplay/features/auth/domain/auth_repo.dart';

class CheckPhoneNumberUseCase extends UseCase<CheckPhoneNumberModel, AuthParamsModel> {
  final AuthRepository repository;

  CheckPhoneNumberUseCase({required this.repository});

  @override
  Future<Either<AppError, CheckPhoneNumberModel>> call(AuthParamsModel params) async {
    return await repository.checkPhoneNumber(params: params);
  }
}

class InitiateSignUpUseCase extends UseCase<ApiResponse, AuthParamsModel> {
  final AuthRepository repository;

  InitiateSignUpUseCase({required this.repository});

  @override
  Future<Either<AppError, ApiResponse>> call(AuthParamsModel params) async {
    return await repository.initiateSignUp(params: params);
  }
}

class VerifyOtpUseCase extends UseCase<ApiResponse<UserModel?>, AuthParamsModel> {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  @override
  Future<Either<AppError, ApiResponse<UserModel?>>> call(AuthParamsModel params) async {
    return await repository.verifyOtp(params: params);
  }
}

class CompleteSignupUseCase extends UseCase<ApiResponse<UserModel>, AuthParamsModel> {
  final AuthRepository repository;

  CompleteSignupUseCase({required this.repository});

  @override
  Future<Either<AppError, ApiResponse<UserModel>>> call(AuthParamsModel params) async {
    return await repository.completeSignUp(params: params);
  }
}
