import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class CommonStoxplayIcon extends StatelessWidget {
  final double iconWidth;
  final double iconHeight;
  final double shadowWidth;
  final double shadowHeight;

  const CommonStoxplayIcon({
    super.key,
    this.iconWidth = 90.0,
    this.iconHeight = 100.0,
    this.shadowWidth = 180.0,
    this.shadowHeight = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.appIcon,
          width: iconWidth.w,
          height: iconHeight.h,
        ),
        Image.asset(
          AppAssets.iconShadow,
          width: shadowWidth.w,
          height: shadowHeight.h,
        ),
      ],
    );
  }
}

class CommonStoxplayText extends StatelessWidget {
  final double fontSize;
  final double letterSpacing;
  final double shadowOffsetY;
  final double shadowBlurRadius;

   const CommonStoxplayText({
    super.key,
    this.fontSize = 50.0,
    this.letterSpacing = 0.0,
    this.shadowOffsetY = 5.0,
    this.shadowBlurRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      Strings.stoxplay,
      style: TextStyle(
        color: AppColors.blue3200,
        fontSize: fontSize.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(0, shadowOffsetY),
            blurRadius: shadowBlurRadius,
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
    );
  }
}
