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
  
  // Separate error messages for each API operation
  final String? checkPhoneErrorMessage;
  final String? initiateSignUpErrorMessage;
  final String? verifyOtpErrorMessage;
  final String? completeSignUpErrorMessage;
  
  final bool? isPhoneNumberExists;
  final bool? isVerified;
  final bool? isOTPVerified;

  const AuthState({
    this.checkPhoneApiStatus = ApiStatus.initial,
    this.initiateSignUpStatus = ApiStatus.initial,
    this.verifyOtpStatus = ApiStatus.initial,
    this.completeSignUpStatus = ApiStatus.initial,
    this.user,
    this.checkPhoneErrorMessage,
    this.initiateSignUpErrorMessage,
    this.verifyOtpErrorMessage,
    this.completeSignUpErrorMessage,
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
    String? checkPhoneErrorMessage,
    String? initiateSignUpErrorMessage,
    String? verifyOtpErrorMessage,
    String? completeSignUpErrorMessage,
    bool? isPhoneNumberExists,
    bool? isVerified,
    bool? isOTPVerified,
  }) {
    return AuthState(
      checkPhoneApiStatus: checkPhoneApiStatus ?? this.checkPhoneApiStatus,
      initiateSignUpStatus: initiateSignUpStatus ?? this.initiateSignUpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      completeSignUpStatus: completeSignUpStatus ?? this.completeSignUpStatus,
      user: user ?? this.user,
      checkPhoneErrorMessage: checkPhoneErrorMessage ?? this.checkPhoneErrorMessage,
      initiateSignUpErrorMessage: initiateSignUpErrorMessage ?? this.initiateSignUpErrorMessage,
      verifyOtpErrorMessage: verifyOtpErrorMessage ?? this.verifyOtpErrorMessage,
      completeSignUpErrorMessage: completeSignUpErrorMessage ?? this.completeSignUpErrorMessage,
      isPhoneNumberExists: isPhoneNumberExists ?? this.isPhoneNumberExists,
      isVerified: isVerified ?? this.isVerified,
      isOTPVerified: isOTPVerified ?? this.isOTPVerified,
    );
  }

  @override
  List<Object?> get props => [
    checkPhoneApiStatus,
    initiateSignUpStatus,
    verifyOtpStatus,
    completeSignUpStatus,
    user,
    checkPhoneErrorMessage,
    initiateSignUpErrorMessage,
    verifyOtpErrorMessage,
    completeSignUpErrorMessage,
    isPhoneNumberExists,
    isVerified,
    isOTPVerified,
  ];
}
