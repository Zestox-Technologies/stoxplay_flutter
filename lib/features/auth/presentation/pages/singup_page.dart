import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/auth/data/models/auth_params_model.dart';
import 'package:stoxplay/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:stoxplay/features/auth/presentation/cubit/auth_state.dart';
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

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthParamsModel authParams = ModalRoute.of(context)!.settings.arguments as AuthParamsModel;
    return BlocProvider(
      create: (_) => AuthCubit(authRepository: sl()),
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          return Scaffold(
            body: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.completeSignUpStatus.isSuccess) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.mainPage, (route) => false);
                }
                if (state.completeSignUpStatus.isFailed) {
                  showSnackBar(context: context, message: state.errorMessage ?? 'Signup failed');
                }
              },
              child: SingleChildScrollView(
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
                                    fit: BoxFit.cover, // Ensure it covers the whole area
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
                            TextView(text: Strings.signUp, fontSize: 40.sp, fontWeight: FontWeight.w700),
                            TextView(
                              text: Strings.pleaseSignUpToGetStarted,
                              fontColor: AppColors.black39,
                              fontWeight: FontWeight.w300,
                            ),
                            Gap(20.h),
                            ShadowContainer(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
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
                                          controller: userIdController,
                                          hintText: Strings.userName,
                                          title: Strings.userName.toUpperCase(),
                                        ),
                                      ],
                                    ),
                                    Gap(20.h),
                                    BlocBuilder<AuthCubit, AuthState>(
                                      builder: (context, state) {
                                        return AppButton(
                                          text: Strings.signUp.toUpperCase(),
                                          isLoading: state.completeSignUpStatus.isLoading,
                                          onPressed: () async {
                                            if (nameController.text.trim().isEmpty) {
                                              showSnackBar(context: context, message: 'Please enter your name');
                                              return;
                                            }
                                            if (userIdController.text.trim().isEmpty) {
                                              showSnackBar(context: context, message: 'Please enter a username');
                                              return;
                                            }
                                            
                                            await authCubit.completeSignUp(
                                              phoneNumber: authParams.phoneNumber.toString(),
                                              referCode: authParams.referralCode.toString(),
                                              userName: userIdController.text.trim(),
                                              firstName: nameController.text.split(' ').first,
                                              lastName: nameController.text.split(' ').last,
                                            );
                                          },
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
            ),
          );
        },
      ),
    );
  }
}
