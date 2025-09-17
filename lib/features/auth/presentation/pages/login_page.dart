import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/auth/data/models/auth_params_model.dart';
import 'package:stoxplay/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:stoxplay/features/auth/presentation/cubit/auth_state.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/utils/common/cubits/timer_cubit.dart';
import 'package:stoxplay/utils/common/functions/snackbar.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/common_stoxplay_icon.dart';
import 'package:stoxplay/utils/common/widgets/common_textfield.dart';
import 'package:stoxplay/utils/common/widgets/shadow_container.dart';
import 'package:stoxplay/utils/common/widgets/termsAndConditionWidget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/text_formatter_extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with CodeAutoFill {
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final ValueNotifier<bool> isCheckboxChecked = ValueNotifier<bool>(false);
  final ValueNotifier<int> stepper = ValueNotifier<int>(0);
  final TextEditingController referralIdController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode referralFocusNode = FocusNode();
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
    _initializeSmsAutofill();
    // Try to fetch phone hint when the phone field gains focus and is empty
    mobileFocusNode.addListener(() {
      if (mobileFocusNode.hasFocus && mobileNoController.text.isEmpty) {
        _getPhoneHint();
      }
    });
  }

  void _resetFormState(AuthCubit authCubit) {
    // Reset form state when starting fresh
    otpController.clear();
    referralIdController.clear();
    if (stepper.value == 1) {
      stepper.value = 0;
    }
  }

  Future<void> _initializeSmsAutofill() async {
    try {
      // Request phone number hint and populate the field if user selects one
      final hint = await SmsAutoFill().hint;
      if (hint != null && hint.isNotEmpty && mounted) {
        final phoneNumber = hint.replaceAll(RegExp(r'\D'), '');
        if (phoneNumber.length >= 10) {
          final lastTenDigits = phoneNumber.substring(phoneNumber.length - 10);
          setState(() {
            mobileNoController.text = lastTenDigits;
          });
        }
      }
      listenForCode();
    } catch (e) {
      print('SMS autofill initialization error: $e');
    }
  }

  Future<void> _getPhoneHint() async {
    try {
      final hint = await SmsAutoFill().hint;
      if (hint != null && hint.isNotEmpty) {
        final phoneNumber = hint.replaceAll(RegExp(r'\D'), '');
        if (phoneNumber.length >= 10) {
          final lastTenDigits = phoneNumber.substring(phoneNumber.length - 10);
          setState(() {
            mobileNoController.text = lastTenDigits;
          });
        }
      }
    } catch (e) {
      print('Error getting phone hint: $e');
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    cancel();
    mobileNoController.dispose();
    otpController.dispose();
    referralIdController.dispose();
    mobileFocusNode.dispose();
    referralFocusNode.dispose();
    isCheckboxChecked.dispose();
    stepper.dispose();
    super.dispose();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4) {
      setState(() {
        otpController.text = code!;
      });
      _onVerifyOtp(context, context.read<AuthCubit>());
    }
  }

  void _onSendOtp(BuildContext context, AuthCubit authCubit) async {
    final phone = mobileNoController.text.trim();

    if (phone.length != 10) {
      showSnackBar(context: context, message: Strings.pleaseEnterValidMobileNumber);
      return;
    }
    if (!isCheckboxChecked.value) {
      showSnackBar(context: context, message: Strings.pleaseCheckTermsAndConditions);
      return;
    }

    await authCubit.initiateSignUp(phoneNumber: mobileNoController.text, referCode: referralIdController.text);
  }

  Future<void> _onVerifyOtp(BuildContext context, AuthCubit authCubit) async {
    final otp = otpController.text.trim();
    if (otp.length != 4) {
      showSnackBar(context: context, message: Strings.pleaseEnter4DigitOTP);
      return;
    }

    try {
      // Clear any previous error messages

      await authCubit.verifyOtp(
        phoneNumber: mobileNoController.text,
        otp: otp,
        isUserExists: authCubit.state.isPhoneNumberExists!,
      );
    } catch (e) {
      showSnackBar(context: context, message: "OTP verification failed: $e");
    }
  }

  void _handleOTPVerificationSuccess(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final isUserExists = authCubit.state.isPhoneNumberExists ?? false;

    if (isUserExists) {
      homeCubit.registerToken();
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.mainPage, (route) => false);
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.signUpPage,
        arguments: AuthParamsModel(
          phoneNumber: mobileNoController.text.trim(),
          referralCode: referralIdController.text.trim(),
        ),
      );
    }
  }

  void _handleCheckPhoneSuccess(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    if (authCubit.state.isPhoneNumberExists!) {
      context.read<TimerCubit>().startTimer(seconds: 60);
      stepper.value++;
    }
  }

  void _handleInitiateSignUpSuccess(BuildContext context) {
    stepper.value = 1;
    context.read<TimerCubit>().startTimer(seconds: 60);
    showSnackBar(context: context, message: "OTP sent successfully", backgroundColor: AppColors.green);
  }

  void _handlePhoneNumberValidation(String value, AuthCubit authCubit) {
    // Clear any previous error messages and check phone number
    authCubit.checkPhoneNumber(value);
    Future.delayed(const Duration(milliseconds: 100), () {
      referralFocusNode.requestFocus();
    });
  }

  Widget _buildPhoneInputStep(BuildContext context, AuthCubit authCubit) {
    return Column(
      children: [
        BlocSelector<AuthCubit, AuthState, ApiStatus>(
          bloc: authCubit,
          selector: (state) => state.checkPhoneApiStatus,
          builder: (context, state) {
            return CommonTextfield(
              focusNode: mobileFocusNode,
              controller: mobileNoController,
              title: Strings.mobileNumber.toUpperCase(),
              prefixText: "+91   ",
              maxLength: 10,
              onChanged: (value) {
                if (value.isEmpty) {
                  // User cleared the field completely - reset form state
                  _resetFormState(authCubit);
                } else if (value.length == 10) {
                  // Handle phone number validation
                  _handlePhoneNumberValidation(value, authCubit);
                } else {
                  authCubit.clearInitiateSignUpStatus();
                }
              },
              onTap: () async {
                // If empty on tap, open hint picker to let user select the number
                if (mobileNoController.text.isEmpty) {
                  await _getPhoneHint();
                }
              },
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (mobileNoController.text.isEmpty)
                    GestureDetector(
                      onTap: _getPhoneHint,
                      child: Icon(Icons.smartphone, color: AppColors.gradient3, size: 20),
                    ),
                  SizedBox(width: 8),
                  state.isLoading
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(color: AppColors.gradient3, strokeWidth: 2),
                      )
                      : const SizedBox.shrink(),
                ],
              ),
              keyboardType: TextInputType.number,
            );
          },
        ),
        Gap(10.h),
        BlocSelector<AuthCubit, AuthState, bool>(
          bloc: authCubit,
          selector: (state) => state.isPhoneNumberExists ?? true,
          builder: (context, phoneExists) {
            return !phoneExists
                ? CommonTextfield(
                  controller: referralIdController,
                  hintText: Strings.onlyRequiredForNewUsers,
                  title: Strings.referralId,
                  keyboardType: TextInputType.text,
                  focusNode: referralFocusNode,
                  maxLength: 8,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [UpperCaseTextFormatter(), LengthLimitingTextInputFormatter(8)],
                )
                : const SizedBox.shrink();
          },
        ),
        Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: ValueListenableBuilder(
                valueListenable: isCheckboxChecked,
                builder: (context, check, _) {
                  return Checkbox(
                    value: check,
                    checkColor: AppColors.white,
                    activeColor: AppColors.blue3200,
                    onChanged: (value) {
                      isCheckboxChecked.value = value!;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: AppColors.black40),
                    ),
                    visualDensity: VisualDensity.compact,
                  );
                },
              ),
            ),
            Expanded(child: TextView(text: Strings.iCertifyThatIAmAbove18Years, fontSize: 13.sp)),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpStep(BuildContext context, AuthCubit authCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextView(text: Strings.code),
            BlocBuilder<TimerCubit, TimerState>(
              builder: (context, state) {
                if (state.isRunning) {
                  return Text.rich(
                    TextSpan(
                      text: Strings.resendIn,
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${state.secondsRemaining}s',
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else {
                  return BlocBuilder<AuthCubit, AuthState>(
                    bloc: authCubit,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () async {
                          if (state.checkPhoneApiStatus.isSuccess) {
                            // Clear any previous error messages
                            await authCubit.checkPhoneNumber(mobileNoController.text);
                          } else {
                            await authCubit.initiateSignUp(
                              phoneNumber: mobileNoController.text,
                              referCode: referralIdController.text,
                            );
                          }
                        },
                        child: Text(
                          'Resend VOICE OTP',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
        Gap(5.h),
        Center(
          child: SizedBox(
            height: 45.h,
            child: Pinput(
              length: 4,
              separatorBuilder: (index) => SizedBox(width: 20),
              controller: otpController,
              obscureText: true,
              obscuringCharacter: "*",
              onCompleted: (value) async {
                await authCubit.verifyOtp(
                  phoneNumber: mobileNoController.text,
                  otp: value,
                  isUserExists: authCubit.state.isPhoneNumberExists ?? false,
                );
              },
            ),
          ),
        ),
        Gap(20.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(authRepository: sl()),
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (stepper.value == 1) {
                stepper.value--;
                // Clear error messages and reset form when going back to phone input step
                _resetFormState(authCubit);
              }
            },
            child: Scaffold(
              body: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  // Handle check phone number response
                  if (state.checkPhoneApiStatus == ApiStatus.success) {
                    _handleCheckPhoneSuccess(context);
                  } else if (state.checkPhoneApiStatus == ApiStatus.failed) {
                    if (state.checkPhoneErrorMessage != null && state.checkPhoneApiStatus.isSuccess) {
                      showSnackBar(context: context, message: state.checkPhoneErrorMessage!);
                    }
                  }

                  // Handle initiate sign up response
                  if (state.initiateSignUpStatus == ApiStatus.success) {
                    _handleInitiateSignUpSuccess(context);
                  } else if (state.initiateSignUpStatus == ApiStatus.failed) {
                    if (state.initiateSignUpErrorMessage != null && state.checkPhoneErrorMessage == null) {
                      showSnackBar(context: context, message: state.initiateSignUpErrorMessage!);
                    }
                  }

                  // Handle OTP verification response
                  if (state.verifyOtpStatus == ApiStatus.success) {
                    _handleOTPVerificationSuccess(context);
                  } else if (state.verifyOtpStatus == ApiStatus.failed) {
                    if (state.verifyOtpErrorMessage != null) {
                      showSnackBar(context: context, message: state.verifyOtpErrorMessage!);
                    }
                  }
                },
                child: SingleChildScrollView(
                  child: ValueListenableBuilder<int>(
                    valueListenable: stepper,
                    builder: (context, step, _) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Image.asset(AppAssets.lightSplashStrokes, fit: BoxFit.cover),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 100.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CommonStoxplayIcon(
                                              iconHeight: 55.h,
                                              iconWidth: 55.w,
                                              shadowHeight: 15.h,
                                              shadowWidth: 80.w,
                                            ),
                                            CommonStoxplayText(fontSize: 50.sp),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(10.h),
                                TextView(text: Strings.login, fontSize: 40.sp, fontWeight: FontWeight.w700),
                                TextView(
                                  text: step == 0 ? Strings.weWillSendYouOTP : Strings.pleaseSignInToExistingAccount,
                                  fontColor: AppColors.black39,
                                  fontWeight: FontWeight.w300,
                                ),
                                SizedBox(height: 20.h),
                                ShadowContainer(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 28.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        step == 0
                                            ? _buildPhoneInputStep(context, authCubit)
                                            : _buildOtpStep(context, authCubit),
                                        BlocBuilder<AuthCubit, AuthState>(
                                          builder: (context, state) {
                                            final isLoading =
                                                state.checkPhoneApiStatus.isLoading ||
                                                state.initiateSignUpStatus.isLoading ||
                                                state.verifyOtpStatus.isLoading;
                                            final isOtpStep = step == 1;

                                            return AppButton(
                                              text: isOtpStep ? Strings.verifyOTP : Strings.sendOTP,
                                              isLoading: isLoading,
                                              onPressed: () async {
                                                if (!isOtpStep) {
                                                  _onSendOtp(context, authCubit);
                                                } else {
                                                  await _onVerifyOtp(context, authCubit);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gap(10.h),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    "Note: For your security, the OTP will be delivered to you through a phone call. Please be patient and wait for the call — this process may take a short while.",
                                    style: TextStyle(color: AppColors.red, fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            TermsConditionWidget(),
                            Gap(20.h),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
