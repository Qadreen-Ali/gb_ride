import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/notifications/notification_tile.dart';

class AllNotificationScreen extends StatelessWidget {
  const AllNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _sectionTitle('Today'),

        const NotificationTile(
          icon: Icons.directions_car,
          title: "Ride Confirmed",
          subtitle: 'Your ride to KIU is starting now',
          time: '2 minutes ago',
          unread: true,
        ),

        _divider(),
        const NotificationTile(
          icon: Icons.star_border,
          title: 'New Promotion avaliable',
          subtitle: 'Get 20% off your next 3 rides',
          time: '1h ago',
          unread: true,
        ),

        _divider(),

        const NotificationTile(
          icon: Icons.close,
          title: 'Ride Canceled',
          subtitle: 'Your ride was canceled by the driver.',
          time: '3h ago',
        ),

        const SizedBox(height: 16),
        _sectionTitle('Yesterday'),

        const NotificationTile(
          icon: Icons.settings,
          title: 'System Updates',
          subtitle: 'we updated our privacy policy.',
          time: '1 day ago',
        ),

        _divider(),

        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
        ),
        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
        ),
        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
        ),
        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
        ),
        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
        ),
        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
        ),
        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
        ),
        const NotificationTile(
          icon: Icons.credit_card,
          title: 'Payment Successful',
          subtitle: 'Your payment of 80 pkr was successful.',
          time: '1 day ago',
          trailingText: '1',
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
          color: GBColor.lineColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 16, thickness: 1, color: Colors.grey.shade300);
  }
}
