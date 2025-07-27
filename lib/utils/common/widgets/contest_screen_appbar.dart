import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';


class ContestScreenAppbar extends StatelessWidget {
  final Widget child;
  const ContestScreenAppbar({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        border: Border.all(color: AppColors.whiteF6CC),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r)),
      ),
      child: child,
    );
  }
}
