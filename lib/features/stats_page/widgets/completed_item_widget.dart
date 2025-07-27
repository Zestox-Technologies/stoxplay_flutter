import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class CompletedItemWidget extends StatelessWidget {
  const CompletedItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.blackD7D7, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section - Event Header
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                // HDFC Bank Logo
                _buildIcon(),
                Gap(12.w),

                // Event Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: "Stock Market Championship",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.black,
                      ),
                      TextView(
                        text: "Bank wars",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.purple5A2F,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 1.h,
            color: AppColors.blackD7D7,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          
          // Middle Section - Date and Time
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextView(
                    text: "Date: 21 March,2025",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.black,
                  ),
                ),
                TextView(
                  text: "Time: 4:15 PM",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.black,
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 1.h,
            color: AppColors.blackD7D7,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          
          // Bottom Section - Participation Details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                TextView(
                  text: "1-Team",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.black9999,
                ),
                Gap(16.w),
                TextView(
                  text: "1-Contest",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.black9999,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 50.w,
      height: 50.h,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.blackD7D7, width: 1),
      ),
      child: Image.asset(AppAssets.appIcon),
    );
  }
}
