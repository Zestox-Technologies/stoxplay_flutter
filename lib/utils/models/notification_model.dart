import 'package:firebase_messaging/firebase_messaging.dart';

/// Model class for notification data
class NotificationModel {
  final String? title;
  final String? body;
  final String? imageUrl;
  final Map<String, dynamic> data;
  final String? messageId;
  final DateTime? sentTime;

  const NotificationModel({
    this.title,
    this.body,
    this.imageUrl,
    this.data = const {},
    this.messageId,
    this.sentTime,
  });

  /// Create NotificationModel from RemoteMessage
  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      title: message.notification?.title,
      body: message.notification?.body,
      imageUrl: message.notification?.android?.imageUrl ?? 
               message.notification?.apple?.imageUrl,
      data: message.data,
      messageId: message.messageId,
      sentTime: DateTime.fromMillisecondsSinceEpoch(
        message.sentTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Create NotificationModel from local notification payload
  factory NotificationModel.fromLocalNotification(Map<String, dynamic> payload) {
    return NotificationModel(
      title: payload['title'],
      body: payload['body'],
      imageUrl: payload['imageUrl'],
      data: payload['data'] ?? {},
      messageId: payload['messageId'],
      sentTime: payload['sentTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(payload['sentTime'])
          : DateTime.now(),
    );
  }

  /// Convert to Map for local storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'data': data,
      'messageId': messageId,
      'sentTime': sentTime?.millisecondsSinceEpoch,
    };
  }

  /// Create from Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      body: map['body'],
      imageUrl: map['imageUrl'],
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      messageId: map['messageId'],
      sentTime: map['sentTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['sentTime'])
          : null,
    );
  }

  /// Get notification type from data
  String? get notificationType => data['type'];

  /// Get action from data
  String? get action => data['action'];

  /// Get target screen from data
  String? get targetScreen => data['screen'];

  /// Get contest ID if it's a contest notification
  String? get contestId => data['contest_id'];

  /// Get user ID if it's a user-specific notification
  String? get userId => data['user_id'];

  @override
  String toString() {
    return 'NotificationModel(title: $title, body: $body, data: $data, messageId: $messageId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.messageId == messageId;
  }

  @override
  int get hashCode => messageId.hashCode;
}

/// Notification types enum
enum NotificationType {
  contest,
  leaderboard,
  general,
  system,
  promotion,
  reminder,
}

/// Notification action types
enum NotificationAction {
  openApp,
  openContest,
  openLeaderboard,
  openProfile,
  openSettings,
  openUrl,
  custom,
}

/// Extension to get string values
extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.contest:
        return 'contest';
      case NotificationType.leaderboard:
        return 'leaderboard';
      case NotificationType.general:
        return 'general';
      case NotificationType.system:
        return 'system';
      case NotificationType.promotion:
        return 'promotion';
      case NotificationType.reminder:
        return 'reminder';
    }
  }
}

extension NotificationActionExtension on NotificationAction {
  String get value {
    switch (this) {
      case NotificationAction.openApp:
        return 'open_app';
      case NotificationAction.openContest:
        return 'open_contest';
      case NotificationAction.openLeaderboard:
        return 'open_leaderboard';
      case NotificationAction.openProfile:
        return 'open_profile';
      case NotificationAction.openSettings:
        return 'open_settings';
      case NotificationAction.openUrl:
        return 'open_url';
      case NotificationAction.custom:
        return 'custom';
    }
  }
}
