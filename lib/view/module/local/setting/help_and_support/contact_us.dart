import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SettingsItem> contactItems = [
      SettingsItem(
        iconPath: 'assets/icons/whatsapp.png',
        title: 'WhatsApp',
        subtitle: '0310 928 4650',
        onTap: () => _launchUrl(''),
        arrowIcon: Icons.keyboard_arrow_down,
        iconVerticalOffset: -.0,
      ),
      SettingsItem(
        iconPath: 'assets/icons/mail.png',
        title: 'Email',
        onTap: () => _launchUrl(''),
        arrowIcon: Icons.keyboard_arrow_down,
      ),
      SettingsItem(
        iconPath: 'assets/icons/facebook.png',
        title: 'Facebook',
        onTap: () => _launchUrl(''),
        arrowIcon: Icons.keyboard_arrow_down,
      ),
      SettingsItem(
        iconPath: 'assets/icons/website.png',
        title: 'Website',
        onTap: () => _launchUrl(''),
        arrowIcon: Icons.keyboard_arrow_down,
      ),
      SettingsItem(
        iconPath: 'assets/icons/twitter.png',
        title: 'Twitter',
        onTap: () => _launchUrl(''),
        arrowIcon: Icons.keyboard_arrow_down,
      ),
      SettingsItem(
        iconPath: 'assets/icons/instagram.png',
        title: 'Instagram',
        onTap: () => _launchUrl(''),
        arrowIcon: Icons.keyboard_arrow_down,
      ),
    ];

    return Scaffold(
      backgroundColor: GBColor.secondary,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: contactItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // WhatsApp tile taller
          final isWhatsApp = index == 0;
          return SettingsSingleContainer(
            isExpanded: false,
            item: contactItems[index],
            iconBackgroundColor: GBColor.secondary,
            height: isWhatsApp ? 75 : 56,
          );
        },
      ),
    );
  }
}
