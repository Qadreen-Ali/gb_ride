import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class NotificationAllScreen extends StatefulWidget {
  const NotificationAllScreen({super.key});

  @override
  State<NotificationAllScreen> createState() => _NotificationAllScreenState();
}

class _NotificationAllScreenState extends State<NotificationAllScreen> {
  @override
  Widget build(BuildContext context) {
    final List<SettingsItem> notifications = [
      SettingsItem(
        icons: Icons.warning_rounded,
        iconColor: GBColor.secondary,
        iconBgColor: GBColor.primary,
        showArrow: false,
        title: 'Document Verification required',
        extraText: 'just now',
        subtitle:
            'Please update your driver\'s license photo to continue accepting rides.',
        onTap: () {},
      ),
      SettingsItem(
        icons: Icons.attach_money,
        iconColor: GBColor.secondary,
        iconBgColor: GBColor.primary,
        showArrow: false,
        title: 'Bonus Achieved',
        extraText: '24h ago',
        subtitle:
            'You completed 20 rides this week. A 2000pkr bonus has been added to your account.',
        onTap: () {},
      ),
      SettingsItem(
        icons: Icons.payments,
        iconColor: GBColor.secondary,
        iconBgColor: GBColor.primary,
        showArrow: false,
        title: 'High Demand Area',
        extraText: 'Yesterday',
        subtitle:
            'Surge pricing is active in Downtown. Go online now to earn more.',
        onTap: () {},
      ),
      SettingsItem(
        icons: Icons.update,
        iconColor: GBColor.secondary,
        iconBgColor: GBColor.primary,
        showArrow: false,
        title: 'App Update Available',
        extraText: 'Yesterday',
        subtitle:
            'New navigation feature is available.Please update your to the latest....',
        onTap: () {},
      ),
      SettingsItem(
        icons: Icons.star,
        iconColor: GBColor.secondary,
        iconBgColor: GBColor.primary,
        showArrow: false,
        title: 'New 5 star Rating',
        extraText: 'Yesterday',
        subtitle:
            'Great driver, very polite and car was clean. keep up the good work.',
        onTap: () {},
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return SettingsSingleContainer(
          item: notifications[index],
          isExpanded: false,
          iconBackgroundColor: GBColor.lightGray,
        );
      },
    );
  }
}
