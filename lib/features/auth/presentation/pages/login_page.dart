import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
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

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController mobileNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  ValueNotifier<bool> isCheckboxChecked = ValueNotifier<bool>(false);
  ValueNotifier<int> stepper = ValueNotifier<int>(0);
  TextEditingController referralIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (stepper.value == 1) {
          stepper.value--;
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: stepper,
            builder: (context, step, _) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Image.asset(
                                  AppAssets.lightSplashStrokes,
                                  fit:
                                      BoxFit
                                          .cover, // Ensure it covers the whole area
                                ),
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
                          Gap(30.h),
                          TextView(
                            text: Strings.login,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          TextView(
                            text:
                                stepper.value == 0
                                    ? Strings.weWillSendYouOTP
                                    : Strings.pleaseSignInToExistingAccount,
                            fontColor: AppColors.black39,
                            fontWeight: FontWeight.w300,
                          ),
                          SizedBox(height: 40.h),
                          ShadowContainer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 28.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  stepper.value == 0
                                      ? Column(
                                        children: [
                                          CommonTextfield(
                                            controller: mobileNoController,
                                            title:
                                                Strings.mobileNumber
                                                    .toUpperCase(),
                                            prefixText: "+91  ",
                                            maxLength: 10,
                                            keyboardType: TextInputType.number,
                                          ),
                                          Gap(10.h),
                                          CommonTextfield(
                                            controller: referralIdController,
                                            hintText:
                                                "Only required for new users",
                                            title: Strings.referralId,
                                          ),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scale: 0.8,
                                                child: ValueListenableBuilder(
                                                  valueListenable:
                                                      isCheckboxChecked,
                                                  builder: (context, check, _) {
                                                    return Checkbox(
                                                      value: check,
                                                      checkColor:
                                                          AppColors.white,
                                                      activeColor:
                                                          AppColors.blue3200,
                                                      onChanged: (value) {
                                                        isCheckboxChecked
                                                            .value = value!;
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                        side: BorderSide(
                                                          color:
                                                              AppColors.black40,
                                                        ),
                                                      ),
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: TextView(
                                                  text:
                                                      Strings
                                                          .iCertifyThatIAmAbove18Years,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                      : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextView(text: Strings.code),
                                              Row(
                                                children: [
                                                  TextView(
                                                    text: Strings.resendIn,
                                                    fontWeight: FontWeight.w600,
                                                    textDecoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                  TextView(text: "59 sec"),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Gap(5.h),
                                          SizedBox(
                                            height: 45.h,
                                            child: Pinput(
                                              controller: otpController,
                                              separatorBuilder:
                                                  (index) =>
                                                      SizedBox(width: 30),
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            ),
                                          ),
                                          Gap(20.h),
                                        ],
                                      ),
                                  AppButton(
                                    text: Strings.verifyOTP,
                                    onPressed: () {
                                      if (stepper.value == 0) {
                                        // if (mobileNoController.text.length !=
                                        //     10) {
                                        //   showSnackBar(
                                        //     context: context,
                                        //     message:
                                        //         Strings
                                        //             .pleaseEnterValidMobileNumber,
                                        //   );
                                        // } else if (!isCheckboxChecked.value) {
                                        //   showSnackBar(
                                        //     context: context,
                                        //     message:
                                        //         Strings
                                        //             .pleaseCheckTermsAndConditions,
                                        //   );
                                        // } else {
                                        stepper.value = 1;
                                        // }
                                      } else {
                                        // if (otpController.text.length == 4) {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.signUpPage,
                                        );
                                        // } else {
                                        //   showSnackBar(
                                        //     context: context,
                                        //     message:
                                        //         Strings.pleaseEnter4DigitOTP,
                                        //   );
                                        // }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TermsConditionWidget(),
                    Gap(20.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
