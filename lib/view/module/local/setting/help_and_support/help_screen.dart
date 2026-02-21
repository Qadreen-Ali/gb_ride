import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/local/setting/help_and_support/contact_us.dart';
import 'package:gb_ride/view/module/local/setting/help_and_support/faqs.dart';

import '../../../../../utils/constants/custom_app_bar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: GBColor.secondary,
        appBar:CustomAppBar(
          title: 'Help Center / FAQs',
          leading: Padding(
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
                child: const Icon(Icons.close, color: GBColor.secondary),
              ),
            ),
          ),
        ),
          body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TabBar(
                indicatorColor: Colors.grey.shade400,
                indicatorWeight: 3,
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
