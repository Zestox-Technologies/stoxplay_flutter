import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/stats_page/pages/contest_winner_screen.dart';
import 'package:stoxplay/features/stats_page/widgets/completed_item_widget.dart';
import 'package:stoxplay/features/stats_page/widgets/live_item_widget.dart';
import 'package:stoxplay/features/stats_page/widgets/upcoming_item_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/primary_container.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final ValueNotifier<int> completedIndexNotifier = ValueNotifier(0);

  @override
  void dispose() {
    selectedIndexNotifier.dispose();
    completedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: CommonAppbarTitle(),
          centerTitle: true,
          backgroundColor: AppColors.white,
          leading:
              selectedIndexNotifier.value == 1
                  ? IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    color: AppColors.black,
                    onPressed: () {
                      selectedIndexNotifier.value--;
                    },
                  )
                  : null,
        ),
        body: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (context, selectedIndex, _) {
            return ValueListenableBuilder(
              valueListenable: completedIndexNotifier,
              builder: (context, completedIndex, _) {
                return Column(
                  children: [
                    Container(
                      height: 1.h,
                      width: double.maxFinite,
                      color: Colors.grey,
                    ),
                    Gap(15.h),
                    completedIndexNotifier.value == 0
                        ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              Row(
                                spacing: 8.w,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectedIndexNotifier.value = 0;
                                      },
                                      child: PrimaryContainer(
                                        borderWidth: 1,
                                        borderRadius: 5.r,
                                        borderColor:
                                            selectedIndexNotifier.value == 0
                                                ? AppColors.blue7E.withOpacity(
                                                  0.5,
                                                )
                                                : AppColors.black9A9A
                                                    .withOpacity(0.5),
                                        child: Center(
                                          child: Text(
                                            "Upcoming",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color:
                                                  selectedIndexNotifier.value ==
                                                          0
                                                      ? AppColors.black
                                                      : AppColors.black9A9A,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectedIndexNotifier.value = 1;
                                      },
                                      child: PrimaryContainer(
                                        borderWidth: 1,
                                        borderRadius: 5.r,
                                        borderColor:
                                            selectedIndexNotifier.value == 1
                                                ? AppColors.blue7E.withOpacity(
                                                  0.5,
                                                )
                                                : AppColors.black9A9A
                                                    .withOpacity(0.5),
                                        child: Center(
                                          child: Text(
                                            "Live",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color:
                                                  selectedIndexNotifier.value ==
                                                          1
                                                      ? AppColors.black
                                                      : AppColors.black9A9A,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectedIndexNotifier.value = 2;
                                      },
                                      child: PrimaryContainer(
                                        borderWidth: 1,
                                        borderRadius: 5.r,
                                        borderColor:
                                            selectedIndexNotifier.value == 2
                                                ? AppColors.blue7E.withOpacity(
                                                  0.5,
                                                )
                                                : AppColors.black9A9A
                                                    .withOpacity(0.5),
                                        child: Center(
                                          child: Text(
                                            "Completed",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color:
                                                  selectedIndexNotifier.value ==
                                                          2
                                                      ? AppColors.black
                                                      : AppColors.black9A9A,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(15.h),
                              selectedIndexNotifier.value == 0
                                  ? UpcomingItemWidget()
                                  : selectedIndexNotifier.value == 1
                                  ? LiveItemWidget()
                                  : GestureDetector(
                                    onTap: () async {
                                      completedIndexNotifier.value++;
                                    },
                                    child: CompletedItemWidget(),
                                  ),
                            ],
                          ),
                        )
                        : PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, result) {
                            if (didPop) {
                              return;
                            }
                            if (completedIndexNotifier.value == 1) {
                              completedIndexNotifier.value--;
                            }
                          },
                          child: ContestWinnerPage(),
                        ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
