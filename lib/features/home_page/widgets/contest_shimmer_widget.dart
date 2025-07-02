import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/utils/common/widgets/primary_container.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class ContestShimmerWidget extends StatelessWidget {
  const ContestShimmerWidget({super.key});

  Widget _shimmerContainer({double? width, double? height, BorderRadius? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius ?? BorderRadius.circular(4)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10.h),
          _shimmerContainer(width: 200.w, height: 16.h),
          Gap(10.h),
          Container(width: MediaQuery.of(context).size.width.w, height: 1, color: AppColors.black.withOpacity(0.1)),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _shimmerContainer(width: 60.w, height: 60.h, borderRadius: BorderRadius.circular(8.r)),
                  SizedBox(width: 10.w),
                  _shimmerContainer(width: 120.w, height: 20.h),
                ],
              ),
              _shimmerContainer(width: 65.w, height: 25.h, borderRadius: BorderRadius.circular(5.r)),
            ],
          ),
          Gap(10.h),
          Container(width: MediaQuery.of(context).size.width.w, height: 1, color: AppColors.black.withOpacity(0.1)),
          Gap(5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _shimmerContainer(width: 10.w, height: 10.h, borderRadius: BorderRadius.circular(2.r)),
                  Gap(5.w),
                  _shimmerContainer(width: 80.w, height: 12.h),
                ],
              ),
              _shimmerContainer(width: 15.w, height: 15.h),
            ],
          ),
          Gap(10.h),
        ],
      ).paddingSymmetric(horizontal: 14.w),
    );
  }
}
