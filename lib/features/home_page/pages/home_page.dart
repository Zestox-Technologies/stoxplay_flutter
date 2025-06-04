import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/widgets/contest_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  List list = [Strings.play, Strings.learn];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        forceMaterialTransparency: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(child: Icon(Icons.person, size: 20.h)),
            CommonAppbarTitle(),
            Badge(
              backgroundColor: AppColors.purple661F,
              smallSize: 8,
              alignment: Alignment.topLeft,
              child: Image.asset(
                AppAssets.notificationIcon,
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 220.h,
            child: Image.asset(AppAssets.lightSplashStrokes),
          ),
          SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, selected, _) {
                return Column(
                  children: [
                    Image.asset(
                      AppAssets.carouselImage,
                      height: 150.h,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => Gap(15.w),
                              itemCount: list.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder:
                                  (context, index) => CommonTabWidget(
                                    onTap: () {
                                      selectedIndex.value = index;
                                    },
                                    isSelected: selectedIndex.value == index,
                                    title: list[index],
                                  ),
                            ),
                          ),
                          Gap(15.h),
                          selectedIndex.value == 0
                              ? Column(
                                children: [
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
                                            text: Strings.sectorsPlay,
                                            fontSize: 18.sp,
                                          ).paddingSymmetric(horizontal: 20.w),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(15.h),
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (context, index) => Gap(10.h),
                                    itemCount: contests.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return ContestWidget(
                                        data: contests[index],
                                      );
                                    },
                                  ),
                                ],
                              )
                              : Center(child: Text(Strings.learn)),
                          Gap(10.h),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommonTabWidget extends StatelessWidget {
  final String title;
  bool isSelected;
  VoidCallback onTap;

  CommonTabWidget({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5.w,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF), //
          borderRadius: BorderRadius.circular(12.r), // Background: #FFFFFF
          border: Border.all(
            color:
                isSelected
                    ? AppColors.blue7E.withOpacity(0.5)
                    : AppColors.white70,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue7E.withOpacity(0.25),
              blurRadius: 8.0,
              spreadRadius: 1.0,
              offset: Offset(0, 0), // Position of the shadow
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Text(
              title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
