import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/common/cubits/multi_timer_cubit.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/progress_bar_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';

class UpcomingItemWidget extends StatelessWidget {
  final StatsDataModel data;

  const UpcomingItemWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.contestDataScreen, arguments: data.contest?.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.blackD7D7, width: 1),
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            // Top Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // HDFC Bank Logo
                  CircleAvatar(
                    radius: 20.r,
                    child: ClipOval(
                      child: CachedImageWidget(
                        imageUrl: data.contest?.sectorLogo ?? '',
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Gap(12.w),
                  // Bank Name and Type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                          text: data.name ?? '',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.black,
                        ),
                        Gap(2.h),
                        TextView(
                          text: data.contest?.name ?? '',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.purple5A2F,
                        ),
                      ],
                    ),
                  ),

                  // Entry Fee and Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextView(
                        text: "Entry Fee ₹${data.contest?.entryFee}",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.purple5A2F,
                      ),
                      Gap(2.h),
                      BlocBuilder<MultiTimerCubit, MultiTimerState>(
                        bloc: MultiTimerCubit.instance,
                        builder: (context, timerState) {
                          final contestId = data.id ?? '';
                          final remainingSeconds = timerState.getRemainingSeconds(contestId);

                          if (timerState.isTimerRunning(contestId) && remainingSeconds > 0) {
                            final duration = Duration(seconds: remainingSeconds);
                            final days = duration.inDays;
                            final hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
                            final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
                            final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

                            String timeText;
                            if (days > 0) {
                              timeText = '${days}d $hours:$minutes:$seconds';
                            } else {
                              timeText = '$hours:$minutes:$seconds';
                            }

                            return TextView(
                              text: "Time Left: $timeText",
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.purple5A2F,
                            );
                          } else {
                            // Fallback to static time display if timer is not running
                            if (data.contest?.timeLeft != null) {
                              final timeLeft = data.contest!.timeLeft!;
                              String timeText = '';

                              if (timeLeft.days != null && timeLeft.days! > 0) {
                                timeText += '${timeLeft.days}d ';
                              }
                              if (timeLeft.hours != null) {
                                timeText += '${timeLeft.hours.toString().padLeft(2, '0')}:';
                              }
                              if (timeLeft.minutes != null) {
                                timeText += '${timeLeft.minutes.toString().padLeft(2, '0')}:';
                              }
                              if (timeLeft.seconds != null) {
                                timeText += timeLeft.seconds.toString().padLeft(2, '0');
                              }

                              return TextView(
                                text: "Time Left: $timeText",
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.purple5A2F,
                              );
                            }
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Container(height: 1.h, color: AppColors.blackD7D7, margin: EdgeInsets.symmetric(horizontal: 16.w)),

            // Middle Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: "Upcoming",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.purple5A2F,
                  ),
                  Row(
                    children: [
                      Image.asset(AppAssets.cupIcon, height: 16.h, width: 16.w),
                      Gap(4.w),
                      TextView(
                        text: "Prize: ${formatMaxWinIntl(data.contest?.prizePool ?? 0)}",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.black9999,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            // Container(height: 1.h, color: AppColors.blackD7D7, margin: EdgeInsets.symmetric(horizontal: 16.w)),

            // Progress Bar Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              child: Column(
                children: [
                  // Progress Bar
                  ProgressBarWidget(
                    value: data.contest?.spotsFilled?.toDouble() ?? 0.0,
                    total: data.contest?.totalSpots?.toDouble() ?? 0.0,
                  ),
                  Gap(8.h),
                  // Team and Spots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextView(
                        text: "${data.name?.split("-").last}",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.purple5A2F,
                      ),
                      TextView(
                        text: "${data.contest?.spotsRemaining ?? 0} Spots Remaining",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.black9999,
                      ),
                    ],
                  ),
                  Gap(8.h),

                  // Stats Row
                  Row(
                    children: [
                      Row(
                        children: [
                          Image.asset(AppAssets.firstPrizeIcon, height: 14.h, width: 14.w),
                          Gap(4.w),
                          TextView(
                            text: formatMaxWinIntl(data.contest?.firstPrize ?? 0, showRupeeSymbol: false),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.black,
                          ),
                        ],
                      ),
                      Gap(16.w),

                      // Trophy with 50%
                      Row(
                        children: [
                          Image.asset(AppAssets.championIcon, height: 14.h, width: 14.w),
                          Gap(4.w),
                          TextView(
                            text: "${data.contest?.winningPercentage}%",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.black,
                          ),
                        ],
                      ),
                      Gap(16.w),

                      // Rupee with Flexible
                      Row(
                        children: [
                          Image.asset(AppAssets.flexibleIcon, height: 14.h, width: 14.w),
                          Gap(4.w),
                          TextView(
                            text: "Flexible",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.black,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Action Buttons
                      Row(
                        children: [
                          // View Button
                          GestureDetector(
                            behavior: HitTestBehavior.translucent, // 👈 expands tap area to full bounds
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.battleGroundScreen, arguments: data.id ?? '');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h), // 👈 add padding
                              child: Row(
                                children: [
                                  Icon(Icons.visibility_outlined, size: 16.sp, color: AppColors.black6666),
                                  Gap(4.w),
                                  TextView(
                                    text: "View",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    fontColor: AppColors.black6666,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Gap(10.w),

                          // Edit Button
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.stockSelectionScreen,
                                arguments: {
                                  'teamId': data.id,
                                  'contestId': data.contest?.id,
                                  'price': '${data.contest?.entryFee}',
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(AppAssets.editIcon, height: 16.h, width: 16.w, color: AppColors.black6666),
                                Gap(4.w),
                                TextView(
                                  text: "Edit",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  fontColor: AppColors.black6666,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
