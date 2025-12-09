import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class TermsConditionWidget extends StatelessWidget {
  const TermsConditionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "By continuing, you agree to our ",
                  style: TextStyle(
                    fontFamily: 'Sofia Sans',
                    fontSize: 10.sp,
                    color: AppColors.black6666,
                    fontWeight: FontWeight.w300,
                    height: 18 / 14,
                  ),
                ),
                TextSpan(
                  text: "terms & conditions",
                  style: TextStyle(
                    fontFamily: 'Sofia Sans',
                    fontSize: 10.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    height: 18 / 14,
                  ),
                ),
                TextSpan(
                  text: " and ",
                  style: TextStyle(
                    fontFamily: 'Sofia Sans',
                    color: AppColors.black6666,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                    height: 18 / 14,
                  ),
                ),
                TextSpan(
                  text: "privacy policies.",
                  style: TextStyle(
                    fontFamily: 'Sofia Sans',
                    fontSize: 10.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    height: 18 / 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          TextView(
            fontSize: 10.sp,
            text: Strings.zestoxTechnologies,
            fontWeight: FontWeight.w300,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
