import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:gb_ride/view/module/local/setting/logout/logout_screen.dart';
import 'package:gb_ride/view/module/local/setting/delete/delete_screen.dart';

import '../../../../utils/constants/custom_app-bar.dart';

class DriverSettings extends StatefulWidget {
  const DriverSettings({super.key});

  @override
  State<DriverSettings> createState() => _DriverSettingsState();
}

class _DriverSettingsState extends State<DriverSettings> {
  void _onTap(BuildContext context, String name) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tapped $name')));
  }

  @override
  Widget build(BuildContext context) {
    final account = [
      SettingsItem(
        icons: SolarLinearIcons.user,
        title: 'Profile Information',
        onTap: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
      SettingsItem(
        icons: SolarLinearIcons.card,
        title: 'Manage Payment Methods',
        onTap: () {
          Navigator.pushNamed(context, '/paymentmethod');
        },
      ),
    ];

    final preferences = [
      SettingsItem(
        icons: SolarLinearIcons.bell,
        title: 'Notifications',
        onTap: () {
          Navigator.pushNamed(context, '/notification(driver)');
        },
      ),
      SettingsItem(
        icons: SolarLinearIcons.shieldKeyhole,
        title: 'Privacy & Security',
        onTap: () {
          Navigator.pushNamed(context, '/safety');
        },
      ),
    ];

    final support = [
      SettingsItem(
        icons: SolarLinearIcons.help,
        title: 'Help Center / FAQs',
        onTap: () {
          Navigator.pushNamed(context, '/help');
        },
      ),
    ];

    final logout = SettingsItem(
      icons: SolarLinearIcons.logout,
      title: 'Logout',
      onTap: () => showLogoutConfirmation(context),
    );

    final delete = SettingsItem(
      icons: Icons.delete,
      title: 'Delete Account',
      iconColor: Colors.red,
      textColor: Colors.red,
      arrowColor: Colors.red,
      onTap: () => showDeleteConfirmation(context),
    );

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
        title: 'Settings',
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
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(
          overscroll: false,
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ...account.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SettingsSingleContainer(item: item, isExpanded: false),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Preferences',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ...preferences.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SettingsSingleContainer(item: item, isExpanded: false),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Support & Legal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ...support.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SettingsSingleContainer(item: item, isExpanded: false),
                ),
              ),

              const SizedBox(height: 12),
              SettingsSingleContainer(item: logout, isExpanded: false),
              const SizedBox(height: 12),
              SettingsSingleContainer(item: delete, isExpanded: false),
            ],
          ),
        ),
      ),
    );
  }
}
