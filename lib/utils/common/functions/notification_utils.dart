import 'package:flutter/foundation.dart';
import 'package:stoxplay/utils/models/notification_model.dart';

/// Utility class for notification-related operations
class NotificationUtils {
  NotificationUtils._();

  /// Parse notification type from string
  static NotificationType? parseNotificationType(String? type) {
    if (type == null) return null;
    
    switch (type.toLowerCase()) {
      case 'contest':
        return NotificationType.contest;
      case 'leaderboard':
        return NotificationType.leaderboard;
      case 'general':
        return NotificationType.general;
      case 'system':
        return NotificationType.system;
      case 'promotion':
        return NotificationType.promotion;
      case 'reminder':
        return NotificationType.reminder;
      default:
        return NotificationType.general;
    }
  }

  /// Parse notification action from string
  static NotificationAction? parseNotificationAction(String? action) {
    if (action == null) return null;
    
    switch (action.toLowerCase()) {
      case 'open_app':
        return NotificationAction.openApp;
      case 'open_contest':
        return NotificationAction.openContest;
      case 'open_leaderboard':
        return NotificationAction.openLeaderboard;
      case 'open_profile':
        return NotificationAction.openProfile;
      case 'open_settings':
        return NotificationAction.openSettings;
      case 'open_url':
        return NotificationAction.openUrl;
      case 'custom':
        return NotificationAction.custom;
      default:
        return NotificationAction.openApp;
    }
  }

  /// Check if notification should be shown based on app state
  static bool shouldShowNotification(NotificationModel notification) {
    // Add your logic here to determine if notification should be shown
    // For example, don't show notifications for certain types when user is in specific screens
    
    if (notification.notificationType == 'system') {
      return true; // Always show system notifications
    }
    
    // Add more conditions as needed
    return true;
  }

  /// Get notification priority based on type
  static int getNotificationPriority(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return 1; // Highest priority
      case NotificationType.contest:
        return 2;
      case NotificationType.leaderboard:
        return 3;
      case NotificationType.reminder:
        return 4;
      case NotificationType.promotion:
        return 5;
      case NotificationType.general:
        return 6; // Lowest priority
    }
  }

  /// Format notification title for display
  static String formatNotificationTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'StoxPlay';
    }
    return title;
  }

  /// Format notification body for display
  static String formatNotificationBody(String? body) {
    if (body == null || body.isEmpty) {
      return 'You have a new notification';
    }
    return body;
  }

  /// Check if notification is expired
  static bool isNotificationExpired(NotificationModel notification, {Duration? expiryDuration}) {
    final expiry = expiryDuration ?? const Duration(days: 7);
    final now = DateTime.now();
    final notificationTime = notification.sentTime ?? now;
    
    return now.difference(notificationTime) > expiry;
  }

  /// Get notification display time
  static String getNotificationDisplayTime(DateTime? sentTime) {
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

  /// Validate notification data
  static bool isValidNotification(NotificationModel notification) {
    // Check if required fields are present
    if (notification.title == null && notification.body == null) {
      if (kDebugMode) {
        print('Invalid notification: Missing title and body');
      }
      return false;
    }
    
    // Check if message ID is present
    if (notification.messageId == null || notification.messageId!.isEmpty) {
      if (kDebugMode) {
        print('Invalid notification: Missing message ID');
      }
      return false;
    }
    
    return true;
  }

  /// Get notification category for analytics
  static String getNotificationCategory(NotificationModel notification) {
    final type = notification.notificationType;
    if (type == null) return 'unknown';
    
    switch (type) {
      case 'contest':
        return 'engagement';
      case 'leaderboard':
        return 'social';
      case 'system':
        return 'system';
      case 'promotion':
        return 'marketing';
      case 'reminder':
        return 'retention';
      default:
        return 'general';
    }
  }

  /// Check if notification should trigger sound
  static bool shouldPlaySound(NotificationModel notification) {
    // Don't play sound for system notifications during quiet hours
    if (notification.notificationType == 'system') {
      final now = DateTime.now();
      final hour = now.hour;
      
      // Quiet hours: 10 PM to 8 AM
      if (hour >= 22 || hour < 8) {
        return false;
      }
    }
    
    return true;
  }

  /// Check if notification should vibrate
  static bool shouldVibrate(NotificationModel notification) {
    // Only vibrate for important notifications
    final importantTypes = ['contest', 'system', 'reminder'];
    return importantTypes.contains(notification.notificationType);
  }
}
