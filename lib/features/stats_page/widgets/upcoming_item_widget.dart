import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/utils/common/widgets/progress_bar_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart' show Strings;

class UpcomingItemWidget extends StatelessWidget {
  const UpcomingItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.blackD7D7, width: 1),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Top Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // HDFC Bank Logo
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.red, width: 2)),
                  child: Image.asset(AppAssets.appIcon),
                ),
                Gap(12.w),
                // Bank Name and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: "Bank wars",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.black,
                      ),
                      Gap(2.h),
                      TextView(
                        text: "Bank wars",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.purple5A2F,
                      ),
                    ],
                  ),
                ),

                // Entry Fee and Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextView(
                      text: "Entry Fee ₹500",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.purple5A2F,
                    ),
                    Gap(2.h),
                    TextView(
                      text: "Time Left: 09:10:59",
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.black9999,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1.h, color: AppColors.blackD7D7, margin: EdgeInsets.symmetric(horizontal: 16.w)),

          // Middle Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(
                  text: "Upcoming",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontColor: AppColors.purple5A2F,
                ),
                Row(
                  children: [
                    Image.asset(AppAssets.cupIcon, height: 16.h, width: 16.w),
                    Gap(4.w),
                    TextView(
                      text: "Prize: ₹8,10,000",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.black9999,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          // Container(height: 1.h, color: AppColors.blackD7D7, margin: EdgeInsets.symmetric(horizontal: 16.w)),

          // Progress Bar Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
            child: Column(
              children: [
                // Progress Bar
                ProgressBarWidget(value: 1000, total: 5000),
                Gap(8.h),

                // Team and Spots
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView(
                      text: "Team-1",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.purple5A2F,
                    ),
                    TextView(
                      text: "2000 Spots Remaining",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.black9999,
                    ),
                  ],
                ),
                Gap(8.h),

                // Stats Row
                Row(
                  children: [
                    // Medal with 30k
                    Row(
                      children: [
                        Image.asset(AppAssets.firstPrizeIcon, height: 14.h, width: 14.w),
                        Gap(4.w),
                        TextView(text: "30k", fontSize: 12.sp, fontWeight: FontWeight.w600, fontColor: AppColors.black),
                      ],
                    ),
                    Gap(16.w),

                    // Trophy with 50%
                    Row(
                      children: [
                        Image.asset(AppAssets.championIcon, height: 14.h, width: 14.w),
                        Gap(4.w),
                        TextView(text: "50%", fontSize: 12.sp, fontWeight: FontWeight.w600, fontColor: AppColors.black),
                      ],
                    ),
                    Gap(16.w),

                    // Rupee with Flexible
                    Row(
                      children: [
                        Image.asset(AppAssets.flexibleIcon, height: 14.h, width: 14.w),
                        Gap(4.w),
                        TextView(
                          text: "Flexible",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: AppColors.black,
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Action Buttons
                    Row(
                      children: [
                        // View Button
                        Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 16.sp, color: AppColors.black6666),
                            Gap(4.w),
                            TextView(
                              text: "View",
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.black6666,
                            ),
                          ],
                        ),
                        Gap(10.w),

                        // Edit Button
                        Row(
                          children: [
                            Image.asset(AppAssets.editIcon, height: 16.h, width: 16.w, color: AppColors.black6666),
                            Gap(4.w),
                            TextView(
                              text: "Edit",
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.black6666,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
