import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class HomeScreenAppbar extends StatelessWidget {
  const HomeScreenAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      leading: CircleAvatar(
        child: Image.asset(AppAssets.appIcon).paddingSymmetric(horizontal: 5.w),
      ).paddingTop(15.h).paddingLeft(10.w),
      actions: [
        Icon(
          Icons.notifications_active_outlined,
          color: AppColors.white,
          size: 30.sp,
        ).paddingSymmetric(horizontal: 10.w).paddingTop(20.h),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.appIcon, width: 25.w, height: 25.h),
          SizedBox(width: 10.w),
          TextView(text: Strings.stoxplay, fontSize: 20.sp),
        ],
      ).paddingTop(20.h),
    );
  }
}
