import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/auth/data/models/user_model.dart';

@immutable
class AuthState extends Equatable {
  /// Status for checking if phone number exists
  final ApiStatus checkPhoneApiStatus;
  /// Status for initiating sign up (sending OTP)
  final ApiStatus initiateSignUpStatus;
  /// Status for verifying OTP
  final ApiStatus verifyOtpStatus;
  /// Status for completing sign up (if needed)
  final ApiStatus completeSignUpStatus;

  final UserModel? user;
  final String? errorMessage;
  final String? verifyOtpErrorMessage;
  final bool? isPhoneNumberExists;
  final bool? isVerified;
  final bool? isOTPVerified;

  const AuthState({
    this.checkPhoneApiStatus = ApiStatus.initial,
    this.initiateSignUpStatus = ApiStatus.initial,
    this.verifyOtpStatus = ApiStatus.initial,
    this.completeSignUpStatus = ApiStatus.initial,
    this.user,
    this.errorMessage,
    this.verifyOtpErrorMessage,
    this.isPhoneNumberExists,
    this.isVerified,
    this.isOTPVerified,
  });

  AuthState copyWith({
    ApiStatus? checkPhoneApiStatus,
    ApiStatus? initiateSignUpStatus,
    ApiStatus? verifyOtpStatus,
    ApiStatus? completeSignUpStatus,
    UserModel? user,
    String? errorMessage,
    bool? isPhoneNumberExists,
    bool? isVerified,
    bool? isOTPVerified,
    String? verifyOtpErrorMessage,
  }) {
    return AuthState(
      checkPhoneApiStatus: checkPhoneApiStatus ?? this.checkPhoneApiStatus,
      initiateSignUpStatus: initiateSignUpStatus ?? this.initiateSignUpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      completeSignUpStatus: completeSignUpStatus ?? this.completeSignUpStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isPhoneNumberExists: isPhoneNumberExists ?? this.isPhoneNumberExists,
      isVerified: isVerified ?? this.isVerified,
      isOTPVerified: isOTPVerified ?? this.isOTPVerified,
      verifyOtpErrorMessage: verifyOtpErrorMessage ?? this.verifyOtpErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    checkPhoneApiStatus,
    initiateSignUpStatus,
    verifyOtpStatus,
    completeSignUpStatus,
    user,
    errorMessage,
    isPhoneNumberExists,
    isVerified,
    isOTPVerified,
    verifyOtpErrorMessage,
  ];
}
