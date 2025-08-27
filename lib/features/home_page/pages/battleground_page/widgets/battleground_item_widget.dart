import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/pages/battleground_page.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class BattlegroundItemWidget extends StatelessWidget {
  final LiveStock data;

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
                data.prediction.toUpperCase() == "UP"
                    ? AppColors.green.withOpacity(0.6)
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
          border: Border.all(color: data.prediction.toUpperCase() == "UP" ? AppColors.green : AppColors.red),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: _buildContent(data),
      ).paddingSymmetric(horizontal: 3.w, vertical: 3.h),
    ).paddingSymmetric(vertical: 4.h);
  }

  Widget _buildContent(LiveStock data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildTopSection(data), Expanded(child: _buildBottomSection(data).paddingSymmetric(horizontal: 5.w))],
    );
  }

  Widget _buildTopSection(LiveStock data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.black.withOpacity(0.2), width: 0.1),
            borderRadius: BorderRadius.circular(3.r),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SVGImageWidget(imageUrl: data.logoUrl, height: 30.h, width: 30.w),
            ),
          ),
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: data.points.toString(),
                    style: TextStyle(color: AppColors.black, fontSize: 10.sp, fontWeight: FontWeight.w600),
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(0.0, -5.0),
                      child: Text('p', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ).paddingTop(5.h),
            Container(width: 30.w, color: AppColors.black8686, height: 0.5.h).paddingTop(5.h),
            SizedBox(
              width: 12.w,
              height: 9.h,
              child: CustomPaint(
                painter: TrianglePainter(
                  strokeColor: data.prediction.toUpperCase() == "UP" ? AppColors.green : AppColors.red,
                  paintingStyle: PaintingStyle.fill,
                  direction: data.prediction.toUpperCase() == "UP" ? TriangleDirection.up : TriangleDirection.down,
                ),
              ),
            ).paddingTop(5.h),
            Container(width: 30.w, color: AppColors.black8686, height: 0.5.h).paddingTop(5.h),
          ],
        ).paddingRight(5.w),
      ],
    );
  }

  Widget _buildBottomSection(LiveStock data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Gap(5.h),
                TextView(text: data.currentPrice.toString(), fontColor: AppColors.black, fontSize: 10.sp),
                TextView(
                  text: data.netChange.toString(),
                  fontColor: (data.netChange ?? 0) < 0 ? AppColors.red : AppColors.green,
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
                    text:
                        data.role == "CAPTAIN"
                            ? "L"
                            : data.role == "FLEX"
                            ? "CL"
                            : data.role == "VICE_CAPTAIN"
                            ? "VL"
                            : "",
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
            Container(width: double.maxFinite, color: AppColors.black8686, height: 0.5.h),
            Center(
              child: TextView(
                text: data.symbol.toString(),
                overflow: TextOverflow.ellipsis,
                fontColor: AppColors.black,
                fontSize: 8.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
