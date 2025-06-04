import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/leaderboard_page/widgets/leaderboard_item_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/common_bottom_navbar.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class LeaderboardPage extends StatelessWidget {
  LeaderboardPage({super.key});

  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            leading:
                selectedIndex.value == 1
                    ? IconButton(
                      icon: Icon(Icons.arrow_back_ios_new),
                      color: AppColors.black,
                      onPressed: () {
                        selectedIndex.value--;
                      },
                    )
                    : null,
            title: CommonAppbarTitle(),
            centerTitle: true,
            leadingWidth: selectedIndex.value == 0 ? 0 : 40,
            actions: [
              selectedIndex.value == 1
                  ? SizedBox(
                    width:
                        kToolbarHeight, // Match the space of the leading icon
                  )
                  : SizedBox.shrink(),
            ],
          ),
          body: Column(
            children: [
              Container(
                height: 0.5.h,
                width: double.maxFinite,
                color: Colors.grey,
              ),
              selectedIndex.value == 0
                  ? Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          bottom: 200.h,
                          child: Image.asset(AppAssets.lightSplashStrokes),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 1.h,
                              width: double.maxFinite,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 40.h,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Divider(
                                              color: AppColors.black,
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              color: AppColors.white,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                              ),
                                              child: TextView(
                                                text:
                                                    Strings.winnersLeaderboard,
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(10.h),
                                    ListView.separated(
                                      itemCount: 3,
                                      shrinkWrap: true,
                                      separatorBuilder:
                                          (context, index) => Gap(15.h),
                                      itemBuilder:
                                          (context, index) => GestureDetector(
                                            onTap: () {
                                              selectedIndex.value++;
                                            },
                                            child: LeaderboardItemWidget(),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  : Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Gap(10.h),
                              Image.asset(
                                AppAssets.celebrationStarImage,
                                height: 120.h,
                              ),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors.black,
                                  ).paddingTop(5.h),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      color: AppColors.white,
                                      child: TextView(
                                        text: Strings.bankWars,
                                        fontSize: 24.sp,
                                      ).paddingSymmetric(horizontal: 20.w),
                                    ),
                                  ),
                                ],
                              ),
                              TextView(
                                text: Strings.topPerformersInTheMatch,
                                fontSize: 24.sp,
                              ),
                              Gap(10.h),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors
                                      .white, // or your desired background color
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x66000000),
                                  offset: const Offset(0, -3),
                                  blurRadius: 24.7,
                                  spreadRadius: 0, // same as CSS
                                ),
                              ],
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // optional
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 10.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextView(text: "Name"),
                                      Row(
                                        children: [
                                          TextView(text: "Winnings"),
                                          Gap(20.w),
                                          TextView(text: "Points"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 0.5.h,
                                  color: AppColors.black6666,
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder:
                                        (context, index) => Container(
                                          height: 0.5.h,
                                          color: AppColors.black6666,
                                        ),
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 10.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Colors
                                                          .white, // Border color
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors.blue7E
                                                        .withOpacity(0.5),
                                                    width:
                                                        1, // Change border width here
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 20.r,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: ClipOval(
                                                    child: Image.asset(
                                                      AppAssets.bankWars,
                                                      height:
                                                          40, // adjust if needed
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextView(
                                                    text: "Rahul Soni",
                                                    fontSize: 16.sp,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  TextView(
                                                    text: "Winnings-8,10,000",
                                                    fontWeight: FontWeight.w400,
                                                    fontColor:
                                                        AppColors.black46464,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  TextView(text: "15k"),
                                                  Image.asset(
                                                    AppAssets.stoxplayCoin,
                                                    height: 16.h,
                                                    width: 16.w,
                                                  ),
                                                ],
                                              ),
                                              Gap(40.w),
                                              TextView(text: "180"),
                                              Gap(30.w),
                                            ],
                                          ),
                                        ],
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
            ],
          ),
        );
      },
    );
  }
}
