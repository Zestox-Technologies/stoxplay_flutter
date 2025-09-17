import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/contest_detail_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_leaderboard_model.dart';
import 'package:stoxplay/features/home_page/pages/contest_details_page/contest_data_shimmer.dart';
import 'package:stoxplay/features/home_page/pages/home_page.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/progress_bar_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class ContestDataScreen extends StatefulWidget {
  const ContestDataScreen({super.key});

  @override
  State<ContestDataScreen> createState() => _ContestDataScreenState();
}

class _ContestDataScreenState extends State<ContestDataScreen> {
  int selectedTab = 0; // 0: Leaderboard, 1: Winnings
  final String currentUser = 'Ravi Mehta';
  ValueNotifier<int> selectedIndex = ValueNotifier(0);
  late HomeCubit homeCubit;
  String? contestId;

  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);

    // Get contest ID from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        contestId = args;
        _loadContestData();
      }
    });
  }

  void _loadContestData() {
    if (contestId != null) {
      homeCubit.getContestDetails(contestId!);
      homeCubit.getContestLeaderboard(contestId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
        body: BlocBuilder<HomeCubit, HomeState>(
          bloc: homeCubit,
          builder: (context, state) {
            final startingBreakupList =
                state.contestDetailModel?.prizeDistributionTemplate?.slabs
                    ?.where((element) => element.type?.toUpperCase() == "GUARANTEED")
                    .toList();
            final maximumBreakupList =
                state.contestDetailModel?.prizeDistributionTemplate?.slabs
                    ?.where((element) => element.type?.toUpperCase() == "MAX")
                    .toList();

            return state.apiStatus.isLoading
                ? const ContestDetailsShimmer()
                : SafeArea(
                  child: ValueListenableBuilder(
                    valueListenable: selectedIndex,
                    builder: (context, selected, _) {
                      return CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(child: Gap(10.h)),
                          SliverToBoxAdapter(
                            child: ContestSummaryCard(data: state.contestDetailModel ?? ContestDetailModel()),
                          ),
                          SliverToBoxAdapter(child: Gap(16.h)),
                          SliverToBoxAdapter(child: StatsGrid(data: state.contestDetailModel ?? ContestDetailModel())),
                          SliverToBoxAdapter(child: Gap(12.h)),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _StickyTabDelegate(child: _TabSwitcher(selectedIndex: selectedIndex)),
                          ),
                          SliverToBoxAdapter(child: Gap(10.h)),
                          ..._buildTabContent(
                            startingBreakupList: startingBreakupList ?? [],
                            maximumBreakupList: maximumBreakupList ?? [],
                            leaderboard: state.contestLeaderboardModel ?? ContestLeaderboardModel(),
                          ),
                        ],
                      );
                    },
                  ),
                );
          },
        ),
      ),
    );
  }

  List<Widget> _buildTabContent({
    required List<Slab> startingBreakupList,
    required List<Slab> maximumBreakupList,
    required ContestLeaderboardModel leaderboard,
  }) {
    if (selectedIndex.value == 0) {
      return [SliverFillRemaining(hasScrollBody: true, child: _LeaderboardList(data: leaderboard))];
    } else {
      return [
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyTabDelegate(
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: const [Tab(text: 'Starting Breakup'), Tab(text: 'Maximum Breakup')],
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: TabBarView(
            children: [WinningsList(list: startingBreakupList), WinningsList(list: maximumBreakupList)],
          ),
        ),
      ];
    }
  }
}

// Add StickyTabDelegate for sliver sticky tab effect
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabDelegate({required this.child});

  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyTabDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class ContestSummaryCard extends StatelessWidget {
  final ContestDetailModel data;

  const ContestSummaryCard({super.key, required this.data});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(text: data.name ?? 'Contest', fontWeight: FontWeight.w600, fontSize: 18.sp),
                    if (data.sector?.name != null)
                      TextView(
                        text: data!.sector!.name.toString(),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        fontColor: AppColors.primaryPurple,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextView(text: 'First prize:', fontWeight: FontWeight.w500, fontSize: 14.sp),
                  Gap(4.w),
                  TextView(text: formatMaxWinIntl(data.prizePool ?? 0), fontWeight: FontWeight.bold, fontSize: 14.sp),
                  Image.asset(AppAssets.stoxplayCoin, height: 12.h, width: 12.w),
                ],
              ),
            ],
          ),
          Gap(8.h),
          ProgressBarWidget(value: (data.spotsFilled ?? 0).toDouble(), total: (data.totalSpots ?? 1).toDouble()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextView(text: "${data.spotsFilled ?? 0} spots filled", fontColor: AppColors.black, fontSize: 12.sp),
              TextView(
                text: "${data.totalSpots ?? 0} spots",
                fontColor: AppColors.black,
                lineHeight: 1.5,
                letterSpacing: 0,
                fontSize: 12.sp,
              ),
            ],
          ),
          Gap(5.h),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.stockSelectionScreen,
                arguments: {'contestId': data.id, 'price': data.entryFee.toString()},
              );
            },
            child: Container(
              height: 28.h,
              decoration: BoxDecoration(color: AppColors.primaryPurple, borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.entryFee.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.white, fontSize: 13.sp, fontWeight: FontWeight.w800),
                  ),
                  Gap(5.w),
                  Image.asset(AppAssets.stoxplayCoin, height: 12.h, width: 12.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsGrid extends StatelessWidget {
  final ContestDetailModel data;

  const StatsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'icon': AppAssets.chartJson,
        'title': data.spotsFilled.toString(),
        'subtitle': 'spots filled',
        'highlight': true,
      },
      {'icon': AppAssets.trophyJson, 'title': 'Top ${data.teamsPerUser}%', 'subtitle': 'Winners'},
      {'icon': AppAssets.graphJson, 'title': formatMaxWinIntl(data.prizePool ?? 0), 'subtitle': 'Total Payout'},
      {'icon': AppAssets.targetJson, 'title': data.teamsPerUser.toString(), 'subtitle': 'Teams Max Entry'},
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
              child: Lottie.asset(data['icon'], height: 30, width: 30),
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

class _LeaderboardList extends StatelessWidget {
  final ContestLeaderboardModel data;

  const _LeaderboardList({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: data.leaderboard?.length ?? 0,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => Gap(8.h),
            itemBuilder: (context, index) {
              final user = data.leaderboard?[index];
              return _LeaderboardItem(
                rank: index + 1,
                name: user?.teamName ?? '',
                avatar: user?.user?.profilePictureUrl ?? '',
                points: user?.points?.toInt() ?? 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final String avatar;
  final int points;

  const _LeaderboardItem({required this.rank, required this.name, required this.avatar, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.blackD7D7.withOpacity(0.6), width: 1),
      ),
      child: Row(
        children: [
          Gap(12.w),
          TextView(text: "#", fontWeight: FontWeight.w600, fontSize: 16.sp),
          Expanded(
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 18.r),
              title: Row(
                children: [
                  TextView(text: name, fontWeight: FontWeight.w600, fontSize: 16.sp),
                  // Gap(8.w),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.purple5A2F.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(8.r),
                  //   ),
                  //   child: Text("T1", style: TextStyle(fontSize: 12.sp)),
                  // ),
                ],
              ),
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

class WinningsList extends StatelessWidget {
  final List<Slab> list;

  const WinningsList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: list.length,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => Gap(8.h),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.blackD7D7.withOpacity(0.8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextView(
                text: item.rankStart == item.rankEnd ? '${item.rankStart}' : '${item.rankStart} - ${item.rankEnd}',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),

              Row(
                children: [
                  TextView(
                    text: '${item.prizeAmount}',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    fontColor: AppColors.primaryPurple,
                  ),
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
