import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/data/models/notification_model.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationUseCase notificationUseCase;
  MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  NotificationCubit({
    required this.notificationUseCase,
    required this.markNotificationAsReadUseCase,
  }) : super(NotificationState());

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      emit(state.copyWith(apiStatus: ApiStatus.loading, currentPage: 1));
    } else {
      emit(state.copyWith(apiStatus: ApiStatus.loading));
    }

    try {
      final params = {
        'page': refresh ? 1 : state.currentPage,
        'limit': 10,
      };

      final response = await notificationUseCase.call(params);
      
      response.fold(
        (error) {
          print("error-->$error");
          emit(state.copyWith(apiStatus: ApiStatus.failed));
        },
        (notificationModel) {
          final notifications = notificationModel.data ?? [];
          final meta = notificationModel.meta;
          
          emit(
            state.copyWith(
              apiStatus: ApiStatus.success,
              notifications: notificationModel,
              notificationList: refresh ? notifications : [...state.notificationList, ...notifications],
              currentPage: meta?.page ?? 1,
              hasMoreData: (meta?.page ?? 1) < (meta?.totalPages ?? 1),
            ),
          );
        },
      );
    } catch (e) {
      print("error-->$e");
      emit(state.copyWith(apiStatus: ApiStatus.failed));
    }
  }

  Future<void> loadMoreNotifications() async {
    if (!state.hasMoreData || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final params = {
        'page': state.currentPage + 1,
        'limit': 10,
      };

      final response = await notificationUseCase.call(params);
      
      response.fold(
        (error) {
          emit(state.copyWith(isLoadingMore: false));
        },
        (notificationModel) {
          final notifications = notificationModel.data ?? [];
          final meta = notificationModel.meta;
          
          emit(
            state.copyWith(
              notificationList: [...state.notificationList, ...notifications],
              currentPage: meta?.page ?? state.currentPage,
              hasMoreData: (meta?.page ?? state.currentPage) < (meta?.totalPages ?? 1),
              isLoadingMore: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void filterNotifications(String filter) {
    List<Datum> filtered = state.notificationList;

    if (filter != 'All') {
      filtered = state.notificationList.where((notification) {
        final type = notification.data?.type?.toString().toLowerCase();
        switch (filter) {
          case 'Contest':
            return type?.contains('contest') == true;
          case 'Leaderboard':
            return type?.contains('leaderboard') == true;
          case 'System':
            return type?.contains('system') == true;
          case 'Promotion':
            return type?.contains('promotion') == true;
          case 'Reminder':
            return type?.contains('reminder') == true;
          case 'Withdraw':
            return type?.contains('withdraw') == true;
          default:
            return true;
        }
      }).toList();
    }

    emit(state.copyWith(notificationList: filtered));
  }

  Future<void> markAsRead(String messageId) async {
    try {
      // Call API to mark notification as read
      final response = await markNotificationAsReadUseCase.call(messageId);
      
      response.fold(
        (error) {
          print("Error marking notification as read: $error");
          Fluttertoast.showToast(msg: "Failed to mark notification as read");
        },
        (success) {
          // Update local state
          final updatedFiltered = state.notificationList.map((notification) {
            if (notification.id == messageId) {
              return Datum(
                id: notification.id,
                userId: notification.userId,
                title: notification.title,
                body: notification.body,
                data: notification.data,
                isRead: true,
                createdAt: notification.createdAt,
                updatedAt: notification.updatedAt,
              );
            }
            return notification;
          }).toList();

          emit(state.copyWith(notificationList: updatedFiltered));
          Fluttertoast.showToast(msg: "Notification marked as read");
        },
      );
    } catch (e) {
      print("Exception marking notification as read: $e");
      Fluttertoast.showToast(msg: "Failed to mark notification as read");
    }
  }

  void markAllAsRead() {
    final updatedFiltered = state.notificationList.map((notification) {
      return Datum(
        id: notification.id,
        userId: notification.userId,
        title: notification.title,
        body: notification.body,
        data: notification.data,
        isRead: true,
        createdAt: notification.createdAt,
        updatedAt: notification.updatedAt,
      );
    }).toList();

    emit(state.copyWith(notificationList: updatedFiltered));

    Fluttertoast.showToast(msg: "All notifications marked as read");
  }

  void deleteNotification(String messageId) {
    final updatedFiltered = state.notificationList.where((notification) {
      return notification.id != messageId;
    }).toList();

    emit(state.copyWith(notificationList: updatedFiltered));

    Fluttertoast.showToast(msg: "Notification deleted");
  }

  void clearAllNotifications() {
    emit(state.copyWith(notifications: null, notificationList: []));

    Fluttertoast.showToast(msg: "All notifications cleared");
  }

  void refreshNotifications() {
    loadNotifications(refresh: true);
  }
}
