import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';

class LiveItemWidget extends StatelessWidget {
  final StatsDataModel data;

  const LiveItemWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.completedDetailsScreen, arguments: data);
      },
      child: Container(
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
                  _buildIcon(),
                  Gap(12.w),

                  // Bank Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                          text: data.contest?.sectorName ?? '',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.black,
                        ),
                        Gap(2.h),
                        TextView(
                          text: data.contest?.name ?? '',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.purple5A2F,
                        ),
                      ],
                    ),
                  ),

                  // Prize and Live Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppAssets.cupIcon, height: 16.h, width: 16.w),
                          Gap(4.w),
                          TextView(
                            text: "Prize: ",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.black,
                          ),
                          TextView(
                            text: "₹${formatMaxWinIntl(data.contest?.prizePool ?? 0)}",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.purple5A2F,
                          ),
                        ],
                      ),
                      Gap(4.h),
                      TextView(text: "Live", fontSize: 12.sp, fontWeight: FontWeight.w600, fontColor: AppColors.red),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Points: ${data.points?.toStringAsFixed(2) ?? 0.00}"),
                  Text("Rank: ${data.rank ?? 0}")
                ],
              ),
            ),

            // Bottom Section - Stats Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.whiteF9F9,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.r), bottomRight: Radius.circular(16.r)),
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      Image.asset(AppAssets.firstPrizeIcon, height: 14.h, width: 14.w),
                      Gap(4.w),
                      TextView(
                        text: data.contest?.firstPrize.toString() ?? '',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.black,
                      ),
                    ],
                  ),
                  Gap(16.w),

                  // Trophy with 50%
                  Row(
                    children: [
                      Image.asset(AppAssets.championIcon, height: 14.h, width: 14.w),
                      Gap(4.w),
                      TextView(
                        text: "${data.contest?.winningPercentage}%",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.black,
                      ),
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

                  // View Action
                  _buildViewAction(context, data),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildViewAction(BuildContext context, StatsDataModel data) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // 👈 expands tap area to full bounds
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.battleGroundScreen, arguments: data.id ?? '');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.visibility_outlined, size: 16.sp, color: AppColors.black6666),
          Gap(4.w),
          TextView(text: "View", fontSize: 12.sp, fontWeight: FontWeight.w500, fontColor: AppColors.black6666),
        ],
      ),
    );
  }
}
