import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/pages/contest_details_page/contest_details_page.dart';
import 'package:stoxplay/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/primary_container.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class ContestWidget extends StatelessWidget {
  final ContestModel data;

  ContestWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            text: Strings.indianStockMarketChampionship,
            fontSize: 16.sp,
          ).paddingSymmetric(vertical: 5.h),
          Container(
            width: MediaQuery.of(context).size.width.w,
            height: 1,
            color: AppColors.black.withOpacity(0.2),
          ),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(data.image, height: 60.h, width: 60.w),
                  SizedBox(width: 10.w),
                  TextView(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    text: data.title,
                  ),
                ],
              ),
              AppButton(
                width: 65.w,
                borderRadius: 5.r,
                fontSize: 12.sp,
                height: 25.h,
                text: Strings.join,
                fontWeight: FontWeight.w800,
                textColor: AppColors.white,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.contestDetailsPage,
                    arguments: data,
                  );
                },
              ),
            ],
          ),
          Gap(5.h),
          Container(
            width: MediaQuery.of(context).size.width.w,
            height: 1,
            color: AppColors.black.withOpacity(0.2),
          ),
          Gap(5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(AppAssets.medalIcon, height: 10.h, width: 10.w),
                  Gap(5.w),
                  TextView(
                    text: data.price,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ],
              ),
              Image.asset(
                AppAssets.notificationBellIcon,
                height: 15.h,
                width: 15.w,
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 14.w),
    );
  }
}
