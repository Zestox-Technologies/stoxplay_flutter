part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final ApiStatus apiStatus;
  final NotificationModel? notifications;
  final List<Datum> notificationList;
  final int currentPage;
  final bool hasMoreData;
  final bool isLoadingMore;

  const NotificationState({
    this.apiStatus = ApiStatus.initial,
    this.notifications,
    this.notificationList = const [],
    this.currentPage = 1,
    this.hasMoreData = true,
    this.isLoadingMore = false,
  });

  NotificationState copyWith({
    ApiStatus? apiStatus,
    NotificationModel? notifications,
    List<Datum>? notificationList,
    int? currentPage,
    bool? hasMoreData,
    bool? isLoadingMore,
  }) {
    return NotificationState(
      apiStatus: apiStatus ?? this.apiStatus,
      notifications: notifications ?? this.notifications,
      notificationList: notificationList ?? this.notificationList,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    apiStatus,
    notifications,
    notificationList,
    currentPage,
    hasMoreData,
    isLoadingMore,
  ];
}

