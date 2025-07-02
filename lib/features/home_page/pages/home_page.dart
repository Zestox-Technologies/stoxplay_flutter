import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/widgets/contest_shimmer_widget.dart';
import 'package:stoxplay/features/home_page/widgets/contest_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  HomeCubit homeCubit = HomeCubit(sectorListUseCase: sl(), contestStatusUseCase: sl());

  List list = [Strings.play, Strings.learn];

  @override
  void initState() {
    super.initState();
    homeCubit.getSectorList();
  }

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
              child: Image.asset(AppAssets.notificationIcon, height: 24, width: 24),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(bottom: 220.h, child: Image.asset(AppAssets.lightSplashStrokes)),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Image.asset(AppAssets.carouselImage, height: 150.h, width: MediaQuery.of(context).size.width),
                    Gap(10.h), // Some spacing before the sticky tab
                  ],
                ),
              ),

              // Sticky Tab Bar (Horizontal ListView)
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabDelegate(
                  child: Container(
                    color: AppColors.white, // Important for sticking effect
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: ValueListenableBuilder(
                      valueListenable: selectedIndex,
                      builder: (context, selected, _) {
                        return Row(
                          children: [
                            Expanded(
                              child: CommonTabWidget(
                                onTap: () {
                                  selectedIndex.value = 0;
                                },
                                isSelected: selectedIndex.value == 0,
                                title: Strings.play,
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: CommonTabWidget(
                                onTap: () {
                                  selectedIndex.value = 1;
                                },
                                isSelected: selectedIndex.value == 1,
                                title: Strings.learn,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Content based on selected index
              SliverToBoxAdapter(
                child: ValueListenableBuilder(
                  valueListenable: selectedIndex,
                  builder: (context, selected, _) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        children: [
                          Gap(15.h),
                          selected == 0
                              ? Column(
                                children: [
                                  Stack(
                                    children: [
                                      Divider(color: AppColors.black).paddingTop(5.h),
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
                                  BlocBuilder<HomeCubit, HomeState>(
                                    bloc: homeCubit,
                                    builder: (context, state) {
                                      final isFailed = state.apiStatus.isFailed;
                                      final isLoading = state.apiStatus.isLoading;
                                      final sectorList = state.sectorList ?? [];

                                      if (isFailed) {
                                        return Column(children: [Gap(100.h), Text("No contest found")]);
                                      }

                                      if (isLoading) {
                                        return Column(
                                          children: List.generate(
                                            3,
                                            (index) => Padding(
                                              padding: EdgeInsets.only(bottom: 10.h),
                                              child: const ContestShimmerWidget(),
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: sectorList.length,
                                        separatorBuilder: (context, index) => Gap(10.h),
                                        itemBuilder: (context, index) {
                                          return ContestWidget(data: sectorList[index], cubit: homeCubit);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              )
                              : Center(child: Text(Strings.learn)),
                          Gap(10.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
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

  CommonTabWidget({super.key, required this.onTap, required this.isSelected, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF), //
          borderRadius: BorderRadius.circular(12.r), // Background: #FFFFFF
          border: Border.all(color: isSelected ? AppColors.blue7E.withOpacity(0.5) : AppColors.white70, width: 1.0),
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
            child: Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabDelegate({required this.child});

  @override
  double get minExtent => 50.h;

  @override
  double get maxExtent => 50.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyTabDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
