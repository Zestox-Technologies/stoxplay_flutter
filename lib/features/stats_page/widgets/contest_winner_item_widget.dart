import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class ContestWinnerItemWidget extends StatelessWidget {
  const ContestWinnerItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: primaryContainerDecoration,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.lightSplashStrokes, fit: BoxFit.cover),
          ),
          Container(
            margin: EdgeInsets.all(5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.blackC0C0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextView(
                            text: "Rahul Kumar",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          Row(
                            children: [
                              TextView(
                                text: "Entry 500",
                                fontWeight: FontWeight.w700,
                              ),
                              Image.asset(
                                AppAssets.stoxplayCoin,
                                height: 16.h,
                                width: 16.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(height: 1.h, color: AppColors.black9A9A),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              spacing: 2,
                              children: [
                                TextView(
                                  text: Strings.winnings,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  fontColor: AppColors.black46464,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "30,000",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Image.asset(
                                      AppAssets.stoxplayCoin,
                                      height: 16.h,
                                      width: 16.w,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              spacing: 2,
                              children: [
                                TextView(
                                  text: Strings.points,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  fontColor: AppColors.black46464,
                                ),
                                Text(
                                  "1250",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            Column(
                              spacing: 2,
                              children: [
                                TextView(
                                  text: Strings.rank,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  fontColor: AppColors.black46464,
                                ),
                                Text(
                                  "1",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.blackD7D7.withOpacity(0.30),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 5.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.medalIcon,
                                height: 10.h,
                                width: 10.w,
                              ),
                              SizedBox(width: 5.w),
                              TextView(
                                text: "50k",
                                fontColor: AppColors.black6666,
                                fontSize: 12.sp,
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.cupIcon,
                                height: 10.h,
                                width: 10.w,
                              ),
                              SizedBox(width: 5.w),
                              TextView(
                                text: "55%",
                                fontColor: AppColors.black6666,
                                fontSize: 12.sp,
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.mIcon,
                                height: 15.h,
                                width: 15.w,
                              ),
                              SizedBox(width: 5.w),
                              TextView(
                                text: '10',
                                fontColor: AppColors.black6666,
                                fontSize: 12.sp,
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.flexibleIcon,
                                height: 15.h,
                                width: 15.w,
                              ),
                              SizedBox(width: 5.w),
                              TextView(
                                text: Strings.flexible,
                                fontColor: AppColors.black6666,
                                fontSize: 12.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextView(
                        text: "Spots 1000",
                        fontSize: 12.sp,
                        fontColor: AppColors.black6666,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
