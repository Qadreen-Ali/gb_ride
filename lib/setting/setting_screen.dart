import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/constants/settings.dart';
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
        onTap: () {},
      ),
      SettingsItem(
        icons: SolarLinearIcons.card,
        title: 'Manage Payment Methods',
        onTap: () {},
      ),
      SettingsItem(
        icons: SolarLinearIcons.lock,
        title: 'Change Password',
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
        onTap: () {},
      ),
      SettingsItem(
        icons: SolarLinearIcons.global,
        title: 'Language',
        onTap: () {},
      ),
    ];

    final support = [
      SettingsItem(
        icons: SolarLinearIcons.help,
        title: 'Help Center',
        onTap: () {},
      ),
      SettingsItem(
        icons: SolarLinearIcons.document,
        title: 'Terms of Service',
        onTap: () {},
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
      appBar: GlobalAppBar(
        title: 'Settings',
        profileImage: 'assets/icons/profile.jpg',
        onCloseTap: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFF5F5F7),
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
                  child: SettingsSingleContainer(item: item),
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
                  child: SettingsSingleContainer(item: item),
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
                  child: SettingsSingleContainer(item: item),
                ),
              ),

              const SizedBox(height: 24),
              SettingsSingleContainer(item: logout),
              const SizedBox(height: 12),
              SettingsSingleContainer(item: delete),
            ],
          ),
        ),
      ),
    );
  }
}
