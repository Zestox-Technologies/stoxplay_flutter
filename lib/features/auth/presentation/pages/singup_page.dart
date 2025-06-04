import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            AppAssets.lightSplashStrokes,
                            fit:
                                BoxFit.cover, // Ensure it covers the whole area
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
                    TextView(
                      text: Strings.signUp,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    TextView(
                      text: Strings.pleaseSignUpToGetStarted,
                      fontColor: AppColors.black39,
                      fontWeight: FontWeight.w300,
                    ),
                    Gap(20.h),
                    ShadowContainer(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 25.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CommonTextfield(
                                  controller: nameController,
                                  isCompulsory: true,
                                  hintText: Strings.stoxplay,
                                  title: Strings.name.toUpperCase(),
                                ),
                                Gap(10.h),
                                CommonTextfield(
                                  controller: emailController,
                                  hintText: Strings.emailExample,
                                  title: Strings.email.toUpperCase(),
                                ),
                              ],
                            ),
                            Gap(20.h),
                            AppButton(
                              text: Strings.signIn.toUpperCase(),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.mainPage,
                                  (route) => false,
                                );
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
        ),
      ),
    );
  }
}
