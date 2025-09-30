import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class CompletedItemWidget extends StatelessWidget {
  final StatsDataModel data;

  const CompletedItemWidget({required this.data, super.key});

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
            // Top Section - Event Header
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  // HDFC Bank Logo
                  Container(
                    width: 50.w,
                    height: 50.h,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(color: AppColors.blackD7D7, width: 1),
                    ),
                    child: ClipOval(child: CachedImageWidget(imageUrl: data.contest?.sectorLogo ?? '')),
                  ),
                  Gap(12.w),

                  // Event Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                          text: data.name ?? '',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.black,
                        ),
                        TextView(
                          text: data.contest?.name ?? '',
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
            Container(height: 1.h, color: AppColors.blackD7D7, margin: EdgeInsets.symmetric(horizontal: 16.w)),

            // Middle Section - Date and Time
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: 'Points: ${data.points != null ? data.points.toStringAsFixed(2) : '0.0'}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  TextView(text: 'Rank: ${data.rank.toString()}', fontSize: 12.sp, fontWeight: FontWeight.w500),
                  TextView(
                    text: "Time: 4:00 PM",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.black,
                  ),
                ],
              ),
            ),

            // Divider
            Container(height: 1.h, color: AppColors.blackD7D7, margin: EdgeInsets.symmetric(horizontal: 16.w)),

            // Bottom Section - Participation Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: Strings.indianStockMarketChampionship,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.black9999,
                  ),
                  Row(
                    children: [
                      TextView(
                        text: "Won ${data.prize.toString()}",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.black9999,
                      ),
                      Gap(2.w),
                      Image.asset(AppAssets.stoxplayCoin, height: 12.h, width: 12.w),
                    ],
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
