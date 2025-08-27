import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';

class StockSelectionShimmer extends StatelessWidget {
  const StockSelectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Image.asset(
              AppAssets.lightSplashStrokes,
              height: 250.h,
            ),
          ),
          SafeArea(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  _buildHeaderShimmer(),
                  Gap(10.h),
                  _buildProgressShimmer(),
                  Gap(18.h),
                  _buildTableHeaderShimmer(),
                  Gap(5.h),
                  Expanded(
                    child: _buildStockListShimmer(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          // Back button shimmer
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          Gap(10.h),
          // Title shimmer
          Container(
            width: 200.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Gap(10.h),
          // Subtitle row shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  width: 100.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressShimmer() {
    return Center(
      child: SizedBox(
        height: 12.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            11,
            (index) => Container(
              width: 23.w,
              height: 12.h,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeaderShimmer() {
    return Container(
      width: double.infinity,
      height: 15.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }

  Widget _buildStockListShimmer() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      separatorBuilder: (context, index) => Gap(8.h),
      itemCount: 10, // Show 10 shimmer items
      itemBuilder: (context, index) => _buildStockItemShimmer(),
    );
  }

  Widget _buildStockItemShimmer() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Stock icon
          Container(
            width: 40.w,
            height: 40.h,
            margin: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          // Stock info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Gap(4.h),
                Container(
                  width: 80.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.h,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              Container(
                width: 30.w,
                height: 30.h,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 