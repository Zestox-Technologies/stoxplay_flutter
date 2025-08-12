import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/widgets/contest_details_widget.dart';
import 'package:stoxplay/features/home_page/widgets/contest_shimmer_widget.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
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
  late SectorModel contest;
  late HomeCubit cubit;
  late ProfileCubit profileCubit;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final data = ModalRoute.of(context)!.settings.arguments as SectorModel;
      contest = data;
      cubit = BlocProvider.of<HomeCubit>(context);
      cubit.getContestList(contest.id.toString());
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    profileCubit.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
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
        ),
        body: Column(
          children: [
            Divider(color: AppColors.black.withOpacity(0.25)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      Strings.indianStockMarketChampionship,
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    Gap(10.h),
                    CachedImageWidget(imageUrl: contest.sectorLogo, height: 100.h, width: 100.w, fit: BoxFit.cover),
                    Gap(10.h),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      bloc: profileCubit,
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextView(text: state.profileModel?.walletBalance.toString() ?? '0', fontSize: 16.sp),
                            Gap(5.w),
                            Image.asset(AppAssets.stoxplayCoin, height: 20.h, width: 20.w),
                          ],
                        );
                      },
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
                                  text: contest.name.toString(),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ).paddingSymmetric(horizontal: 10.w),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16.w),
                    Gap(20.h),
                    BlocBuilder<HomeCubit, HomeState>(
                      bloc: cubit,
                      builder: (context, state) {
                        final isSuccess = state.apiStatus.isSuccess;
                        final isLoading = state.apiStatus.isLoading;

                        if (isLoading) {
                          return Column(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: const ContestDetailsCardShimmer(),
                              ),
                            ),
                          );
                        } else {
                          return state.contestList!.isEmpty
                              ? Center(child: Text("There are no contest available"))
                              : RefreshIndicator(
                                onRefresh: () async {
                                  // await cubit.getContestList(contest.id.toString());
                                },
                                child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) => Gap(15.h),
                                  itemCount: state.contestList!.length,
                                  itemBuilder: (context, index) {
                                    return ContestDetailsWidget(
                                      ignoreOnTap: false,
                                      data: state.contestList![index],
                                    ).paddingSymmetric(horizontal: 20.w);
                                  },
                                ),
                              );
                        }
                      },
                    ),
                    Gap(10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
