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
          _shimmerContainer(
            width: MediaQuery.of(context).size.width.w,
            height: 60.h,
            borderRadius: BorderRadius.circular(8.r),
          ),
          Gap(10.h),
          Container(width: MediaQuery.of(context).size.width.w, height: 1, color: AppColors.black.withOpacity(0.1)),
          Gap(5.h),
          Row(
            children: [
              _shimmerContainer(width: 15.w, height: 15.h),
              Gap(5.w),
              _shimmerContainer(width: 50.w, height: 12.h),
            ],
          ),
          Gap(5.h),
          Row(
            children: [
              _shimmerContainer(width: 15.w, height: 15.h),
              Gap(5.w),
              _shimmerContainer(width: 50.w, height: 12.h),
            ],
          ),
          Gap(10.h),
          Center(child: _shimmerContainer(width: 100.w, height: 35.h, borderRadius: BorderRadius.circular(999.r))),
        ],
      ).paddingSymmetric(horizontal: 14.w),
    );
  }
}

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => const ContestShimmerWidget(),
          ),
        ],
      ),
    );
  }
}

class ContestDetailsCardShimmer extends StatelessWidget {
  const ContestDetailsCardShimmer({super.key});

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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(color: Colors.purple.withOpacity(0.08), blurRadius: 16, spreadRadius: 2, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerContainer(width: 80, height: 18, borderRadius: BorderRadius.circular(4)),
              _shimmerContainer(width: 60, height: 16, borderRadius: BorderRadius.circular(8)),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _shimmerContainer(width: 50, height: 24, borderRadius: BorderRadius.circular(6)),
                  SizedBox(width: 8),
                  _shimmerContainer(width: 20, height: 20, borderRadius: BorderRadius.circular(99)),
                ],
              ),
              _shimmerContainer(width: 60, height: 28, borderRadius: BorderRadius.circular(10)),
            ],
          ),
          SizedBox(height: 12),
          _shimmerContainer(width: double.infinity, height: 8, borderRadius: BorderRadius.circular(2)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerContainer(width: 80, height: 14, borderRadius: BorderRadius.circular(4)),
              _shimmerContainer(width: 60, height: 14, borderRadius: BorderRadius.circular(4)),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _shimmerContainer(width: 20, height: 16, borderRadius: BorderRadius.circular(4)),
                    SizedBox(width: 6),
                    _shimmerContainer(width: 30, height: 12, borderRadius: BorderRadius.circular(4)),
                    SizedBox(width: 16),
                    _shimmerContainer(width: 20, height: 16, borderRadius: BorderRadius.circular(4)),
                    SizedBox(width: 6),
                    _shimmerContainer(width: 30, height: 12, borderRadius: BorderRadius.circular(4)),
                    SizedBox(width: 16),
                    _shimmerContainer(width: 20, height: 16, borderRadius: BorderRadius.circular(4)),
                    SizedBox(width: 6),
                    _shimmerContainer(width: 30, height: 12, borderRadius: BorderRadius.circular(4)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [_shimmerContainer(width: 80, height: 12, borderRadius: BorderRadius.circular(4))],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
