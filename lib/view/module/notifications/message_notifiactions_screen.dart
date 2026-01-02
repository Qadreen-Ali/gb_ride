import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/notifications/notification_tile.dart';

class MessageNotificationsScreen extends StatelessWidget {
  const MessageNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _sectionTitle('Today'),

        const NotificationTile(
          icon: Icons.chat_bubble_outline,
          title: 'Driver Message',
          subtitle: 'Your driver has arrived at pickup point.',
          time: '1 min ago',
          unread: true,
        ),

        _divider(),

        const NotificationTile(
          icon: Icons.chat_bubble_outline,
          title: 'Driver Message',
          subtitle: 'Please be ready, I am waiting outside.',
          time: '10 min ago',
          unread: true,
        ),

        const SizedBox(height: 16),
        _sectionTitle('Yesterday'),

        const NotificationTile(
          icon: Icons.chat_bubble_outline,
          title: 'Support Message',
          subtitle: 'Your issue has been resolved successfully.',
          time: '1 day ago',
        ),
      ],
    );
  }

  // ---------------- UI COMPONENTS ----------------

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 16, thickness: 1, color: Colors.grey.shade300);
  }
}
