import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/primary_container.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class ContestWidget extends StatelessWidget {
  final SectorModel data;
  final HomeCubit cubit;
  final String nextMatchDate;

  ContestWidget({super.key, required this.cubit, required this.nextMatchDate, required this.data});

  final GlobalKey _buttonKey = GlobalKey();

  void showOverlay(BuildContext context) {
    final renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: offset.dy + size.height, // Position below the widget
            left: offset.dx - 200,
            child: Material(
              color: AppColors.white,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Market is live!!! please join after 4 PM', style: TextStyle(color: AppColors.white)),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Positioned.fill(child: CachedImageWidget(imageUrl: data.backgroundImage.toString(), fit: BoxFit.cover)),
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(text: Strings.indianStockMarketChampionship, fontSize: 16.sp).paddingSymmetric(vertical: 5.h),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  height: 1,
                  color: AppColors.black.withOpacity(0.2),
                ),
                Gap(10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImageWidget(
                            imageUrl: data.sectorLogo ?? '',
                            height: 40.h,
                            width: 40.w,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextView(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              lineHeight: 1,
                              text: data.name.toString(),
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    ),
                    AppButton(
                      key: _buttonKey,
                      width: 65.w,
                      borderRadius: 5.r,
                      fontSize: 12.sp,
                      height: 25.h,
                      text: Strings.join,
                      fontWeight: FontWeight.w800,
                      textColor: AppColors.white,
                      onPressed: () async {
                        final isContestEnabled = await cubit.getContestStatus();
                        if (isContestEnabled) {
                          Navigator.pushNamed(context, AppRoutes.contestDetailsPage, arguments: data);
                        } else {
                          showOverlay(context);
                          return;
                        }
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
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(AppAssets.medalIcon, height: 10.h, width: 10.w),
                          Gap(5.w),
                          TextView(text: data.maxWin.toString(), fontSize: 12.sp, fontWeight: FontWeight.w300),
                        ],
                      ),
                    ),
                    Expanded(child: Center(child: Text(nextMatchDate))),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Image.asset(AppAssets.notificationBellIcon, height: 15.h, width: 15.w)],
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 14.w),
          ),
        ],
      ),
    );
  }
}
