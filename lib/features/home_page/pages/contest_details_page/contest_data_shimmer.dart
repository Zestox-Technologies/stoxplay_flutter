import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class ContestDetailsShimmer extends StatelessWidget {
  const ContestDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Gap(10.h)),
          SliverToBoxAdapter(child: _summaryCard()),
          SliverToBoxAdapter(child: Gap(16.h)),
          SliverToBoxAdapter(child: _statsGrid()),
          SliverToBoxAdapter(child: Gap(12.h)),
          SliverToBoxAdapter(child: _tabHeader()),
          SliverToBoxAdapter(child: Gap(10.h)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _leaderboardItem(),
              childCount: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return _shimmerContainer(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _rect(width: 160.w, height: 18.h, radius: 6.r),
                _rect(width: 90.w, height: 16.h, radius: 6.r),
              ],
            ),
            Gap(12.h),
            _rect(width: double.infinity, height: 8.h, radius: 6.r),
            Gap(8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _rect(width: 120.w, height: 12.h, radius: 6.r),
                _rect(width: 80.w, height: 12.h, radius: 6.r),
              ],
            ),
            Gap(10.h),
            _rect(width: double.infinity, height: 28.h, radius: 8.r),
          ],
        ),
      ),
    );
  }

  Widget _statsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _statBox()),
              Gap(12.w),
              Expanded(child: _statBox()),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(child: _statBox()),
              Gap(12.w),
              Expanded(child: _statBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox() {
    return _shimmerContainer(
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            _circle(diameter: 40.w),
            Gap(12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rect(width: 80.w, height: 14.h, radius: 6.r),
                  Gap(6.h),
                  _rect(width: 60.w, height: 10.h, radius: 6.r),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(child: _rect(width: double.infinity, height: 36.h, radius: 8.r)),
          Gap(10.w),
          Expanded(child: _rect(width: double.infinity, height: 36.h, radius: 8.r)),
        ],
      ),
    );
  }

  Widget _leaderboardItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: _shimmerContainer(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              _rect(width: 16.w, height: 16.h, radius: 4.r),
              Gap(12.w),
              _circle(diameter: 36.w),
              Gap(12.w),
              Expanded(child: _rect(width: double.infinity, height: 14.h, radius: 6.r)),
              Gap(12.w),
              _rect(width: 48.w, height: 14.h, radius: 6.r),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerContainer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: AppColors.blackD7D7.withOpacity(0.35),
      highlightColor: AppColors.blackD7D7.withOpacity(0.15),
      child: child,
    );
  }

  Widget _rect({required double width, required double height, required double radius}) {
    return Container(width: width, height: height, decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(radius)));
  }

  Widget _circle({required double diameter}) {
    return Container(width: diameter, height: diameter, decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle));
  }
}


