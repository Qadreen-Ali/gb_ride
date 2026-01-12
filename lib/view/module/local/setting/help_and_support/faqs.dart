import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int expandedIndex = -1;

  // FAQ items
  final List<SettingsItem> faqs = const [
    SettingsItem(
      title: "How can I reset my password?",
      answer:
          "To reset your password, go to the login screen and click on 'Forgot Password'. Follow the instructions to reset it.",
      isFaq: true,
      onTap: _noop,
    ),
    SettingsItem(
      title: "How do I contact support?",
      answer:
          "You can contact support through WhatsApp, Email, or the Contact Us section in the app.",
      isFaq: true,
      onTap: _noop,
    ),
    SettingsItem(
      title: "How to update my profile information?",
      answer:
          "Go to the Profile section from the main menu and tap 'Edit Profile' to update your information.",
      isFaq: true,
      onTap: _noop,
    ),
  ];

  // Toggle FAQ expansion
  void toggleFaq(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isExpanded = expandedIndex == index;

          // Create a new SettingsItem for each FAQ to override the onTap
          final itemWithTap = SettingsItem(
            title: faq.title,
            subtitle: faq.subtitle,
            answer: faq.answer,
            isFaq: faq.isFaq,
            icons: faq.icons,
            iconPath: faq.iconPath,
            iconColor: faq.iconColor,
            textColor: faq.textColor,
            arrowColor: faq.arrowColor,
            arrowIcon: faq.arrowIcon,
            iconVerticalOffset: faq.iconVerticalOffset,
            onTap: () => toggleFaq(index),
          );

          return SettingsSingleContainer(
            item: itemWithTap,
            isExpanded: isExpanded,
          );
        },
      ),
    );
  }
}

// No-op function for const SettingsItem
void _noop() {}
