import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/notifications/all_notifications_screen.dart';
import 'package:gb_ride/view/module/notifications/message_notifiactions_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // indicatorColor:Colors.grey,
      child: Scaffold(
        backgroundColor: GBColor.secondary,
        appBar: GlobalAppBar(
          profileImage: 'assets/icons/profile.jpg',
          title: 'Notications',
          showProfile: true,
          onCloseTap: () => Navigator.pop(context),
          onProfileTap: () {},
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TabBar(
                indicatorColor: Colors.grey.shade400,
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: GBColor.primary,
                unselectedLabelColor: GBColor.textFieldText,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 6, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                  insets: const EdgeInsets.only(bottom: 8),
                ),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Messages'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  AllNotificationScreen(),
                  MessageNotificationsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
