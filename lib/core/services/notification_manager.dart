import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:stoxplay/core/services/fcm_service.dart';
import 'package:stoxplay/utils/common/functions/notification_utils.dart';
import 'package:stoxplay/utils/models/notification_model.dart';

/// Manager class for handling all notification-related operations
class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FCMService _fcmService = FCMService();
  final List<NotificationModel> _notifications = [];

  /// Get all notifications
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  /// Get FCM token
  String? get fcmToken => _fcmService.fcmToken;

  /// Initialize notification manager
  Future<void> initialize() async {
    try {
      // Check if app was opened from notification
      final wasOpenedFromNotification = await _fcmService.wasAppOpenedFromNotification();
      if (wasOpenedFromNotification) {
        final initialMessage = await _fcmService.getInitialMessage();
        if (initialMessage != null) {
          await _handleInitialNotification(initialMessage);
        }
      }

      if (kDebugMode) {
        print('Notification Manager initialized');
        print('FCM Token: $fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Notification Manager: $e');
      }
    }
  }

  /// Handle initial notification when app is opened from notification
  Future<void> _handleInitialNotification(RemoteMessage message) async {
    final notification = NotificationModel.fromRemoteMessage(message);
    if (NotificationUtils.isValidNotification(notification)) {
      _notifications.insert(0, notification);
      await _handleNotificationNavigation(notification);
    }
  }

  /// Handle notification navigation
  Future<void> _handleNotificationNavigation(NotificationModel notification) async {
    try {
      final action = NotificationUtils.parseNotificationAction(notification.action);
      final targetScreen = notification.targetScreen;
      
      if (kDebugMode) {
        print('Handling notification navigation: $action, screen: $targetScreen');
      }

      // TODO: Implement navigation logic based on notification data
      // Example implementation:
      switch (action) {
        case NotificationAction.openContest:
          if (notification.contestId != null) {
            // Navigate to specific contest
            // NavigationService.navigateToContest(notification.contestId!);
          }
          break;
        case NotificationAction.openLeaderboard:
          // Navigate to leaderboard
          // NavigationService.navigateToLeaderboard();
          break;
        case NotificationAction.openProfile:
          // Navigate to profile
          // NavigationService.navigateToProfile();
          break;
        case NotificationAction.openSettings:
          // Navigate to settings
          // NavigationService.navigateToSettings();
          break;
        case NotificationAction.openUrl:
          final url = notification.data['url'];
          if (url != null) {
            // Open URL
            // UrlLauncher.launchUrl(Uri.parse(url));
          }
          break;
        default:
          // Default action - just open the app
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling notification navigation: $e');
      }
    }
  }

  /// Subscribe to notification topics
  Future<void> subscribeToTopics(List<String> topics) async {
    for (final topic in topics) {
      await _fcmService.subscribeToTopic(topic);
    }
  }

  /// Unsubscribe from notification topics
  Future<void> unsubscribeFromTopics(List<String> topics) async {
    for (final topic in topics) {
      await _fcmService.unsubscribeFromTopic(topic);
    }
  }

  /// Subscribe to user-specific topics
  Future<void> subscribeToUserTopics(String userId) async {
    final topics = [
      'user_$userId',
      'general',
      'contests',
      'leaderboard',
    ];
    await subscribeToTopics(topics);
  }

  /// Unsubscribe from user-specific topics
  Future<void> unsubscribeFromUserTopics(String userId) async {
    final topics = [
      'user_$userId',
      'general',
      'contests',
      'leaderboard',
    ];
    await unsubscribeFromTopics(topics);
  }

  /// Get notification count
  int get notificationCount => _notifications.length;

  /// Get unread notification count
  int get unreadNotificationCount {
    // TODO: Implement unread tracking logic
    return _notifications.length;
  }

  /// Mark notification as read
  void markNotificationAsRead(String messageId) {
    // TODO: Implement read status tracking
    if (kDebugMode) {
      print('Marking notification as read: $messageId');
    }
  }

  /// Mark all notifications as read
  void markAllNotificationsAsRead() {
    // TODO: Implement read status tracking
    if (kDebugMode) {
      print('Marking all notifications as read');
    }
  }

  /// Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    if (kDebugMode) {
      print('All notifications cleared');
    }
  }

  /// Clear expired notifications
  void clearExpiredNotifications({Duration? expiryDuration}) {
    _notifications.removeWhere((notification) {
      return NotificationUtils.isNotificationExpired(notification, expiryDuration: expiryDuration);
    });
  }

  /// Get notifications by type
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((notification) {
      return notification.notificationType == type.value;
    }).toList();
  }

  /// Get recent notifications (last 24 hours)
  List<NotificationModel> getRecentNotifications() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    return _notifications.where((notification) {
      final sentTime = notification.sentTime ?? now;
      return sentTime.isAfter(yesterday);
    }).toList();
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    // TODO: Implement notification settings check
    return true;
  }

  /// Enable/disable notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    // TODO: Implement notification settings
    if (kDebugMode) {
      print('Notifications ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Get notification settings
  Map<String, bool> getNotificationSettings() {
    // TODO: Implement notification settings
    return {
      'general': true,
      'contests': true,
      'leaderboard': true,
      'promotions': false,
      'reminders': true,
    };
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(Map<String, bool> settings) async {
    // TODO: Implement notification settings update
    if (kDebugMode) {
      print('Notification settings updated: $settings');
    }
  }

  /// Send FCM token to server
  Future<void> sendTokenToServer() async {
    if (fcmToken != null) {
      // TODO: Implement API call to send token to server
      if (kDebugMode) {
        print('Sending FCM token to server: $fcmToken');
      }
    }
  }

  /// Refresh FCM token
  Future<String?> refreshFCMToken() async {
    try {
      // The FCM service will automatically handle token refresh
      // This method can be used to force a refresh if needed
      return _fcmService.fcmToken;
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing FCM token: $e');
      }
      return null;
    }
  }

  /// Clear FCM token
  Future<void> clearFCMToken() async {
    await _fcmService.clearFCMToken();
  }

  /// Dispose resources
  void dispose() {
    _fcmService.dispose();
  }
}
