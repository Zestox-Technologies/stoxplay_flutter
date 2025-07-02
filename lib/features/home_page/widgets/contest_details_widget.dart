import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
  final ContestPrice data;
  bool ignoreOnTap = false;

  ContestDetailsWidget({
    required this.data,
    super.key,
    required this.ignoreOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          ignoreOnTap
              ? null
              : () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.winningsScreen,
                  arguments: data,
                );
              },
      child: Container(
        decoration: primaryContainerDecoration,
        child: Container(
          margin: EdgeInsets.all(5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.blackC0C0),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextView(
                        text: Strings.prizePool,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextView(
                            text: data.prizePool,
                            fontSize: 18.sp,
                            fontColor: AppColors.black,
                          ),
                          Image.asset(
                            AppAssets.stoxplayCoin,
                            height: 22.h,
                            width: 22.w,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.stockSelectionScreen,
                          );
                        },
                        child: Container(
                          width: 75.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: AppColors.purple661F,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.contestPrice.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Image.asset(
                                AppAssets.stoxplayCoin,
                                height: 20.h,
                                width: 20.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(10.h),
                  Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.purple661F,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  Gap(5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextView(
                        text: "1,000 spots left",
                        fontColor: AppColors.black,
                        fontSize: 12.sp,
                      ),
                      TextView(
                        text: "${data.spots} spots",
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
                        SizedBox(width: 20.w),
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
                        SizedBox(width: 20.w),
                        Row(
                          children: [
                            Image.asset(
                              AppAssets.mIcon,
                              height: 10.h,
                              width: 10.w,
                            ),
                            SizedBox(width: 5.w),
                            TextView(
                              text: "10",
                              fontColor: AppColors.black6666,
                              fontSize: 12.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextView(
                      text: "Start @9:00am",
                      fontColor: AppColors.black6666,
                      fontSize: 12.sp,
                    ),
                  ],
                ).paddingSymmetric(horizontal: 14.w, vertical: 5.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
