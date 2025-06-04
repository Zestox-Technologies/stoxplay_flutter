import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? width;

  const PrimaryContainer({
    required this.child,
    this.borderColor,
    this.width,
    this.borderWidth,
    this.borderRadius,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?? MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        border: Border.all(
          color: borderColor ?? AppColors.blue7E.withOpacity(0.2),
          width: borderWidth ?? 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color ?? AppColors.blue7E.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0.0,
            offset: Offset(0, 0), // Shadow direction: bottom right
          ),
        ],
      ),
      child: child,
    );
  }
}
