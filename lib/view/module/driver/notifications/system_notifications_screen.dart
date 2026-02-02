import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/services/supabase_service.dart';
import 'package:gb_ride/models/notification_model.dart';

class NotificationSystemScreen extends StatefulWidget {
  final SupabaseService supabaseService;

  const NotificationSystemScreen({super.key, required this.supabaseService});

  @override
  State<NotificationSystemScreen> createState() =>
      _NotificationSystemScreenState();
}

class _NotificationSystemScreenState extends State<NotificationSystemScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final userId = widget.supabaseService.getCurrentUserId();
    if (userId != null) {
      _notificationsFuture = widget.supabaseService
          .fetchNotifications(userId)
          .then(
            (notifications) => notifications
                .where(
                  (n) =>
                      n.type.toLowerCase() == 'system' ||
                      n.type.toLowerCase() == 'warning',
                )
                .toList(),
          );
    } else {
      _notificationsFuture = Future.value([]);
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'warning':
        return Icons.emergency;
      case 'error':
        return Icons.error_outline;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  void _markAsRead(String notificationId) async {
    try {
      await widget.supabaseService.markNotificationAsRead(notificationId);
      setState(() {
        _loadNotifications();
      });
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationModel>>(
      future: _notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No system notifications'));
        }

        final notifications = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return GestureDetector(
              onTap: () {
                if (!notif.isRead) {
                  _markAsRead(notif.id);
                }
              },
              child: SettingsSingleContainer(
                item: SettingsItem(
                  icons: _getIconForType(notif.type),
                  iconColor: GBColor.secondary,
                  iconBgColor: GBColor.error,
                  showArrow: false,
                  title: notif.title,
                  extraText: _formatTime(notif.createdAt),
                  subtitle: notif.message,
                  onTap: () {
                    if (!notif.isRead) {
                      _markAsRead(notif.id);
                    }
                  },
                ),
                isExpanded: false,
                iconBackgroundColor: notif.isRead
                    ? GBColor.lightGray
                    : GBColor.error.withOpacity(0.1),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return dateTime.toString().split(' ')[0];
    }
  }
}
