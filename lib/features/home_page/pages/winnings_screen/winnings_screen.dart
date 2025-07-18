import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/pages/home_page.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class WinningsScreen extends StatefulWidget {
  const WinningsScreen({super.key});

  @override
  State<WinningsScreen> createState() => _WinningsScreenState();
}

class _WinningsScreenState extends State<WinningsScreen> {
  int selectedTab = 0; // 0: Leaderboard, 1: Winnings
  final String currentUser = 'Ravi Mehta';
  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: AppColors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: CommonAppbarTitle(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        actions: [SizedBox(width: kToolbarHeight)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Gap(10.h),
            _ContestSummaryCard(),
            Gap(16.h),
            _StatsGrid(),
            Gap(12.h),
            // _InviteBanner(),
            // Gap(16.h),
            _TabSwitcher(selectedIndex: selectedIndex),
            Gap(10.h),
            ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, selected, _) {
                return Expanded(
                  child:
                      selectedIndex.value == 0
                          ? _LeaderboardList(leaderboard: leaderboard, currentUser: currentUser)
                          : _WinningsList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ContestSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple5A2F.withOpacity(0.15),
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.purple5A2F.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(text: 'Rahul Kumar', fontWeight: FontWeight.w600, fontSize: 18.sp),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextView(text: 'Prize Pool', fontWeight: FontWeight.w500, fontSize: 14.sp),
                  Gap(4.w),
                  Image.asset(AppAssets.stoxplayCoin, height: 18.h, width: 18.w),
                  Gap(2.w),
                  TextView(text: '30,000', fontWeight: FontWeight.bold, fontSize: 16.sp),
                ],
              ),
              Row(
                children: [
                  TextView(text: 'Entry Fees', fontWeight: FontWeight.w500, fontSize: 14.sp),
                  Gap(4.w),
                  Image.asset(AppAssets.stoxplayCoin, height: 18.h, width: 18.w),
                  Gap(2.w),
                  TextView(text: '500', fontWeight: FontWeight.bold, fontSize: 16.sp),
                ],
              ),
            ],
          ),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people, size: 16, color: AppColors.black6666),
                  Gap(4.w),
                  TextView(text: '30k', fontSize: 12.sp, fontColor: AppColors.black6666),
                  Gap(12.w),
                  Icon(Icons.percent, size: 16, color: AppColors.black6666),
                  Gap(4.w),
                  TextView(text: '50%', fontSize: 12.sp, fontColor: AppColors.black6666),
                  Gap(12.w),
                  Icon(Icons.timer, size: 16, color: AppColors.black6666),
                  Gap(4.w),
                  TextView(text: '10', fontSize: 12.sp, fontColor: AppColors.black6666),
                ],
              ),
              TextView(text: 'Rank – 1', fontWeight: FontWeight.w600, fontSize: 14.sp),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'icon': '📊', 'title': '6,000', 'subtitle': 'spots left', 'highlight': true},
      {'icon': '🏆', 'title': 'Top 25%', 'subtitle': 'Winners'},
      {'icon': '📈', 'title': '₹7.5 Lakhs', 'subtitle': 'Total Payout'},
      {'icon': '🎯', 'title': '20', 'subtitle': 'Teams Max Entry'},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _StatCardBox(data: stats[0])),
              Gap(12.w),
              Expanded(child: _StatCardBox(data: stats[1])),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(child: _StatCardBox(data: stats[2])),
              Gap(12.w),
              Expanded(child: _StatCardBox(data: stats[3])),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCardBox extends StatelessWidget {
  final Map<String, dynamic> data;

  const _StatCardBox({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.blackD7D7.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.blackD7D7.withOpacity(0.3)),
              ),
              alignment: Alignment.center,
              child: Text(data['icon'], style: TextStyle(fontSize: 28, color: AppColors.purple5A2F)),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextView(
                    text: data['title'],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    fontColor: AppColors.purple5A2F,
                  ),
                  Flexible(
                    child: TextView(
                      text: data['subtitle'],
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      maxLines: 2,
                      letterSpacing: 0,
                      lineHeight: 0.8,
                      fontColor: AppColors.black6666,
                    ),
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

// class _InviteBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: 16.w),
//       padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.purple5A2F, AppColors.purpleE46E],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [BoxShadow(color: AppColors.purple5A2F.withOpacity(0.15), blurRadius: 8, offset: Offset(0, 2))],
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.card_giftcard, color: Colors.white, size: 28),
//           Gap(12.w),
//           Expanded(
//             child: TextView(
//               text: 'Invite Friends & Earn ₹250',
//               fontColor: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16.sp,
//             ),
//           ),
//           Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
//         ],
//       ),
//     );
//   }
// }

class _TabSwitcher extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;

  const _TabSwitcher({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, selected, _) {
          return SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: CommonTabWidget(
                    onTap: () {
                      selectedIndex.value = 0;
                    },
                    isSelected: selectedIndex.value == 0,
                    title: Strings.leaderBoard,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: CommonTabWidget(
                    onTap: () {
                      selectedIndex.value = 1;
                    },
                    isSelected: selectedIndex.value == 1,
                    title: Strings.winnings,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.purple5A2F.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(32.r),
          ),
          alignment: Alignment.center,
          child: TextView(
            text: text,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            fontColor: selected ? AppColors.purple5A2F : AppColors.black6666,
          ),
        ),
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard;
  final String currentUser;

  const _LeaderboardList({required this.leaderboard, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    // Show top 5, and always show 'You' at the bottom if not in top 5
    final topN = 5;
    final youIndex = leaderboard.indexWhere((u) => u['isCurrentUser'] == true);
    final topList = leaderboard.take(topN).toList();
    final youUser = youIndex >= 0 ? leaderboard[youIndex] : null;
    final youInTop = youIndex < topN && youIndex >= 0;
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: topList.length,
            separatorBuilder: (_, __) => Gap(8.h),
            itemBuilder: (context, index) {
              final user = topList[index];
              return _LeaderboardItem(
                rank: index + 1,
                name: user['name'],
                avatar: user['avatar'],
                points: user['points'],
                isCrown: user['isCrown'],
                isCurrentUser: user['isCurrentUser'],
              );
            },
          ),
        ),
        if (!youInTop && youUser != null) ...[
          Divider(height: 1, color: AppColors.blackD7D7.withOpacity(0.3)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: _LeaderboardItem(
              rank: youIndex + 1,
              name: youUser['name'],
              avatar: youUser['avatar'],
              points: youUser['points'],
              isCrown: youUser['isCrown'],
              isCurrentUser: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final String avatar;
  final int points;
  final bool isCrown;
  final bool isCurrentUser;

  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    required this.isCrown,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.purple5A2F.withOpacity(0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCurrentUser ? AppColors.purple5A2F : AppColors.blackD7D7.withOpacity(0.6),
          width: isCurrentUser ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Gap(12.w),
          TextView(text: rank.toString(), fontWeight: FontWeight.w600, fontSize: 16.sp),
          Expanded(
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 22.r),
              title: Row(
                children: [
                  TextView(text: name, fontWeight: FontWeight.w600, fontSize: 16.sp),
                  Gap(8.w),
                  if (isCurrentUser)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.purple5A2F.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextView(
                        text: 'You',
                        fontColor: AppColors.purple5A2F,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                ],
              ),
              subtitle: TextView(text: '$points Points', fontSize: 14.sp, fontColor: AppColors.black6666),
              trailing:
                  isCrown
                      ? Icon(Icons.emoji_events, color: AppColors.orangeF6A6, size: 28)
                      : rank == 1
                      ? Icon(Icons.emoji_events, color: AppColors.orangeF6A6, size: 28)
                      : null,
              leadingAndTrailingTextStyle: null,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              minVerticalPadding: 0,
              horizontalTitleGap: 12.w,
            ),
          ),
        ],
      ),
    );
  }
}

class _WinningsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy winnings data
    final winnings = List.generate(18, (i) => {'rank': i + 1, 'amount': 1000});
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: winnings.length,
      separatorBuilder: (_, __) => Gap(8.h),
      itemBuilder: (context, index) {
        final item = winnings[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.whiteF9F9,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.blackD7D7.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextView(text: '${item['rank']}', fontWeight: FontWeight.w600, fontSize: 16.sp),
              Row(
                children: [
                  TextView(text: '${item['amount']}', fontWeight: FontWeight.w500, fontSize: 16.sp),
                  Gap(4.w),
                  Image.asset(AppAssets.stoxplayCoin, height: 18.h, width: 18.w),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
