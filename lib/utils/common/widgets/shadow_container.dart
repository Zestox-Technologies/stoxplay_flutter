import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class ShadowContainer extends StatelessWidget {
  final double? height;
  final double width;
  final double borderRadius;
  final Widget? child;
  final Color color;
  final double blurRadius;
  final double spreadRadius;
  final Offset offset;

  const ShadowContainer({
    super.key,
    this.height,
    this.width = double.infinity,
    this.borderRadius = 30.0,
    this.child,
    this.color = Colors.white,
    this.blurRadius = 15.0,
    this.spreadRadius = 1.0,
    this.offset = const Offset(0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue7E.withOpacity(0.3),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            offset: offset,
          ),
        ],
      ),
      child: child,
    );
  }
}
