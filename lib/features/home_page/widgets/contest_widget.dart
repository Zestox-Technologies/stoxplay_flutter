import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationForContestWidget,
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.blackD7D7), shape: BoxShape.circle),
                  child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: CachedImageWidget(
                      imageUrl: data.sectorLogo ?? '',
                      height: 20.h,
                      width: 20.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: TextView(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    lineHeight: 1,
                    overflow: TextOverflow.ellipsis,
                    fontColor: AppColors.primaryPurple,
                    text: data.name.toString(),
                  ),
                ),
              ],
            ),
            // Container(width: MediaQuery.of(context).size.width.w, height: 1, color: AppColors.black.withOpacity(0.2)),
            // Gap(10.h),
            SizedBox(
              height: 80.h,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (int i = 0; i < data.joinCountDistribution!.length; i++)
                          FlSpot(i.toDouble(), data.joinCountDistribution![i].toDouble()),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [Colors.green.withOpacity(0.8), Colors.white.withOpacity(0.2)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            Gap(20.h),
            TextView(text: '💰Win ${formatMaxWinIntl(data.maxWin ?? 0)}', fontSize: 12.sp, fontWeight: FontWeight.w600),
            TextView(text: '👥${data.maxWin.toString()} joined', fontSize: 12.sp, fontWeight: FontWeight.w600),
            Spacer(),
            AppButton(
              key: _buttonKey,
              borderRadius: 999.r,
              fontSize: 14.sp,
              height: 30.h,
              text: Strings.join,
              fontWeight: FontWeight.w800,
              textColor: AppColors.white,
              onPressed: () async {
                final isContestEnabled = await cubit.getContestStatus();
                if (isContestEnabled) {
                  Navigator.pushNamed(context, AppRoutes.contestDetailsPage, arguments: data);
                } else {
                  Fluttertoast.showToast(msg: "Market is live!!! please join after 4 PM");
                  return;
                }
              },
            ),
            Gap(5.h),
            // Gap(5.h),
            // Container(width: MediaQuery.of(context).size.width.w, height: 1, color: AppColors.black.withOpacity(0.2)),
            // Gap(5.h),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: Row(
            //         children: [
            //           Image.asset(AppAssets.medalIcon, height: 10.h, width: 10.w),
            //           Gap(5.w),
            //           TextView(text: data.maxWin.toString(), fontSize: 12.sp, fontWeight: FontWeight.w300),
            //         ],
            //       ),
            //     ),
            //     Expanded(child: Center(child: Text(nextMatchDate))),
            //     Expanded(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children: [Image.asset(AppAssets.notificationBellIcon, height: 15.h, width: 15.w)],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ).paddingSymmetric(horizontal: 14.w),
      ),
    );
  }
}
