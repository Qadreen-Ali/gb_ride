import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  void _onTap(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tapped $title')));
  }

  @override
  Widget build(BuildContext context) {
    /// Share & Contacts
    final shareAndContacts = [
      SettingsItem(
        icons: SolarLinearIcons.share,
        title: 'Share my Trip',
        onTap: () => _onTap(context, 'Share my Trip'),
      ),
      SettingsItem(
        icons: SolarLinearIcons.usersGroupRounded,
        title: 'Trusted Contacts',
        onTap: () => _onTap(context, 'Trusted Contacts'),
      ),
    ];

    /// Safety Tools
    final safetyTools = [
      SettingsItem(
        icons: SolarLinearIcons.dangerTriangle,
        title: 'Report a safety issue',
        onTap: () => _onTap(context, 'Report a safety issue'),
      ),
      SettingsItem(
        icons: SolarLinearIcons.shieldCheck,
        title: 'Safety Guidelines & Tips',
        onTap: () => _onTap(context, 'Safety Guidelines & Tips'),
      ),
      SettingsItem(
        icons: SolarLinearIcons.phoneCalling,
        title: 'Call Emergency Services',
        iconColor: Colors.red,
        textColor: Colors.red,
        arrowColor: Colors.red,
        onTap: () => _onTap(context, 'Call Emergency Services'),
      ),
    ];

    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: GlobalAppBar(
        title: 'Safety',
        profileImage: 'assets/icons/profile.jpg',
        showProfile: true,
        onCloseTap: () => Navigator.pop(context),
        onProfileTap: () {},
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(
          overscroll: false,
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Subtitle
              const Text(
                'Your safety is our priority. Access tools and resources to help you feel secure',
                style: TextStyle(color: GBColor.black, fontSize: 13),
              ),

              const SizedBox(height: 20),

              /// SOS Button
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Left SOS
                    Expanded(
                      child: Center(
                        child: Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withValues(alpha:0.3),
                    ),

                    // Center Emergency
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          'Emergency',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withValues(alpha:0.3),
                    ),

                    // Right SOS
                    Expanded(
                      child: Center(
                        child: Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Share & Contacts
              const Text(
                'Share & Contacts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...shareAndContacts.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SettingsSingleContainer(item: item, isExpanded: true),
                ),
              ),

              const SizedBox(height: 20),

              /// Safety Tools
              const Text(
                'Safety Tools',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...safetyTools.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SettingsSingleContainer(item: item, isExpanded: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
