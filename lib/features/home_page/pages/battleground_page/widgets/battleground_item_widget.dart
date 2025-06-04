import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/pages/battleground_page.dart';
import 'package:stoxplay/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class BattlegroundItemWidget extends StatelessWidget {
  final Stock data;

  const BattlegroundItemWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102.h,
      width: 88.w,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                data.stockPrediction.isUp
                    ? AppColors.green0CAE.withOpacity(0.6)
                    : AppColors.red.withOpacity(0.6),
            spreadRadius: 3.0,
            blurRadius: 3.0,
            offset: Offset(0, 1),
          ),
        ],
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color:
                data.stockPrediction.isUp ? AppColors.green0CAE : AppColors.red,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.black.withOpacity(0.2),
                      width: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.appIcon,
                      height: 30.h,
                      width: 30.w,
                    ),
                  ),
                ),
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "100.0",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(0.0, -5.0),
                              child: Text(
                                'p',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).paddingTop(5.h),
                    Container(
                      width: 30.w,
                      color: AppColors.black8686,
                      height: 0.5.h,
                    ).paddingTop(5.h),
                    SizedBox(
                      width: 12.w,
                      height: 9.h,
                      child: CustomPaint(
                        painter: TrianglePainter(
                          strokeColor:
                              data.stockPrediction.isUp
                                  ? AppColors.green38EE
                                  : AppColors.red,
                          paintingStyle: PaintingStyle.fill,
                          direction:
                              data.stockPrediction.isUp
                                  ? TriangleDirection.up
                                  : TriangleDirection.down,
                        ),
                      ),
                    ).paddingTop(5.h),
                    Container(
                      width: 30.w,
                      color: AppColors.black8686,
                      height: 0.5.h,
                    ).paddingTop(5.h),
                  ],
                ).paddingRight(5.w),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Gap(5.h),
                          TextView(
                            text: data.stockPrice.toString(),
                            fontColor: AppColors.black,
                            fontSize: 10.sp,
                          ),
                          TextView(
                            text: data.percentage.toString(),
                            fontColor: AppColors.red,
                            fontSize: 8.sp,
                          ),
                        ],
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(8.w),
                            TextView(
                              text: data.stockPosition.toName,
                              fontColor: AppColors.black8686,
                              fontSize: 16.sp,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        color: AppColors.black8686,
                        height: 0.5.h,
                      ),
                      Center(
                        child: TextView(
                          text: data.stockName.toString(),
                          overflow: TextOverflow.ellipsis,
                          fontColor: AppColors.black,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingSymmetric(horizontal: 5.w),
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 3.w, vertical: 3.h),
    ).paddingSymmetric(vertical: 4.h);
  }
}
