import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/view/module/local/setting/widget/settings_widget.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        onTap: () {},
      ),
    ];

    final preferences = [
      SettingsItem(
        icons: SolarLinearIcons.bell,
        title: 'Notifications',
        onTap: () {},
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
        title: 'Help Center/FAQs',
        onTap: () {
          Navigator.pushNamed(context, '/help');
        },
      ),
    ];

    final logout = SettingsItem(
      icons: SolarLinearIcons.logout,
      title: 'Logout',
      onTap: () => _onTap(context, 'Logout'),
    );

    final delete = SettingsItem(
      icons: Icons.delete,
      title: 'Delete Account',
      iconColor: Colors.red,
      textColor: Colors.red,
      arrowColor: Colors.red,
      onTap: () => _onTap(context, 'Delete Account'),
    );

    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: GlobalAppBar(
        title: 'Settings',
        profileImage: 'assets/icons/profile.jpg',
        onCloseTap: () => Navigator.pop(context),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(
          overscroll: false, // removes glow
          scrollbars: false, // removes scroll bar
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // allows natural swipe
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
