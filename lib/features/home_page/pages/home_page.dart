import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/cubits/notification_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/ads_model.dart';
import 'package:stoxplay/features/home_page/data/models/approve_reject_withdraw_request_params.dart';
import 'package:stoxplay/features/home_page/data/models/most_picked_stock_model.dart';
import 'package:stoxplay/features/home_page/data/models/withdraw_request_model.dart';
import 'package:stoxplay/features/home_page/pages/notification_page.dart';
import 'package:stoxplay/features/home_page/widgets/contest_shimmer_widget.dart';
import 'package:stoxplay/features/home_page/widgets/contest_widget.dart';
import 'package:stoxplay/features/home_page/widgets/learn_list_shimmer.dart';
import 'package:stoxplay/features/home_page/widgets/most_picked_stock_widget.dart';
import 'package:stoxplay/features/home_page/widgets/news_list.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/extensions/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  late HomeCubit homeCubit;
  late ProfileCubit profileCubit;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  List list = [Strings.play, Strings.learn];
  DateTime? _lastUpdateCheck;
  bool _isWithdrawDialogOpen = false;
  bool _didRouteAwareInitialLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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

    // Load cached profile for app bar display (fast loading)
    profileCubit.loadCachedProfile();

    // Load home data with smart caching
    homeCubit.getSectorList();
    homeCubit.getAdsList();
    homeCubit.getMostPickedStock();
    homeCubit.getWithdrawRequest();
    homeCubit.getLearningList(Strings.video, forceRefresh: true);
    // Check for app updates after initial data loading
    _checkForAppUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pageController.dispose();
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure initial APIs also fire when navigating here after signup
    if (!_didRouteAwareInitialLoad && ModalRoute.of(context)?.isCurrent == true) {
      _didRouteAwareInitialLoad = true;
      // Run after first frame to avoid layout jank
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Smart load similar to initState
        profileCubit.loadCachedProfile();
        homeCubit.getSectorList();
        homeCubit.getAdsList();
        homeCubit.getMostPickedStock();
        homeCubit.getWithdrawRequest();
        homeCubit.getLearningList(Strings.video, forceRefresh: true);
        await checkForUpdate();
        _lastUpdateCheck = DateTime.now();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App came to foreground - check for updates if not checked recently
      _checkForUpdateOnResume();
    }
  }

  void showWithdrawDialog(WithdrawRequestModel data) async {
    if (_isWithdrawDialogOpen) return; // Prevent multiple dialogs

    _isWithdrawDialogOpen = true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withAlpha(400),
      builder: (ctx) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              _isWithdrawDialogOpen = false; // Reset flag when dialog is closed
              return;
            }
          },
          canPop: false,
          child: BlocListener<HomeCubit, HomeState>(
            listenWhen: (prev, curr) => prev.approveRejectApiStatus != curr.approveRejectApiStatus,
            listener: (context, state) {
              if (state.approveRejectApiStatus.isSuccess || state.approveRejectApiStatus.isFailed) {
                Navigator.pop(context); // Close when done
                _isWithdrawDialogOpen = false;
              }
            },
            child: Dialog(
              child: BlocSelector<HomeCubit, HomeState, ApiStatus>(
                selector: (state) => state.approveRejectApiStatus,
                builder: (context, state) {
                  return WithdrawDialog(
                    data: data,
                    isLoading: state.isLoading,
                    onApprove: () {
                      homeCubit.approveRejectWithdrawRequest(
                        ApproveRejectWithdrawRequestParams(data.id ?? '', "APPROVED", "Approved"),
                      );
                    },
                    onReject: () {
                      homeCubit.approveRejectWithdrawRequest(
                        ApproveRejectWithdrawRequestParams(data.id ?? '', "REJECTED", "Rejected"),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {}
  }

  Future<void> _checkForAppUpdate() async {
    await Future.delayed(const Duration(seconds: 2));

    // Only check for updates if the widget is still mounted
    if (mounted) {
      await checkForUpdate();
      _lastUpdateCheck = DateTime.now();
    }
  }

  Future<void> _checkForUpdateOnResume() async {
    // Only check for updates if not checked in the last 30 minutes
    if (_lastUpdateCheck == null || DateTime.now().difference(_lastUpdateCheck!).inMinutes > 30) {
      // Wait a bit to ensure app is fully resumed
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        await checkForUpdate();
        _lastUpdateCheck = DateTime.now();
      }
    }
  }

  Future<void> _refreshHomeData() async {
    // Get current selected tab
    final currentTab = selectedIndex.value;

    // Force refresh data based on current tab
    if (currentTab == 0) {
      // Play tab - refresh play-related data
      await Future.wait([
        homeCubit.getSectorList(forceRefresh: true),
        homeCubit.getAdsList(forceRefresh: true),
        homeCubit.getMostPickedStock(forceRefresh: true),
        profileCubit.fetchProfile(forceRefresh: true),
      ]);
    } else {
      // Learn tab - refresh learn-related data
      await Future.wait([
        homeCubit.getLearningList(Strings.video, forceRefresh: true),
        profileCubit.fetchProfile(forceRefresh: true),
      ]);
    }
    homeCubit.getWithdrawRequest();
    // Also check for app updates during manual refresh
    await checkForUpdate();
    _lastUpdateCheck = DateTime.now();
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notificationPage);
              },
              child: Image.asset(AppAssets.notificationIcon, height: 24, width: 24),
            ),
          ],
        ),
      ),
      body: BlocListener<HomeCubit, HomeState>(
        bloc: homeCubit,
        listener: (context, state) {
          // Only show dialog if there are pending withdraw requests and no dialog is already open
          if (state.withdrawRequestModel != null && state.withdrawRequestModel!.isNotEmpty && !_isWithdrawDialogOpen) {
            showWithdrawDialog(state.withdrawRequestModel!.first);
          }
        },
        child: RefreshIndicator(
          color: AppColors.primaryPurple,
          onRefresh: _refreshHomeData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Gap(10.h),
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
                              return Image.network(
                                adsList[index].fileUrl ?? '',
                                width: MediaQuery.of(context).size.width,
                              );
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
                                  // Only call API if learning list is empty or null
                                  if (homeCubit.state.learningList == null || homeCubit.state.learningList!.isEmpty) {
                                    homeCubit.getLearningList(Strings.video);
                                  }
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
                                      final isLoading = state.sectorListApiStatus.isLoading;
                                      final sectorList = state.sectorModel?.sectors ?? [];

                                      if (isLoading) {
                                        return const HomePageShimmer();
                                      }

                                      // if (sectorList.isEmpty) {
                                      //   return Column(children: [Gap(100.h), Text("No contest found")]);
                                      // }

                                      return Column(
                                        children: [
                                          GridView.builder(
                                            itemCount: sectorList.length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio:
                                                  Device.isTablet(context)
                                                      ? 1.5 // Tablet
                                                      : Device.isFoldable(context)
                                                      ? 1.5
                                                      : 0.7,
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
                                            text: 'TOP 5 MOST PICKED STOCKS',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                          ),
                                          Gap(10.h),
                                          BlocBuilder<HomeCubit, HomeState>(
                                            bloc: homeCubit,
                                            builder: (context, state) {
                                              if (state.mostPickedStockApiStatus.isLoading) {
                                                return shimmerStockCard();
                                              }
                                              return ListView.separated(
                                                shrinkWrap: true,
                                                separatorBuilder: (context, index) => Gap(10.h),
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: state.mostPickedStock?.length ?? 0,
                                                itemBuilder: (context, index) {
                                                  final stock = state.mostPickedStock?[index];
                                                  return MostPickedStockWidget(data: stock ?? MostPickedStock());
                                                },
                                              );
                                            },
                                          ),
                                          Gap(50.h),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              )
                              : BlocBuilder<HomeCubit, HomeState>(
                                bloc: homeCubit,
                                builder: (context, state) {
                                  if (state.learningListApiStatus.isLoading) {
                                    return const LearnListShimmer();
                                  }
                                  return LearnList(list: state.learningList ?? []);
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
        ),
      ),
    );
  }

  Widget shimmerStockCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.green38EE.withOpacity(0.2),
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
                // Circle shimmer
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade400),
                ),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 100.w, height: 16.h, color: Colors.grey.shade400),
                    SizedBox(height: 6.h),
                    Container(width: 60.w, height: 12.h, color: Colors.grey.shade400),
                  ],
                ),
              ],
            ),
            // Right side shimmer text
            Container(width: 80.w, height: 16.h, color: Colors.grey.shade400),
          ],
        ),
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
  final WithdrawRequestModel data;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool isLoading;

  const WithdrawDialog({
    super.key,
    required this.data,
    required this.onApprove,
    required this.onReject,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_balance_wallet, size: 48, color: AppColors.primaryPurple),
          const SizedBox(height: 16),
          Text("Redeem Request", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Text(
            "Do you want to withdraw ${data.amount ?? 0} coins?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 24),
          if (isLoading)
            CircularProgressIndicator()
          else
            Row(
              children: [
                Expanded(child: AppButton(text: "Reject", onPressed: onReject, backgroundColor: AppColors.red)),
                const SizedBox(width: 12),
                Expanded(child: AppButton(text: "Approve", onPressed: onApprove, backgroundColor: AppColors.green)),
              ],
            ),
          Gap(10.h),
          Text(
            "You can make only one withdrawal request per day.",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            "For your security, we recommend saving a screenshot of this confirmation.",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
