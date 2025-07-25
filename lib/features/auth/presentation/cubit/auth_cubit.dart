import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/features/auth/data/models/auth_params_model.dart';
import 'package:stoxplay/features/auth/data/models/check_phone_number_model.dart';
import 'package:stoxplay/features/auth/data/models/user_model.dart';
import 'package:stoxplay/features/auth/domain/auth_repo.dart';
import 'package:stoxplay/features/auth/domain/auth_usecase.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

import 'auth_state.dart';

/// Cubit for managing authentication flow (phone check, sign up, OTP, etc.)
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState());

  /// Checks if the phone number exists in the system
  Future<void> checkPhoneNumber(String phoneNumber) async {
    emit(state.copyWith(checkPhoneApiStatus: ApiStatus.loading));
    final response = await CheckPhoneNumberUseCase(
      repository: authRepository,
    ).call(AuthParamsModel(phoneNumber: phoneNumber));
    response.fold(
      (error) {
        emit(state.copyWith(checkPhoneApiStatus: ApiStatus.failed, errorMessage: error.message));
      },
      (data) {
        emit(state.copyWith(checkPhoneApiStatus: ApiStatus.success, isPhoneNumberExists: data.userExists));
      },
    );
  }

  /// Initiates sign up (sends OTP)
  Future<void> initiateSignUp({required String phoneNumber, required String referCode}) async {
    emit(state.copyWith(initiateSignUpStatus: ApiStatus.loading));
    final response = await InitiateSignUpUseCase(
      repository: authRepository,
    ).call(AuthParamsModel(phoneNumber: phoneNumber, referralCode: referCode));
    response.fold(
      (error) {
        emit(state.copyWith(initiateSignUpStatus: ApiStatus.failed, errorMessage: error.message));
      },
      (data) {
        emit(state.copyWith(initiateSignUpStatus: ApiStatus.success, isVerified: data.success));
      },
    );
  }

  /// Verifies the OTP entered by the user
  Future<void> verifyOtp({required String phoneNumber, required String otp, required bool isUserExists}) async {
    emit(state.copyWith(verifyOtpStatus: ApiStatus.loading));
    final response = await VerifyOtpUseCase(
      repository: authRepository,
    ).call(AuthParamsModel(phoneNumber: phoneNumber, otp: otp, isUserExists: isUserExists));
    response.fold(
      (error) {
        emit(
          state.copyWith(verifyOtpStatus: ApiStatus.failed, isOTPVerified: false, verifyOtpErrorMessage: error.message),
        );
      },
      (data) {
        if (isUserExists) {
          StorageService().clearUserToken();
          StorageService().setLoggedIn(true);
          StorageService().write(DBKeys.user, data.data);
          StorageService().saveUserToken(data.data?.token ?? '');
          emit(state.copyWith(verifyOtpStatus: ApiStatus.success, isOTPVerified: data.isSuccess, user: data.data));
        } else {
          emit(state.copyWith(verifyOtpStatus: ApiStatus.success, isOTPVerified: data.isSuccess));
        }
      },
    );
  }

  /// Completes the sign up process (if needed)
  Future<void> completeSignUp({
    required String phoneNumber,
    required String referCode,
    required String userName,
    required String firstName,
    required String lastName,
  }) async {
    emit(state.copyWith(completeSignUpStatus: ApiStatus.loading));
    final response = await CompleteSignupUseCase(repository: authRepository).call(
      AuthParamsModel(
        phoneNumber: phoneNumber,
        referralCode: referCode,
        username: userName,
        firstName: firstName,
        lastName: lastName,
      ),
    );
    response.fold(
      (error) {
        emit(state.copyWith(completeSignUpStatus: ApiStatus.failed, errorMessage: error.message));
      },
      (data) async {
        // Set login status and save user data after successful signup
        StorageService().setLoggedIn(true);
        StorageService().write(DBKeys.user, data.data);
        await StorageService().saveUserToken(data.data!.token!);
        ApiService().updateAuthHeader(data.data!.token!);
        emit(state.copyWith(completeSignUpStatus: ApiStatus.success, user: data.data));
      },
    );
  }

  /// Checks if user is logged in and loads user data
  bool isUserLoggedIn() {
    final isLoggedIn = StorageService().isLoggedIn();
    if (isLoggedIn) {
      final userData = StorageService().read(DBKeys.user);
      if (userData != null) {
        emit(state.copyWith(user: userData));
      }
    }
    return isLoggedIn;
  }
}
