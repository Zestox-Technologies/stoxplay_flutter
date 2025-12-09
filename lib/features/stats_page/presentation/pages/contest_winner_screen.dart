import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/stats_page/widgets/contest_winner_item_widget.dart';
import 'package:stoxplay/features/stats_page/widgets/winners_item_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class ContestWinnerPage extends StatelessWidget {
  const ContestWinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            Stack(
              children: [
                Divider(color: AppColors.black).paddingTop(5.h),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: AppColors.white,
                    child: TextView(text: Strings.myContest, fontSize: 18.sp).paddingSymmetric(horizontal: 20.w),
                  ),
                ),
              ],
            ),
            Gap(20.h),
            ContestWinnerItemWidget(),
            Gap(40.h),
            SizedBox(height: 115.h, width: 200.w, child: Image.asset(AppAssets.celebrationStarImage)),
            TextView(text: Strings.topWinnersInTheMatch, fontSize: 24.sp, fontWeight: FontWeight.w700),
            Gap(40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [WinnersItemWidget(), WinnersItemWidget(), WinnersItemWidget()],
            ),
            Gap(30.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.black.withOpacity(0.5)),
              ),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // <-- This keeps it tight to content
                children: [TextView(text: "VIEW MORE"), Icon(Icons.arrow_forward_ios, size: 14)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
