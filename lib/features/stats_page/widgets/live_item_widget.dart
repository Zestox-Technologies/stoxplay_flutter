import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart' show Strings;

class LiveItemWidget extends StatelessWidget {
  const LiveItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: primaryContainerDecoration,
          child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView(
                        text: Strings.bankWars,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(height: 1.h, color: AppColors.black9A9A),
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
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.liveIcon,
                                height: 16.h,
                                width: 16.w,
                              ),
                              SizedBox(width: 5.w),
                              TextView(text: "Live", fontSize: 16.sp),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.championIcon,
                                height: 14.h,
                                width: 14.w,
                              ),
                              SizedBox(width: 5.w),
                              TextView(
                                text: "8,10,000",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
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
        ),
        Positioned.fill(
          child: Image.asset(
            AppAssets.lightSplashStrokes,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}
