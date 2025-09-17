import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/contest_leaderboard_model.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/progress_bar_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class CompletedDetailsScreen extends StatefulWidget {
  const CompletedDetailsScreen({super.key});

  @override
  State<CompletedDetailsScreen> createState() => _CompletedDetailsScreenState();
}

class _CompletedDetailsScreenState extends State<CompletedDetailsScreen> {
  late HomeCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    StatsDataModel data = ModalRoute.of(context)!.settings.arguments as StatsDataModel;
    cubit.getContestLeaderboard(data.contest?.id ?? '');

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: AppColors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CommonAppbarTitle(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        actions: [
          SizedBox(
            width: kToolbarHeight, // Match the space of the leading icon
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16.h),

            // Contest Card
            _buildContestCard(data: data),

            Gap(16.h),

            TextView(text: 'Leaderboard', fontSize: 16.sp, fontWeight: FontWeight.w700, fontColor: AppColors.black),
            Gap(12.h),
            BlocBuilder<HomeCubit, HomeState>(
              bloc: cubit,
              builder: (context, state) {
                final data = state.contestLeaderboardModel ?? ContestLeaderboardModel();
                if (state.apiStatus.isLoading) {
                  // show shimmer placeholders
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (_, __) => const LeaderboardItemShimmer(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.leaderboard?.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = data.leaderboard?[index];
                    return _buildLeaderboardItem(
                      rank: item?.rank ?? 1,
                      profileUrl: item?.user?.profilePictureUrl ?? '',
                      name: item?.teamName ?? '',
                      points: item?.points?.toInt() ?? 0,
                      prize: item?.prize?.toInt() ?? 0,
                    );
                  },
                );
              },
            ),

            Gap(16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContestCard({required StatsDataModel data}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo and name
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.blackD7D7), shape: BoxShape.circle),
                  child: ClipOval(child: CachedImageWidget(imageUrl: data.contest?.sectorLogo ?? '')),
                ),
                Gap(12.w),
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
                      TextView(
                        text: data.contest?.name ?? '',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.primaryPurple,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Gap(12.h),

            // Progress section
            ProgressBarWidget(
              value: data.contest?.spotsFilled?.toDouble() ?? 0.0,
              total: data.contest?.totalSpots?.toDouble() ?? 0.0,
            ),
            // Text(data.contest?.spotsRemaining.toString() ?? ''),
            Gap(12.h),

            // Team and details section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: Strings.team1,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.black,
                      ),
                      Gap(6.h),
                      Row(
                        children: [
                          Image.asset(AppAssets.firstPrizeIcon, height: 14.h, width: 14.w),
                          Gap(4.w),
                          TextView(
                            text: formatMaxWinIntl(data.contest?.firstPrize ?? 0, showRupeeSymbol: false),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.black,
                          ),
                          Gap(12.w),
                          Image.asset(AppAssets.championIcon, height: 14.h, width: 14.w),
                          Gap(4.w),
                          TextView(
                            text: "${data.contest?.winningPercentage.toString() ?? ''}%",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.black,
                          ),
                          Gap(12.w),
                          Image.asset(AppAssets.flexibleIcon, height: 14.h, width: 14.w),
                          Gap(4.w),
                          TextView(
                            text: 'Flexible',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppAssets.championIcon, height: 14.h, width: 14.w),
                        Gap(4.w),
                        TextView(
                          text: 'Prize: ₹${formatMaxWinIntl(data.contest?.prizePool ?? 0)}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: AppColors.black,
                        ),
                      ],
                    ),
                    Gap(8.h),
                    TextView(
                      text: '${data.contest?.spotsRemaining} Spots Remaining',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.black6666,
                    ),
                    Gap(8.h),
                    // Row(
                    //   children: [
                    //     Icon(Icons.visibility, size: 14.sp, color: AppColors.black6666),
                    //     Gap(4.w),
                    //     TextView(
                    //       text: 'View',
                    //       fontSize: 12.sp,
                    //       fontWeight: FontWeight.w500,
                    //       fontColor: AppColors.black6666,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String profileUrl,
    required String name,
    required int points,
    required int prize,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.blackD7D7, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            Gap(5.w),
            // Rank
            TextView(text: "#${rank.toString()}", fontWeight: FontWeight.w700),

            Gap(10.w),

            // Profile picture
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.blackD7D7,
              child: ClipOval(
                child: CachedImageWidget(imageUrl: profileUrl, height: 36.h, width: 36.w, fit: BoxFit.cover),
              ),
            ),

            Gap(10.w),

            // Name and points
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(text: name, fontSize: 14.sp, fontWeight: FontWeight.w600, fontColor: AppColors.black),
                  Row(
                    children: [
                      Image.asset(AppAssets.cupIcon, height: 14.h, width: 14.w),
                      Gap(4.w),
                      TextView(
                        text: '$points Points',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.black6666,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(text: prize.toString() ?? '0', fontSize: 14.sp),
                Gap(5.w),
                Image.asset(AppAssets.stoxplayCoin, height: 15.h, width: 15.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardItemShimmer extends StatelessWidget {
  const LeaderboardItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            SizedBox(width: 5.w),

            // Rank shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(width: 30.w, height: 14.h, color: Colors.grey),
            ),

            SizedBox(width: 10.w),

            // Profile shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: CircleAvatar(radius: 18.r, backgroundColor: Colors.grey),
            ),

            SizedBox(width: 10.w),

            // Name + points shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(width: 100.w, height: 14.h, color: Colors.grey),
                  ),
                  SizedBox(height: 6.h),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(width: 80.w, height: 12.h, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Prize shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(width: 50.w, height: 14.h, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
