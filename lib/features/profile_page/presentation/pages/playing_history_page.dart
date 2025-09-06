import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/utils/common/widgets/common_back_button.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class PlayingHistoryPage extends StatefulWidget {
  const PlayingHistoryPage({super.key});

  @override
  State<PlayingHistoryPage> createState() => _PlayingHistoryPageState();
}

class _PlayingHistoryPageState extends State<PlayingHistoryPage> {
  static const int _limit = 10;
  late final ProfileCubit _profileCubit;
  bool _ownsCubit = false;
  int _page = 1;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    try {
      _profileCubit = BlocProvider.of<ProfileCubit>(context);
    } catch (_) {
      _profileCubit = ProfileCubit(sl(), sl(), sl(), sl());
      _ownsCubit = true;
    }
    _fetchData();
  }

  void _fetchData() {
    _profileCubit.getPlayingHistory(page: _page, limit: _limit);
  }

  void _loadMore() {
    if (_isFetchingMore) return;
    _isFetchingMore = true;
    _page++;
    _profileCubit.getPlayingHistory(page: _page, limit: _limit).whenComplete(() {
      _isFetchingMore = false;
    });
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _profileCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>.value(
      value: _profileCubit,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    CommonBackButton(onTap: () => Navigator.pop(context)),
                    Gap(16.w),
                    Expanded(
                      child: TextView(
                        text: "Playing History",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gap(56.w),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final items = state.playingHistory?.data ?? [];

                      if (state.apiStatus.isLoading && items.isEmpty) {
                        return Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
                      }

                      if (items.isEmpty) {
                        return Center(child: Text('No history found'));
                      }

                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.9 &&
                              !_isFetchingMore &&
                              !state.apiStatus.isLoading) {
                            if ((state.playingHistory?.meta?.totalPages ?? 0) >= _page) {
                              return true;
                            }
                            _loadMore();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: items.length + (state.apiStatus.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= items.length) {
                              // Loader at bottom while fetching more
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)),
                              );
                            }

                            final item = items[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _GameHistoryCard(
                                title: item.contest?.name ?? item.name ?? '-',
                                date: '',
                                rank: item.rank ?? 0,
                                score: (item.points ?? 0).toStringAsFixed(2),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameHistoryCard extends StatelessWidget {
  final String title;
  final String date;
  final int rank;
  final String score;

  const _GameHistoryCard({required this.title, required this.date, required this.rank, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteF9F9,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.blackD7D7, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(text: title, fontSize: 16.sp, fontWeight: FontWeight.w700, fontColor: AppColors.purple5A2F),
                Gap(4.h),
                TextView(text: date.isNotEmpty ? "Date: $date" : '', fontSize: 12.sp, fontColor: AppColors.black9999),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextView(text: "Rank: #$rank", fontSize: 14.sp, fontWeight: FontWeight.w600),
              Gap(4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.stoxplayCoin, height: 16.h, width: 16.w),
                  Gap(4.w),
                  TextView(text: "$score", fontSize: 14.sp, fontWeight: FontWeight.w600),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
