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
    return ValueListenableBuilder(
      valueListenable: completedIndexNotifier,
      builder: (context, completeIndex, _) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }
            if (completedIndexNotifier.value == 1) {
              completedIndexNotifier.value--;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              // prevent default leading behavior
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (completedIndexNotifier.value == 1) ...[
                    const SizedBox(width: 0), // space to balance the back button
                  ],
                  Expanded(child: Center(child: CommonAppbarTitle())),
                  if (completedIndexNotifier.value == 1) ...[
                    const SizedBox(width: 48), // matching the left space
                  ],
                ],
              ),
              leading:
                  completedIndexNotifier.value == 1
                      ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: AppColors.black,
                        onPressed: () {
                          completedIndexNotifier.value--;
                        },
                      )
                      : null,
            ),

            body: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (context, selectedIndex, _) {
                return Column(
                  children: [
                    Container(height: 1.h, width: double.maxFinite, color: Colors.grey),
                    Gap(15.h),
                    completedIndexNotifier.value == 0
                        ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
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
                                                    selectedIndexNotifier.value == 0
                                                        ? AppColors.white
                                                        : AppColors.black,
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
                                                    selectedIndexNotifier.value == 1
                                                        ? AppColors.white
                                                        : AppColors.black,
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
                                                    selectedIndexNotifier.value == 2
                                                        ? AppColors.white
                                                        : AppColors.black,
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
            ),
          ),
        );
      },
    );
  }
}
