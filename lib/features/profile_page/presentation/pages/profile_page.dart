import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/features/profile_page/domain/profile_usecase.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';
import '../profile_cubit.dart';
import 'package:stoxplay/core/di/service_locator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileCubit profileCubit;

  @override
  void initState() {
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    profileCubit.fetchProfile();
    super.initState();
  }

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
    return BlocProvider(
      create: (_) => profileCubit,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.profile != null) {
            final profile = state.profile;
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundImage: AssetImage(AppAssets.profileIcon), // Replace with network if available
                            ),
                            Gap(16.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(
                                  text: "${profile?.firstName} ${profile?.lastName}",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                TextView(
                                  text: profile?.username ?? '',
                                  fontSize: 15.sp,
                                  fontColor: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.purple661F,
                          borderRadius: BorderRadius.circular(10.r),
                          image: DecorationImage(
                            image: AssetImage(AppAssets.splashStrokes),
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Gap(18.w),
                            Image.asset(AppAssets.stoxplayCoin, height: 40.h, width: 40.w),
                            Gap(5.w),
                            Text(
                              "${profile?.walletBalance}",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                            Gap(6.w),
                            Text(
                              "coins",
                              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            Gap(18.w),
                          ],
                        ),
                      ),
                    ),
                    Gap(18.h),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        children: [
                          _SectionHeader(title: "Account Overview"),
                          _ProfileListTile(icon: "🎮", title: "Playing History", onTap: () {}),
                          _ProfileListTile(icon: "👤", title: "Personal Info", onTap: () {}),
                          _ProfileListTile(icon: "🔔", title: "Notification", onTap: () {}),
                          _SectionHeader(title: "Support & Help"),
                          _ProfileListTile(icon: "🎮", title: "How to Play", onTap: () {}),
                          _ProfileListTile(icon: "❓", title: "Help Center", onTap: () {}),
                          _SectionHeader(title: "Legal"),
                          _ProfileListTile(icon: "📄", title: "Playing History", onTap: () {}),
                          _ProfileListTile(icon: "👤", title: "T&C of Technologies Pvt Ltd", onTap: () {}),
                          _ProfileListTile(
                            icon: "⏻",
                            title: "Logout",
                            onTap: () {
                              logout(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 18.h, bottom: 8.h),
      child: Text(title, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 15.sp)),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileListTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Container(
        height: 30.h,
        width: 30.w,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.blackD3D3, width: 0.84)),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            icon,
            style: TextStyle(fontSize: 20.sp), // Increase size to fill circle
          ),
        ),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: Colors.grey.shade400),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
      minLeadingWidth: 0,
      horizontalTitleGap: 12.w,
    );
  }
}

class ProfileItemModel {
  final String icon;
  final String title;
  final VoidCallback? onTap;

  ProfileItemModel({required this.icon, required this.title, this.onTap});
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
