import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

/// FCM Service class to handle all Firebase Cloud Messaging operations
class FCMService {
  static final FCMService _instance = FCMService._internal();

  factory FCMService() => _instance;

  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _backgroundMessageSubscription;

  /// Get the current FCM token
  String? get fcmToken => _fcmToken;

  /// Initialize FCM service
  Future<void> initialize() async {
    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request permission for notifications
      await _requestPermission();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      await _setupMessageHandlers();

      // Listen for token refresh
      _listenToTokenRefresh();

      if (kDebugMode) {
        print('FCM Service initialized successfully');
        print('FCM Token: $_fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM Service: $e');
      }
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Request notification permission
  Future<bool> _requestPermission() async {
    if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } else if (Platform.isAndroid) {
      final settings = await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  /// Get FCM token
  Future<String?> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        // Store token in local storage
        await StorageService().write(DBKeys.fcmToken, _fcmToken!);
        if (kDebugMode) {
          print('FCM Token obtained: $_fcmToken');
        }
      }
      return _fcmToken;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
      return null;
    }
  }

  /// Listen for token refresh
  void _listenToTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((String token) async {
      _fcmToken = token;
      await StorageService().write(DBKeys.fcmToken, token);
      if (kDebugMode) {
        print('FCM Token refreshed: $token');
      }
      // TODO: Send updated token to your server
      await _sendTokenToServer(token);
    });
  }

  /// Set up message handlers
  Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    _messageSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages when app is opened
    _backgroundMessageSubscription = FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Received foreground message: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    // Show local notification for foreground messages
    await _showLocalNotification(message);
  }

  /// Handle background messages when app is opened
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('App opened from background message: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    // Handle navigation based on message data
    _handleNotificationNavigation(message);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'StoxPlay',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // TODO: Handle navigation based on notification payload
  }

  /// Handle notification navigation
  void _handleNotificationNavigation(RemoteMessage message) {
    // TODO: Implement navigation logic based on message data
    // Example:
    // if (message.data['type'] == 'contest') {
    //   // Navigate to contest screen
    // } else if (message.data['type'] == 'leaderboard') {
    //   // Navigate to leaderboard screen
    // }
  }

  /// Send FCM token to server
  Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Implement API call to send token to your server
      // Example:
      // await ApiService().sendFCMToken(token);
      if (kDebugMode) {
        print('Token sent to server: $token');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending token to server: $e');
      }
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic $topic: $e');
      }
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic $topic: $e');
      }
    }
  }

  /// Get initial message (if app was opened from notification)
  Future<RemoteMessage?> getInitialMessage() async {
    return await _firebaseMessaging.getInitialMessage();
  }

  /// Check if app was opened from notification
  Future<bool> wasAppOpenedFromNotification() async {
    final initialMessage = await getInitialMessage();
    return initialMessage != null;
  }

  /// Get stored FCM token from local storage
  Future<String?> getStoredFCMToken() async {
    return await StorageService().read(DBKeys.fcmToken);
  }

  /// Clear FCM token
  Future<void> clearFCMToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      await StorageService().remove(DBKeys.fcmToken);
      _fcmToken = null;
      if (kDebugMode) {
        print('FCM Token cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing FCM token: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _messageSubscription?.cancel();
    _backgroundMessageSubscription?.cancel();
  }
}

/// Background message handler (must be top-level function)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }

  // TODO: Handle background message processing
  // You can perform background tasks here like updating local database,
  // sending analytics, etc.
}
