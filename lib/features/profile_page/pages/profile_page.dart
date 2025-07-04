import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/common_bottom_navbar.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void logout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LogoutBS(
          onLogout: () {
            StorageService().setLoggedIn(false);
            StorageService().clearUserToken();
            StorageService().remove(DBKeys.user);
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginPage, (route) => false);
            NavigationState().updateIndex(0);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(top: -50, child: Image.asset(height: 300.h, AppAssets.lightSplashStrokes, fit: BoxFit.fitWidth)),
            SizedBox(
              height: 150.h,
              child: Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: CommonAppbarTitle(iconHeight: 45.h, iconWidth: 45.w, fontSize: 30.sp),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.63.h,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue7E.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Gap(40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextView(text: "Suresh", fontSize: 20.sp, fontWeight: FontWeight.w700),
                            Gap(10.w),
                            Image.asset(AppAssets.editIcon, height: 20.h, width: 20.w, color: AppColors.black3333),
                          ],
                        ),
                        TextView(
                          text: "Suresh@266",
                          fontSize: 18.sp,
                          fontColor: AppColors.black3333,
                          fontWeight: FontWeight.w300,
                        ),
                        Gap(20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(AppAssets.stoxplayCoin, height: 30.h, width: 30.w),
                                Gap(10.w),
                                TextView(text: Strings.appName, fontWeight: FontWeight.w500, fontSize: 18.sp),
                              ],
                            ),
                            TextView(text: "1200", fontWeight: FontWeight.w900),
                          ],
                        ),
                        Gap(25.h),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Gap(25.h),
                            itemCount: profileItems.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (index == 6) {
                                    logout(context);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(profileItems[index].icon, height: 22.h, width: 22.w),
                                        Gap(15.w),
                                        TextView(
                                          text: profileItems[index].title,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18.sp,
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded, size: 12.sp),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -50.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Border color
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.purple661F,
                          width: 4, // Change border width here
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.asset(AppAssets.appIcon, fit: BoxFit.cover, width: 60.h, height: 60.w),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItemModel {
  final String icon;
  final String title;

  ProfileItemModel({required this.icon, required this.title});
}

class LogoutBS extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutBS({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Gap(20.h),
          Text("Are you sure you want to logout?"),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "No",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: AppButton(
                    text: "Yes",
                    onPressed: onLogout,
                    backgroundColor: AppColors.white,
                    textColor: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          Gap(20.h),
        ],
      ),
    );
  }
}
