import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
                          Flexible(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextView(
                                      text: Strings.bankWars,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    TextView(
                                      text: Strings.team1,
                                      fontSize: 10.sp,
                                      fontColor: AppColors.black,
                                    ),
                                    SizedBox(),
                                  ],
                                ),
                                Container(
                                  height: 1.h,
                                  color: AppColors.black9A9A,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                AppAssets.championIcon,
                                height: 14.h,
                                width: 14.w,
                              ),
                              SizedBox(width: 5.w),
                              TextView(
                                text: "8,10,000",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                lineHeight: 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.bankWars,
                            height: 60.h,
                            width: 60.w,
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      TextView(text: "09:10:59", fontSize: 10.sp),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.stockSelectionScreen,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.purple661F,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "500",
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 13.sp,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.purple661F,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                  TextView(
                                    text: "2000 spots left",
                                    fontSize: 10.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.editIcon,
                            height: 15.h,
                            width: 15.w,
                            color: AppColors.black46464,
                          ),
                        ],
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
