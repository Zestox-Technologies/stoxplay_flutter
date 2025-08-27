import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileCubit profileCubit;
  late final VoidCallback navListener;

  @override
  void initState() {
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    profileCubit.fetchProfile(); // Fetch profile when page loads
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: AppColors.primaryPurple,
          strokeWidth: 2,
          onRefresh: () async {
            await profileCubit.fetchProfile(); // Refresh profile data
          },
          child: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state.apiStatus.isLoading) {
                    return Center(child: ProfileShimmer());
                  } else if (state.profileModel != null) {
                    final profile = state.profileModel;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                BlocSelector<ProfileCubit, ProfileState, String?>(
                                  bloc: profileCubit,
                                  selector: (state) => state.profileModel?.profilePictureUrl,
                                  builder: (context, picUrl) {
                                    final hasPic = (picUrl != null && picUrl.isNotEmpty);
                                    if (picUrl != null && picUrl.toLowerCase().endsWith('.svg')) {
                                      return CircleAvatar(
                                        radius: 32.r,
                                        backgroundColor: AppColors.white,
                                        child: ClipOval(
                                          child: SVGImageWidget(
                                            imageUrl: picUrl,
                                            errorWidget: Image.asset(AppAssets.profileIcon),
                                          ),
                                        ),
                                      );
                                    }
                                    return CircleAvatar(
                                      radius: 32.r,
                                      backgroundImage: hasPic ? NetworkImage(picUrl) : null,
                                      child: hasPic ? null : Icon(Icons.person, size: 50.h),
                                    );
                                  },
                                ),
                                Gap(16.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextView(
                                      text: "${profile?.firstName}",
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    TextView(
                                      text: profile?.username ?? '',
                                      fontSize: 12.sp,
                                      fontColor: Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Gap(18.h),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple,
                              borderRadius: BorderRadius.circular(15.r),
                              image: DecorationImage(
                                image: AssetImage(AppAssets.splashStrokes),
                                fit: BoxFit.cover,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Gap(15.w),
                                Image.asset(AppAssets.stoxplayCoin, height: 30.h, width: 30.w),
                                Gap(8.w),
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
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  children: [
                    _SectionHeader(title: "Account Overview"),
                    _ProfileListTile(
                      icon: "🎮",
                      title: "Playing History",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.playingHistoryPage);
                      },
                    ),
                    _ProfileListTile(
                      icon: "👤",
                      title: "Personal Info",
                      onTap: () async {
                        await Navigator.pushNamed(context, AppRoutes.personalInfoPage);
                        profileCubit.fetchProfile();
                      },
                    ),
                    _ProfileListTile(icon: "🔔", title: "Notification", onTap: () {}),
                    _SectionHeader(title: "Support & Help"),
                    _ProfileListTile(icon: "🎮", title: "How to Play", onTap: () {}),
                    _ProfileListTile(icon: "❓", title: "Help Center", onTap: () {}),
                    _SectionHeader(title: "Legal"),
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

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  Widget shimmerItem({required double width, required double height, double radius = 4}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(radius.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Profile Card
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
                /// Avatar
                shimmerItem(width: 40.r, height: 40.r, radius: 40),

                SizedBox(width: 16.w),

                /// Name and Username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerItem(width: 140.w, height: 18.h),
                    SizedBox(height: 8.h),
                    shimmerItem(width: 100.w, height: 14.h),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10.h),

        /// Wallet Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            decoration: BoxDecoration(color: AppColors.whiteF9F9, borderRadius: BorderRadius.circular(15.r)),
            child: Row(
              children: [
                /// Coin Icon
                shimmerItem(width: MediaQuery.of(context).size.width.w - 80, height: 40.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
