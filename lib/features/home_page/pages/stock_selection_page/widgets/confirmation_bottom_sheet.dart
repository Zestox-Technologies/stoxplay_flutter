import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final StockSelectionCubit cubit;

  const ConfirmationBottomSheet({
    required this.cubit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          spacing: 20.h,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Confirmation",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Entry", style: TextStyle(fontSize: 16.sp)),
                Row(
                  children: [
                    Image.asset(AppAssets.stoxplayCoin, height: 18.h, width: 18.w),
                    Text("500", style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ],
            ),
            AppButton(
              text: "Join Contest",
              onPressed: () => _handleJoinContest(context),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _handleJoinContest(BuildContext context) {
    Navigator.pop(context);
    cubit.getReorderedStockList(cubit.state.selectedStockList);
    Navigator.pushNamed(
      context,
      AppRoutes.battleGroundScreen,
      arguments: cubit,
    );
  }
} 