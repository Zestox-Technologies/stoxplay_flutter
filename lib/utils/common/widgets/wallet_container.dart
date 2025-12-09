import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class WalletContainer extends StatelessWidget {
  final String? title;
  const WalletContainer({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.primaryPurple,
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: AppColors.primaryPurple),
          TextView(
            text: title ?? '69',
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ],
      ).paddingSymmetric(horizontal: 5.w, vertical: 5.h),
    );
  }
}
