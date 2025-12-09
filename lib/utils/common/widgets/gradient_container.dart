import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class GradientContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  const GradientContainer({super.key,this.height,required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:height?? MediaQuery.of(context).size.height/2.7.h,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.white70),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.4,0.9],
              colors: [
                AppColors.colorPrimary,
                AppColors.colorSecondary,
              ])),
      child: child!.paddingSymmetric(horizontal: 20.w),
    );
  }
}
