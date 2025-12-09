import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class CommonIcon extends StatelessWidget {
  final IconData? icon;
  final double? iconSize;
  final Color? shadowColor;
  CommonIcon({super.key, this.icon, this.iconSize, this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25.h,
        width: 25.w,
        decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: shadowColor ?? AppColors.blue2E92,
                  spreadRadius: 1.0,
                  blurRadius: 1.0)
            ],
            border: Border.all(color: AppColors.blue2E92)),
        child: Icon(
          icon,
          color: AppColors.blue2E92,
          size: iconSize ?? 15.sp,
        ));
  }
}
