import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/utils/common/widgets/common_back_button.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class PlayingHistoryPage extends StatefulWidget {
  const PlayingHistoryPage({super.key});

  @override
  State<PlayingHistoryPage> createState() => _PlayingHistoryPageState();
}

class _PlayingHistoryPageState extends State<PlayingHistoryPage> {
  // Mock data for recent games
  final List<GameHistoryItem> recentGames = [
    GameHistoryItem(
      gameTitle: "Challenge: Tech Clash",
      date: "18 July 2025 3:30 PM",
      rank: 5,
      score: 750,
    ),
    GameHistoryItem(
      gameTitle: "Challenge: Tech Clash",
      date: "18 July 2025 3:30 PM",
      rank: 1,
      score: 750,
    ),
    GameHistoryItem(
      gameTitle: "Challenge: Tech Clash",
      date: "18 July 2025 3:30 PM",
      rank: 5,
      score: 750,
    ),
    GameHistoryItem(
      gameTitle: "Challenge: Tech Clash",
      date: "18 July 2025 3:30 PM",
      rank: 5,
      score: 750,
    ),
    GameHistoryItem(
      gameTitle: "Challenge: Tech Clash",
      date: "18 July 2025 3:30 PM",
      rank: 5,
      score: 750,
    ),
    GameHistoryItem(
      gameTitle: "Challenge: Tech Clash",
      date: "18 July 2025 3:30 PM",
      rank: 5,
      score: 750,
    ),
    GameHistoryItem(
      gameTitle: "Challenge: Tech Clash",
      date: "18 July 2025 3:30 PM",
      rank: 5,
      score: 750,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  CommonBackButton(

                    onTap: () => Navigator.pop(context),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: TextView(
                      text: "Playing History",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(56.w), // Balance the back button width
                ],
              ),
            ),
            
            // Recent Games Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(16.h),
                    TextView(
                      text: "Recent Games",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    Gap(16.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: recentGames.length,
                        itemBuilder: (context, index) {
                          final game = recentGames[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _GameHistoryCard(game: game),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameHistoryCard extends StatelessWidget {
  final GameHistoryItem game;

  const _GameHistoryCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteF9F9,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.blackD7D7,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  text: game.gameTitle,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  fontColor: AppColors.purple5A2F,
                ),
                Gap(4.h),
                TextView(
                  text: "Date: ${game.date}",
                  fontSize: 12.sp,
                  fontColor: AppColors.black9999,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextView(
                text: "Rank: #${game.rank}",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              Gap(4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.stoxplayCoin,
                    height: 16.h,
                    width: 16.w,
                  ),
                  Gap(4.w),
                  TextView(
                    text: "${game.score}",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Data model for game history items
class GameHistoryItem {
  final String gameTitle;
  final String date;
  final int rank;
  final int score;

  GameHistoryItem({
    required this.gameTitle,
    required this.date,
    required this.rank,
    required this.score,
  });
}
