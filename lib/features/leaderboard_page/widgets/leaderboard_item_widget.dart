import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class LeaderboardItemWidget extends StatelessWidget {
  const LeaderboardItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue7E.withOpacity(0.3),
            offset: const Offset(0, 0),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: AppColors.blue7E.withOpacity(0.5)),
      ),
      child: Container(
        margin: EdgeInsets.all(5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.blackC0C0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppAssets.lightCelebrationImage),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView(
                      text: 'Bank Wars',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    TextView(
                      text: Strings.topWinners,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    TextView(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      text: DateFormat('dd-MM-yyyy').format(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day - 1,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(3.h),
                Container(
                  height: 0.2.h,
                  width: double.maxFinite,
                  color: AppColors.black,
                ),
                Gap(10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index) => LeaderboardItem()),
                ),
              ],
            ).paddingSymmetric(horizontal: 14.w, vertical: 5.h),
          ],
        ),
      ),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2), // Border width
          decoration: BoxDecoration(
            color: Colors.white, // Border color
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.blue7E.withOpacity(0.5),
              // Change border color here
              width: 1, // Change border width here
            ),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                'assets/images/bank_wars.png',
                height: 40, // adjust if needed
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 85.w,
          child: TextView(
            text: "Bhavesh Parmar",
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextView(
          text: "P - 280.1",
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
        ),
        Row(
          children: [
            Image.asset(AppAssets.stoxplayCoin, height: 15.h, width: 15.w),
            TextView(
              text: "10,50,000",
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ],
        ),
        Gap(5.h),
      ],
    );
  }
}
