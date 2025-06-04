import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_strings.dart' show Strings;

class CompletedItemWidget extends StatelessWidget {
  const CompletedItemWidget({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: Strings.indianStockMarketChampionship,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
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
                          TextView(
                            text: Strings.bankWars,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                          SizedBox(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextView(
                                text: "21 May",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                lineHeight: 0,
                              ),
                              TextView(
                                text: "4:15 PM",
                                fontSize: 14.sp,
                                lineHeight: 0,
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.black6767,
                              ),
                            ],
                          ),
                          SizedBox(),
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
                          TextView(
                            text: "1  Team",
                            fontColor: AppColors.black6666,
                            fontSize: 10.sp,
                          ),
                          SizedBox(width: 20.w),
                          TextView(
                            text: "1  Contest",
                            fontColor: AppColors.black6666,
                            fontSize: 10.sp,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: AppColors.black46464,
                        size: 20.sp,
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
