import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/constants/settings.dart';
import 'package:solar_icon_pack/solar_linear_icons.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final faqs = [
    SettingsItem(
      icons: SolarLinearIcons.user,
      title: 'Rider FAQs',
      onTap: () {},
    ),
    SettingsItem(
      icons: SolarLinearIcons.questionCircle,
      title: 'Driver FAQs',
      onTap: () {},
    ),
  ];

  final tutorialsandguides = [
    SettingsItem(
      icons: SolarLinearIcons.mapPoint,
      title: 'How to book a ride',
      onTap: () {},
    ),
    SettingsItem(
      icons: SolarLinearIcons.handMoney,
      title: 'How to accept a fare',
      onTap: () {},
    ),
  ];

  final contactsupport = [
    SettingsItem(
      icons: SolarLinearIcons.headphonesRound,
      title: 'Contact support',
      onTap: () {},
    ),
    SettingsItem(icons: SolarLinearIcons.letter, title: 'Email', onTap: () {}),
    SettingsItem(
      icons: SolarLinearIcons.shieldCheck,
      title: 'Privacy Policy',
      onTap: () {},
    ),
    SettingsItem(
      icons: SolarLinearIcons.documentText,
      title: 'Terms of Services',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: GlobalAppBar(
        title: 'Help & Support',
        showProfile: true,
        profileImage: 'assets/icons/profile.jpg',
        onCloseTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          SettingsContainer(
            title: 'FAQs',
            items: faqs,
            iconBackgroundColor: Colors.grey[200]!,
          ),
          SettingsContainer(
            title: 'Tutorials & Guides',
            items: tutorialsandguides,
            iconBackgroundColor: Colors.grey[200]!,
          ),
          SettingsContainer(
            title: 'Contact and Support',
            items: contactsupport,
            iconBackgroundColor: Colors.grey[200]!,
          ),
        ],
      ),
    );
  }
}
