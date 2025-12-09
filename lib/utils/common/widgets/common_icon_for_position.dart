import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class CommonIconForPosition extends StatelessWidget {
  final IconData? icon;
  final double? iconSize;
  final Color? shadowColor;
  final String? text;
  final void Function()? onTap;
  const CommonIconForPosition({
    super.key,
    this.icon,
    required this.onTap,
    this.text,
    this.iconSize,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30.h,
        width: 30.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? AppColors.blue2E92,
              spreadRadius: 1.0,
              blurRadius: 1.0,
            ),
          ],
          border: Border.all(color: AppColors.blue),
        ),
        child: Center(
          child: TextView(
            text: text!,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            fontColor: AppColors.whiteDFE0,
          ),
        ),
      ),
    );
  }
}
