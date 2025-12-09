import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/notification_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/notification_model.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
    _notificationCubit.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: Column(children: [Expanded(child: _buildNotificationList())]),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextView(text: 'Notifications', fontSize: 20.sp, fontWeight: FontWeight.w600, fontColor: AppColors.black),
      centerTitle: true,
      // actions: [
      //   BlocBuilder<NotificationCubit, NotificationState>(
      //     builder: (context, state) {
      //       if (state.notifications?.data?.isNotEmpty ?? false) {
      //         return PopupMenuButton<String>(
      //           icon: Icon(Icons.more_vert, color: AppColors.black),
      //           onSelected: (value) {
      //             switch (value) {
      //               case 'mark_all_read':
      //                 _notificationCubit.markAllAsRead();
      //                 break;
      //               case 'clear_all':
      //                 _showClearAllDialog();
      //                 break;
      //             }
      //           },
      //           itemBuilder:
      //               (context) => [
      //                 const PopupMenuItem(
      //                   value: 'mark_all_read',
      //                   child: Row(
      //                     children: [Icon(Icons.done_all, size: 20), SizedBox(width: 8), Text('Mark All Read')],
      //                   ),
      //                 ),
      //                 const PopupMenuItem(
      //                   value: 'clear_all',
      //                   child: Row(
      //                     children: [
      //                       Icon(Icons.clear_all, size: 20, color: Colors.red),
      //                       SizedBox(width: 8),
      //                       Text('Clear All', style: TextStyle(color: Colors.red)),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //         );
      //       }
      //       return const SizedBox.shrink();
      //     },
      //   ),
      //   Gap(16.w),
      // ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryPurple.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryPurple, size: 20.sp),
          Gap(8.w),
          Expanded(
            child: TextView(
              text: 'Tap on any notification to mark it as read',
              fontSize: 12.sp,
              fontColor: AppColors.primaryPurple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.apiStatus.isLoading) {
          return _buildShimmerList();
        }

        if (state.apiStatus.isFailed) {
          return _buildErrorState();
        }

        if (state.notificationList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primaryPurple,
          onRefresh: () => _notificationCubit.loadNotifications(refresh: true),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(16.w),
            itemCount: state.notificationList.length + (state.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.notificationList.length) {
                // Load more indicator
                if (state.hasMoreData) {
                  _notificationCubit.loadMoreNotifications();
                  return _buildLoadMoreIndicator();
                }
                return const SizedBox.shrink();
              }

              final notification = state.notificationList[index];
              return _buildNotificationCard(notification, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(Datum notification, int index) {
    final isRead = notification.isRead ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => (!isRead) ? _handleNotificationTap(notification) : null,
          splashColor: AppColors.primaryPurple.withOpacity(0.1),
          highlightColor: AppColors.primaryPurple.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextView(
                              text: notification.title ?? 'StoxPlay',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontColor: AppColors.black,
                              maxLines: 2,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(color: AppColors.primaryPurple, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      Gap(4.h),
                      TextView(
                        text: notification.body ?? '',
                        fontSize: 12.sp,
                        fontColor: AppColors.black6666,
                        maxLines: 3,
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12.sp, color: AppColors.black9999),
                          Gap(4.w),
                          TextView(
                            text: _getTimeAgo(notification.createdAt),
                            fontSize: 11.sp,
                            fontColor: AppColors.black9999,
                          ),
                          const Spacer(),
                          if (!isRead)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.touch_app, size: 10.sp, color: AppColors.primaryPurple),
                                Gap(2.w),
                                TextView(
                                  text: 'Tap to mark read',
                                  fontSize: 9.sp,
                                  fontColor: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(Datum notification) {
    final type = notification.data?.type?.toString().toLowerCase();
    Color backgroundColor;
    IconData iconData;

    if (type?.contains('contest') == true) {
      backgroundColor = AppColors.blue;
      iconData = Icons.emoji_events;
    } else if (type?.contains('leaderboard') == true) {
      backgroundColor = AppColors.orange;
      iconData = Icons.leaderboard;
    } else if (type?.contains('system') == true) {
      backgroundColor = AppColors.red;
      iconData = Icons.info;
    } else if (type?.contains('promotion') == true) {
      backgroundColor = AppColors.primaryPurple;
      iconData = Icons.local_offer;
    } else if (type?.contains('reminder') == true) {
      backgroundColor = AppColors.green;
      iconData = Icons.notifications;
    } else if (type?.contains('withdraw') == true) {
      backgroundColor = AppColors.orange;
      iconData = Icons.account_balance_wallet;
    } else {
      backgroundColor = AppColors.black6666;
      iconData = Icons.notifications_none;
    }

    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(color: backgroundColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
      child: Icon(iconData, color: backgroundColor, size: 20.sp),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20.r)),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16.h, width: double.infinity, color: Colors.grey.shade300),
                  Gap(8.h),
                  Container(height: 12.h, width: double.infinity, color: Colors.grey.shade300),
                  Gap(4.h),
                  Container(height: 12.h, width: 200.w, color: Colors.grey.shade300),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80.sp, color: AppColors.black9999),
          Gap(16.h),
          TextView(
            text: 'No Notifications',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontColor: AppColors.black6666,
          ),
          Gap(8.h),
          TextView(
            text: 'You\'re all caught up! We\'ll notify you when something new arrives.',
            fontSize: 14.sp,
            fontColor: AppColors.black9999,
            textAlign: TextAlign.center,
          ),
          Gap(24.h),
          ElevatedButton.icon(
            onPressed: () => _notificationCubit.loadNotifications(),
            icon: Icon(Icons.refresh, size: 18.sp),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80.sp, color: AppColors.red),
          Gap(16.h),
          TextView(
            text: 'Something went wrong',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontColor: AppColors.black6666,
          ),
          Gap(8.h),
          TextView(
            text: 'Unable to load notifications. Please try again.',
            fontSize: 14.sp,
            fontColor: AppColors.black9999,
            textAlign: TextAlign.center,
          ),
          Gap(24.h),
          ElevatedButton.icon(
            onPressed: () => _notificationCubit.loadNotifications(),
            icon: Icon(Icons.refresh, size: 18.sp),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime? sentTime) {
    if (sentTime == null) return 'Just now';

    final now = DateTime.now();
    final difference = now.difference(sentTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${sentTime.day}/${sentTime.month}/${sentTime.year}';
    }
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Center(child: CircularProgressIndicator(color: AppColors.primaryPurple, strokeWidth: 2)),
    );
  }

  void _handleNotificationTap(Datum notification) {
    _notificationCubit.markAsRead(notification.id ?? '');
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Clear All Notifications'),
            content: Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _notificationCubit.clearAllNotifications();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                child: Text('Clear All'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(Datum notification) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Notification'),
            content: Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _notificationCubit.deleteNotification(notification.id ?? '');
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }
}
