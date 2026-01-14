import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import '../../../../utils/constants/custom_app-bar.dart';
import '../../../../utils/constants/image_string.dart';
import 'all_notifications_screen.dart';
import 'message_notifiactions_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // indicatorColor:Colors.grey,
      child: Scaffold(
        backgroundColor: GBColor.secondary,
        appBar: CustomAppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: GBColor.primary,
                  shape: BoxShape.circle,
                  image: DecorationImage(image:  AssetImage(GBImagePath.profile))
              ),
            ),
          ),
          title: 'Notifications',
          actions: [Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:GBColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color:GBColor.secondary),
              ),
            ),
          ),],
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
