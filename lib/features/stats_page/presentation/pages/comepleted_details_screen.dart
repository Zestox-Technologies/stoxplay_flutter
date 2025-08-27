import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/common/widgets/progress_bar_widget.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class CompletedDetailsScreen extends StatelessWidget {
  const CompletedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            _buildContestCard(),

            Gap(16.h),

            // Leaderboard Section
            _buildLeaderboardSection(),

            Gap(16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContestCard() {
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
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.blackD7D7), shape: BoxShape.circle),
                  child: ClipOval(child: Image.asset(AppAssets.bankWars, height: 20.h, width: 20.w, fit: BoxFit.cover)),
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: 'HDFC Bank Ltd.',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.black,
                      ),
                      TextView(
                        text: 'Bank wars',
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
            Row(
              children: [
                TextView(text: 'Complete', fontSize: 12.sp, fontWeight: FontWeight.w600, fontColor: AppColors.black),
                Gap(6.w),
                Expanded(child: ProgressBarWidget(value: 0.9, total: 1.0)),
              ],
            ),

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
                            text: '30k',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.black,
                          ),
                          Gap(12.w),
                          Image.asset(AppAssets.championIcon, height: 14.h, width: 14.w),
                          Gap(4.w),
                          TextView(
                            text: '50%',
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
                        Image.asset(AppAssets.cupIcon, height: 14.h, width: 14.w),
                        Gap(4.w),
                        TextView(
                          text: 'Prize: ₹8,10,000',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: AppColors.black,
                        ),
                      ],
                    ),
                    Gap(8.h),
                    TextView(
                      text: '2000 Spots Remaining',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.black6666,
                    ),
                    Gap(8.h),
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 14.sp, color: AppColors.black6666),
                        Gap(4.w),
                        TextView(
                          text: 'View',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.black6666,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView(text: 'Leaderboard', fontSize: 16.sp, fontWeight: FontWeight.w700, fontColor: AppColors.black),
        Gap(12.h),

        // Leaderboard items
        _buildLeaderboardItem(
          rank: 1,
          name: 'Rajesh Kumar',
          points: 120,
          isTopRank: true,
          rankColor: AppColors.orangeF1BE,
          showCrown: true,
        ),
        _buildLeaderboardItem(
          rank: 2,
          name: 'Amit Sharma',
          points: 120,
          isTopRank: true,
          rankColor: AppColors.blackC2C2,
          showCrown: true,
        ),
        _buildLeaderboardItem(
          rank: 3,
          name: 'Vikram Singh',
          points: 120,
          isTopRank: true,
          rankColor: AppColors.orangeF99E,
          showCrown: true,
        ),
        _buildLeaderboardItem(rank: 4, name: 'Arjun Patel', points: 120, isTopRank: false),
        _buildLeaderboardItem(rank: 5, name: 'Oliver Johnson', points: 120, isTopRank: false),
        _buildLeaderboardItem(rank: 10, name: 'Ravi Mehta', points: 120, isTopRank: false, isCurrentUser: true),
      ],
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required int points,
    required bool isTopRank,
    Color? rankColor,
    bool showCrown = false,
    bool isCurrentUser = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primaryPurple.withOpacity(0.1) : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isCurrentUser ? AppColors.primaryPurple : AppColors.blackD7D7,
          width: isCurrentUser ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
                        // Rank
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(color: rankColor ?? AppColors.blackD7D7, shape: BoxShape.circle),
              child: Center(
                child: TextView(
                  text: rank.toString(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  fontColor: AppColors.white,
                ),
              ),
            ),
 
            Gap(10.w),

                        // Profile picture
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.blackD7D7,
              child: ClipOval(
                child: Image.asset(AppAssets.userProfileIcon, height: 36.h, width: 36.w, fit: BoxFit.cover),
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

            // Crown or user indicator
            if (showCrown)
              Image.asset(AppAssets.championIcon, height: 20.h, width: 20.w)
            else if (isCurrentUser)
                              Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(color: AppColors.primaryPurple, borderRadius: BorderRadius.circular(8.r)),
                  child: TextView(text: 'You', fontSize: 11.sp, fontWeight: FontWeight.w600, fontColor: AppColors.white),
                ),
          ],
        ),
      ),
    );
  }
}
