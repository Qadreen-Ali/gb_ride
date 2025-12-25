import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/logger.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // indicatorColor:Colors.grey,
      child: Scaffold(
        appBar: GlobalAppBar(
          profileImage: 'assets/icons/profile.jpg',
          title: 'Notications',
          showProfile: true,
          // showSettings: false,
          onCloseTap: () => Navigator.pop(context),
          onProfileTap: () {},
        ),

        body: Row(
          children: [
            SizedBox(width: 65),
            GestureDetector(
              onTap: () {
                logger.i('All clicked !');
              },
              child: Text(
                'All',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 170),
            GestureDetector(
              onTap: () {
                logger.i('Messages Got clicked !');
              },
              child: Text(
                'Messages',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
