import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/view/module/local/setting/help_and_support/contact_us.dart';
import 'package:gb_ride/view/module/local/setting/help_and_support/faqs.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: GBColor.secondary,
        appBar: GlobalAppBar(
          title: 'Help Center / FAQs',
          onCloseTap: () => Navigator.pop(context),
          showProfile: false,
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
                  Tab(text: 'Contact US'),
                  Tab(text: 'FAQs'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  ContactUsScreen(),
                  FAQScreen(), // placeholder for Messages
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
