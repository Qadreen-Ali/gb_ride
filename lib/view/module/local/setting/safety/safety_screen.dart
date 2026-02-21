import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/app_snackbar_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import '../../../../../utils/constants/custom_app_bar.dart';
import '../../../../../utils/constants/image_string.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  void _onTap(String title) {
    Get.snackbar('Action', 'Tapped $title');
  }

  @override
  Widget build(BuildContext context) {
    /// Share & Contacts
    final shareAndContacts = [
      SettingsItem(
        icons: SolarLinearIcons.share,
        title: 'Share my Trip',
        onTap: () => _onTap('Share my Trip'),
      ),
      SettingsItem(
        icons: SolarLinearIcons.usersGroupRounded,
        title: 'Trusted Contacts',
        onTap: () => _onTap('Trusted Contacts'),
      ),
    ];

    /// Safety Tools
    final safetyTools = [
      SettingsItem(
        icons: SolarLinearIcons.dangerTriangle,
        title: 'Report a safety issue',
        onTap: () => _onTap('Report a safety issue'),
      ),
      SettingsItem(
        icons: SolarLinearIcons.shieldCheck,
        title: 'Safety Guidelines & Tips',
        onTap: () => _onTap('Safety Guidelines & Tips'),
      ),
      SettingsItem(
        icons: SolarLinearIcons.phoneCalling,
        title: 'Call Emergency Services',
        iconColor: Colors.red,
        textColor: Colors.red,
        arrowColor: Colors.red,
        onTap: () => _onTap('Call Emergency Services'),
      ),
    ];

    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: GBColor.primary,
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage(GBImagePath.profile)),
            ),
          ),
        ),
        title: 'Safety',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GBColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: GBColor.secondary),
              ),
            ),
          ),
        ],
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
              SizedBox(height: 12),

              /// Subtitle
              Center(
                child: const Text(
                  'Your safety is our priority. Access tools and\nresources to help you feel secure',
                  style: TextStyle(
                    color: GBColor.black,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              /// SOS Button
              PrimaryButton(
                height: 48,
                backgroundColor: Colors.red,
                borderColor: Colors.red,
                borderRadius: BorderRadius.circular(12),
                onPressed: () {
                  Get.snackbar(
                    AppSnackBarString.sosTriggeredTitle,
                    AppSnackBarString.sosTriggeredMessage,
                  );
                },
                title: '',
                child: Row(
                  children: [
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

                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),

                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          'Emergencey Call',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),

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
