import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/progress_bar_widget.dart';
import 'package:stoxplay/utils/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class ContestDetailsWidget extends StatelessWidget {
  final ContestModel data;
  bool ignoreOnTap = false;

  ContestDetailsWidget({required this.data, super.key, required this.ignoreOnTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          ignoreOnTap
              ? null
              : () {
                Navigator.pushNamed(context, AppRoutes.winningsScreen, arguments: data);
              },
      child: Container(
        decoration: boxDecorationForContestWidget,
        child: Container(
          margin: EdgeInsets.all(5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.blackC0C0),
          ),
          child: Stack(
            children: [
              // Positioned.fill(child: Image.asset(AppAssets.lightSplashStrokes)),
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextView(text: Strings.prizePool, fontSize: 16.sp, fontWeight: FontWeight.w500),
                          Row(
                            children: [
                              Image.asset(AppAssets.flexibleIcon, height: 15.h, width: 15.w),
                              SizedBox(width: 5.w),
                              TextView(text: Strings.flexible, fontColor: AppColors.black6666, fontSize: 12.sp),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextView(
                                text: (data.totalCollection ?? 0).toString(),
                                fontSize: 18.sp,
                                fontColor: AppColors.black,
                              ),
                              Gap(5.w),
                              Image.asset(AppAssets.stoxplayCoin, height: 20.h, width: 20.w),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.stockSelectionScreen,
                                arguments: {'contestId': data.id.toString(), 'price': data.entryFee.toString()},
                              );
                            },
                            child: Container(
                              width: 75.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.entryFee.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Gap(5.w),
                                  Image.asset(AppAssets.stoxplayCoin, height: 15.h, width: 15.w),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(10.h),
                      ProgressBarWidget(
                        value: data.spotsFilled?.toDouble() ?? 0.0,
                        total: data.totalSpots?.toDouble() ?? 0.0,
                      ),
                      Gap(5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextView(text: "${data.spotsLeft} spots left", fontColor: AppColors.black, fontSize: 12.sp),
                          TextView(
                            text: "${data.totalSpots} spots",
                            fontColor: AppColors.black,
                            lineHeight: 1.5,
                            letterSpacing: 0,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 14.w, vertical: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.blackD7D7.withOpacity(0.55),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Image.asset(AppAssets.firstPrizeIcon, height: 10.h, width: 10.w),
                                SizedBox(width: 5.w),
                                TextView(text: "50k", fontColor: AppColors.black6666, fontSize: 12.sp),
                              ],
                            ),
                            SizedBox(width: 20.w),
                            Row(
                              children: [
                                Image.asset(AppAssets.championIcon, height: 10.h, width: 10.w),
                                SizedBox(width: 5.w),
                                TextView(
                                  text: "${data.winningChancePercentage.toString()}%",
                                  fontColor: AppColors.black6666,
                                  fontSize: 12.sp,
                                ),
                              ],
                            ),
                            SizedBox(width: 20.w),
                            Row(
                              children: [
                                Image.asset(AppAssets.mIcon, color: AppColors.orangeCCCC, height: 10.h, width: 10.w),
                                SizedBox(width: 5.w),
                                TextView(
                                  text: data.teamsPerUser.toString(),
                                  fontColor: AppColors.black6666,
                                  fontSize: 12.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextView(
                          text: "Start @${DateFormat('hh:mm a').format(data.startTime!)}",
                          fontColor: AppColors.black6666,
                          fontSize: 12.sp,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 14.w, vertical: 5.h),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
