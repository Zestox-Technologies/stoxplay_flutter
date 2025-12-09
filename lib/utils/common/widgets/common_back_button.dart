
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class CommonBackButton extends StatelessWidget {
  final void Function()? onTap;
  const CommonBackButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(color: AppColors.white)),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.black,
          size: 15.sp,
        ),
      ),
    );
  }
}
