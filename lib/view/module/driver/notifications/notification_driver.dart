import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/driver/notifications/all_notification_driver.dart';
import 'package:gb_ride/view/module/driver/notifications/system_notifications_screen.dart';
import '../../../../utils/constants/custom_app_bar.dart';

class NotificationDriverScreen extends StatelessWidget {
  const NotificationDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: GBColor.secondary,
        appBar: CustomAppBar(
          showLeading: false,
          title: 'Notifications',
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: GBColor.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: GBColor.secondary),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TabBar(
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
                  Tab(text: 'System'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [NotificationAllScreen(), NotificationSystemScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
