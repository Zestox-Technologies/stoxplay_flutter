import 'package:flutter/material.dart';
import 'package:stoxplay/core/services/notification_manager.dart';
import 'package:stoxplay/utils/models/notification_model.dart';

/// Helper widget for notification-related UI operations
class NotificationHelper {
  NotificationHelper._();

  /// Show notification permission dialog
  static Future<bool> showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Enable Notifications'),
              content: const Text(
                'Stay updated with contest results, leaderboard updates, and important announcements by enabling notifications.',
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Not Now')),
                ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Enable')),
              ],
            );
          },
        ) ??
        false;
  }

  /// Show notification settings dialog
  static Future<void> showSettingsDialog(BuildContext context) async {
    final notificationManager = NotificationManager();
    final settings = notificationManager.getNotificationSettings();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Notification Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingTile(
                    'General Notifications',
                    'Contest updates and general announcements',
                    settings['general'] ?? false,
                    (value) {
                      setState(() {
                        settings['general'] = value;
                      });
                    },
                  ),
                  _buildSettingTile(
                    'Contest Notifications',
                    'Contest start, end, and result notifications',
                    settings['contests'] ?? false,
                    (value) {
                      setState(() {
                        settings['contests'] = value;
                      });
                    },
                  ),
                  _buildSettingTile(
                    'Leaderboard Notifications',
                    'Leaderboard updates and ranking changes',
                    settings['leaderboard'] ?? false,
                    (value) {
                      setState(() {
                        settings['leaderboard'] = value;
                      });
                    },
                  ),
                  _buildSettingTile(
                    'Promotional Notifications',
                    'Special offers and promotional content',
                    settings['promotions'] ?? false,
                    (value) {
                      setState(() {
                        settings['promotions'] = value;
                      });
                    },
                  ),
                  _buildSettingTile(
                    'Reminder Notifications',
                    'Contest reminders and important deadlines',
                    settings['reminders'] ?? false,
                    (value) {
                      setState(() {
                        settings['reminders'] = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    await notificationManager.updateNotificationSettings(settings);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Build setting tile widget
  static Widget _buildSettingTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(title: Text(title), subtitle: Text(subtitle), trailing: Switch(value: value, onChanged: onChanged));
  }

  /// Show notification list
  static Future<void> showNotificationList(BuildContext context) async {
    final notificationManager = NotificationManager();
    final notifications = notificationManager.notifications;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            notificationManager.markAllNotificationsAsRead();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Mark All Read'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        notifications.isEmpty
                            ? const Center(child: Text('No notifications yet'))
                            : ListView.builder(
                              controller: scrollController,
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final notification = notifications[index];
                                return _buildNotificationTile(context, notification);
                              },
                            ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Build notification tile widget
  static Widget _buildNotificationTile(BuildContext context, NotificationModel notification) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getNotificationColor(notification.notificationType),
        child: Icon(_getNotificationIcon(notification.notificationType), color: Colors.white),
      ),
      title: Text(notification.title ?? 'StoxPlay', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.body ?? ''),
          const SizedBox(height: 4),
          Text(_getNotificationTime(notification.sentTime), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
      onTap: () {
        NotificationManager().markNotificationAsRead(notification.messageId ?? '');
        // TODO: Handle notification tap navigation
      },
    );
  }

  /// Get notification color based on type
  static Color _getNotificationColor(String? type) {
    switch (type) {
      case 'contest':
        return Colors.blue;
      case 'leaderboard':
        return Colors.orange;
      case 'system':
        return Colors.red;
      case 'promotion':
        return Colors.purple;
      case 'reminder':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Get notification icon based on type
  static IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'contest':
        return Icons.emoji_events;
      case 'leaderboard':
        return Icons.leaderboard;
      case 'system':
        return Icons.info;
      case 'promotion':
        return Icons.local_offer;
      case 'reminder':
        return Icons.notifications;
      default:
        return Icons.notifications_none;
    }
  }

  /// Get formatted notification time
  static String _getNotificationTime(DateTime? sentTime) {
    if (sentTime == null) return 'Just now';

    final now = DateTime.now();
    final difference = now.difference(sentTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${sentTime.day}/${sentTime.month}/${sentTime.year}';
    }
  }

  /// Show FCM token for debugging
  static void showFCMToken(BuildContext context) {
    final notificationManager = NotificationManager();
    final token = notificationManager.fcmToken;

    if (token != null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('FCM Token'),
              content: SelectableText(token),
              actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('FCM Token not available')));
    }
  }
}
