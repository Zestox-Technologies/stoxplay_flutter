import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/ads_model.dart';
import 'package:stoxplay/features/home_page/widgets/contest_shimmer_widget.dart';
import 'package:stoxplay/features/home_page/widgets/contest_widget.dart';
import 'package:stoxplay/features/home_page/widgets/news_list.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  late HomeCubit homeCubit;
  late ProfileCubit profileCubit;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  List list = [Strings.play, Strings.learn];

  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    _pageController = PageController(viewportFraction: 1);

    // Auto-scroll every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (homeCubit.state.adsList == null || homeCubit.state.adsList!.isEmpty) return;

      if (_currentPage < (homeCubit.state.adsList!.length - 1)) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
    profileCubit.fetchProfile();
    homeCubit.getSectorList();
    homeCubit.getAdsList();
  }

  void showWithdrawDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: WithdrawDialog());
      },
    );
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
            BlocSelector<ProfileCubit, ProfileState, String>(
              bloc: profileCubit,
              selector: (state) => state.profileModel?.profilePictureUrl ?? '',
              builder: (context, pic) {
                if (pic.toLowerCase().endsWith('.svg')) {
                  return CircleAvatar(
                    radius: 25.r,
                    backgroundColor: AppColors.white,
                    child: ClipOval(
                      child: SVGImageWidget(imageUrl: pic, errorWidget: Image.asset(AppAssets.profileIcon)),
                    ),
                  );
                }
                return CircleAvatar(
                  radius: 18.r,
                  backgroundImage: pic != "" ? NetworkImage(pic) : null,
                  child: pic != "" ? null : Icon(Icons.person, size: 25.h),
                );
              },
            ),
            CommonAppbarTitle(),
            Badge(
              backgroundColor: AppColors.primaryPurple,
              smallSize: 8,
              alignment: Alignment.topLeft,
              child: Image.asset(AppAssets.notificationIcon, height: 24, width: 24),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                BlocSelector<HomeCubit, HomeState, List<AdsModel>>(
                  bloc: homeCubit,
                  selector: (state) => state.adsList ?? [],
                  builder: (context, adsList) {
                    return SizedBox(
                      height: 150.h,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: adsList.length,
                        itemBuilder: (context, index) {
                          return Image.network(adsList[index].fileUrl ?? '', width: MediaQuery.of(context).size.width);
                        },
                      ),
                    );
                  },
                ),
                Gap(10.h), // Some spacing before the sticky tab
              ],
            ),
          ),

          // Sticky Tab Bar (Horizontal ListView)
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabDelegate(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white, // Important for sticking effect
                  border: Border.all(color: AppColors.blue7E.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
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
                              homeCubit.getLearningList(Strings.video);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  final isLoading = state.apiStatus.isLoading;
                                  final sectorList = state.sectorModel?.sectors ?? [];

                                  if (isLoading) {
                                    return const HomePageShimmer();
                                  }

                                  if (sectorList.isEmpty) {
                                    return Column(children: [Gap(100.h), Text("No contest found")]);
                                  }

                                  return Column(
                                    children: [
                                      GridView.builder(
                                        itemCount: sectorList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.7,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                        ),
                                        itemBuilder: (context, index) {
                                          return ContestWidget(
                                            data: sectorList[index],
                                            cubit: homeCubit,
                                            nextMatchDate: state.sectorModel?.nextMatchDate ?? '',
                                          );
                                        },
                                      ),
                                      Gap(20.h),
                                      TextView(
                                        text: 'MOST PICKED STOCKS',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                      Gap(10.h),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.green38EE.withOpacity(0.5),
                                              offset: const Offset(0, 0),
                                              blurRadius: 1,
                                              spreadRadius: 0.5,
                                            ),
                                          ],
                                          border: Border.all(color: AppColors.green9FFF, width: 0.5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 35.h,
                                                  width: 35.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: AppColors.black6767, width: 0.5),
                                                  ),
                                                  child: Image.asset(AppAssets.appIcon),
                                                ),
                                                SizedBox(width: 15.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextView(
                                                      text: 'HDFC BANK',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16.sp,
                                                    ),
                                                    TextView(
                                                      text: '₹1340 (-1.05%) ',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            TextView(
                                              text: 'Bank Wars',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.sp,
                                              fontColor: AppColors.primaryPurple,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(100.h),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )
                          : BlocBuilder<HomeCubit, HomeState>(
                            bloc: homeCubit,
                            builder: (context, state) {
                              return NewsList(list: state.learningList ?? []);
                            },
                          ),
                    ],
                  ),
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

  CommonTabWidget({super.key, required this.onTap, required this.isSelected, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : AppColors.white, // Background:, //
          borderRadius: BorderRadius.circular(999.r), // Background: #FFFFFF
          border: Border.all(color: isSelected ? AppColors.black6767 : AppColors.primaryPurple, width: 1.0),
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
            padding: EdgeInsets.symmetric(vertical: 0.h),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Sofia Sans',
                fontWeight: FontWeight.w600,
                // 600 = SemiBold
                fontStyle: FontStyle.normal,
                // SemiBold is handled via fontWeight
                fontSize: 16,
                color: isSelected ? AppColors.white : AppColors.primaryPurple,
                height: 26 / 16,
                // line-height divided by font-size
                letterSpacing: 0.0,
                textBaseline: TextBaseline.alphabetic, // vertical-align: middle approximation
              ),
            ),
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

class WithdrawDialog extends StatelessWidget {
  const WithdrawDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [Text("Do you want to withdraw 10,000 coins?")]));
  }
}
