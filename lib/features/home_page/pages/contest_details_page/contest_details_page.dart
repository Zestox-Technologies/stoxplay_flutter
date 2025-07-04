import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/widgets/contest_details_widget.dart';
import 'package:stoxplay/features/leaderboard_page/pages/leaderboard_page.dart';
import 'package:stoxplay/features/profile_page/pages/profile_page.dart';
import 'package:stoxplay/features/stats_page/pages/stats_page.dart';
import 'package:stoxplay/utils/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/common_bottom_navbar.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class ContestDetailsPage extends StatefulWidget {
  const ContestDetailsPage({super.key});

  @override
  State<ContestDetailsPage> createState() => _ContestDetailsPageState();
}

class _ContestDetailsPageState extends State<ContestDetailsPage> {
  late ContestStaticModel contest;
  late HomeCubit cubit;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final data = ModalRoute.of(context)!.settings.arguments as (ContestStaticModel, HomeCubit);
      contest = data.$1;
      cubit = data.$2;

      cubit.getContestList('7bafc858-ffb0-452a-840c-f0a0e24a9a5f');
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: NavigationState().currentIndex,
      builder: (context, selectedIndex, _) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pop(context);
          },
          child: Scaffold(
            appBar:
                selectedIndex == 0
                    ? AppBar(
                      forceMaterialTransparency: true,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new),
                        color: AppColors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: CommonAppbarTitle(),
                      centerTitle: true,
                      backgroundColor: AppColors.white,
                      actions: [
                        SizedBox(
                          width: kToolbarHeight, // Match the space of the leading icon
                        ),
                      ],
                    )
                    : null,
            body: Column(
              children: [
                selectedIndex == 0 ? Divider(color: AppColors.black.withOpacity(0.25)) : SizedBox.shrink(),
                Expanded(
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: selectedIndex,
                        children: [
                          SingleChildScrollView(
                            child: Stack(
                              children: [
                                Positioned(child: Image.asset(AppAssets.lightSplashStrokes)),
                                Column(
                                  children: [
                                    Text(
                                      Strings.indianStockMarketChampionship,
                                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                                    ),
                                    Gap(10.h),
                                    Image.asset(contest.image, height: 100.h, width: 100.w),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AppAssets.stoxplayCoin, height: 40.h, width: 40.w),
                                        TextView(text: '1700', fontSize: 16.sp),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Positioned.fill(child: Divider(color: AppColors.black)),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                color: AppColors.white,
                                                child: TextView(
                                                  text: contest.title,
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                ).paddingSymmetric(horizontal: 10.w),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 24.w),
                                    Gap(20.h),
                                    ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) => Gap(15.h),
                                      itemCount: contest.contestPriceList.length,
                                      itemBuilder: (context, index) {
                                        return ContestDetailsWidget(
                                          ignoreOnTap: false,
                                          data: contest.contestPriceList[index],
                                        ).paddingSymmetric(horizontal: 20.w);
                                      },
                                    ),
                                    Gap(10.h),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          StatsPage(),
                          LeaderboardPage(),
                          ProfilePage(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavbar(),
          ),
        );
      },
    );
  }
}
