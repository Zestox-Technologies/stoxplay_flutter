import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/widgets/contest_shimmer_widget.dart';
import 'package:stoxplay/features/stats_page/presentation/cubit/stats_cubit.dart';
import 'package:stoxplay/features/stats_page/widgets/completed_item_widget.dart';
import 'package:stoxplay/features/stats_page/widgets/live_item_widget.dart';
import 'package:stoxplay/features/stats_page/widgets/upcoming_item_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  late StatsCubit statsCubit;

  @override
  void dispose() {
    selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    statsCubit = BlocProvider.of<StatsCubit>(context);
  }

  Future<void> _refreshStatsData() async {
    await statsCubit.getMyContests(forceRefresh: true);
  }

  Widget _buildContentArea(StatsState state, int selectedIndex) {
    if (state.apiStatus.isLoading) {
      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        separatorBuilder: (context, index) => SizedBox(height: 15.h),
        itemBuilder: (context, index) {
          return ContestDetailsCardShimmer();
        },
      );
    }

    switch (selectedIndex) {
      case 0: // Upcoming
        if (state.stats?.upcoming?.isEmpty ?? true) {
          return SizedBox(height: 200.h, child: Center(child: Text("No Upcoming contests")));
        }
        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 50.h),
          itemCount: state.stats?.upcoming?.length ?? 0,
          itemBuilder: (context, index) => UpcomingItemWidget(data: state.stats!.upcoming![index]),
        );

      case 1: // Live
        if (state.stats?.live?.isEmpty ?? true) {
          return SizedBox(height: 200.h, child: Center(child: Text("No Live contests")));
        }
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          padding: EdgeInsets.only(bottom: 50.h),
          itemCount: state.stats?.live?.length ?? 0,
          itemBuilder: (context, index) => LiveItemWidget(data: state.stats!.live![index]),
        );

      case 2: // Completed
        if (state.stats?.completed?.isEmpty ?? true) {
          return SizedBox(height: 200.h, child: Center(child: Text("No Completed contests")));
        }
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          padding: EdgeInsets.only(bottom: 50.h),
          itemCount: state.stats?.completed?.length ?? 0,
          itemBuilder: (context, index) => CompletedItemWidget(data: state.stats!.completed![index]),
        );

      default:
        return SizedBox(height: 200.h, child: Center(child: Text("No data available")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [Expanded(child: Center(child: CommonAppbarTitle()))],
        ),
      ),

      body: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (context, selectedIndex, _) {
          return RefreshIndicator(
            color: AppColors.primaryPurple,
            onRefresh: () async {
              await _refreshStatsData();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(height: 1.h, width: double.maxFinite, color: Colors.grey),
                  Gap(15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: BlocBuilder<StatsCubit, StatsState>(
                      bloc: statsCubit,
                      builder: (context, state) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppColors.whiteF9F9,
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(color: AppColors.blackD7D7.withOpacity(0.3), width: 1),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectedIndexNotifier.value = 0;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color:
                                              selectedIndexNotifier.value == 0
                                                  ? AppColors.purple5A2F
                                                  : AppColors.transparent,
                                          borderRadius: BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color:
                                                selectedIndexNotifier.value == 0
                                                    ? AppColors.blackD7D7
                                                    : AppColors.blackD7D7.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Upcoming",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  selectedIndexNotifier.value == 0 ? AppColors.white : AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(4.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectedIndexNotifier.value = 1;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color:
                                              selectedIndexNotifier.value == 1
                                                  ? AppColors.purple5A2F
                                                  : AppColors.transparent,
                                          borderRadius: BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color:
                                                selectedIndexNotifier.value == 1
                                                    ? AppColors.blackD7D7
                                                    : AppColors.blackD7D7.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Live",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  selectedIndexNotifier.value == 1 ? AppColors.white : AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(4.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectedIndexNotifier.value = 2;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color:
                                              selectedIndexNotifier.value == 2
                                                  ? AppColors.primaryPurple
                                                  : AppColors.transparent,
                                          borderRadius: BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color:
                                                selectedIndexNotifier.value == 2
                                                    ? AppColors.blackD7D7
                                                    : AppColors.blackD7D7.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Completed",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  selectedIndexNotifier.value == 2 ? AppColors.white : AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(15.h),
                            // Content area with proper scrolling
                            _buildContentArea(state, selectedIndex),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
