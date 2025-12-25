import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/constants/bottom_bar.dart';
import 'package:gb_ride/utils/constants/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // int _selectedIndex = 0;

  void _onTap(BuildContext context, String name) {
    GlobalBottomBar.show(
      context,
      message: 'Tapped $name',
      icon1: Icons.check_circle_outline,
      icon2: Icons.info_outline,
      icon3: Icons.star_outline,
    );
  }

  // void _onBottomTap(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final account = [
      SettingsItem(
        icon: Icons.person,
        title: 'Profile Information',
        onTap: () {
          Navigator.of(context).pushNamed('/profile');
        },
      ),
      SettingsItem(
        icon: Icons.lock,
        title: 'Manage Payment Methods',
        onTap: () => _onTap(context, 'Manage Payment Methods'),
      ),
      SettingsItem(
        icon: Icons.lock,
        title: 'Change Password',
        onTap: () => _onTap(context, 'Change Password'),
      ),
    ];

    final preferences = [
      SettingsItem(
        icon: Icons.notifications,
        title: 'Notifications',
        onTap: () => _onTap(context, 'Notifications'),
      ),
      SettingsItem(
        icon: Icons.payment,
        title: 'Privacy & Security',
        onTap: () => _onTap(context, 'Privacy & Security'),
      ),
      SettingsItem(
        icon: Icons.language,
        title: 'Language',
        onTap: () => _onTap(context, 'Language'),
      ),
    ];

    final supportAndLegal = [
      SettingsItem(
        icon: Icons.help,
        title: 'Help Center / FAQs',
        onTap: () => _onTap(context, 'Help Center / FAQs'),
      ),
      SettingsItem(
        icon: Icons.support,
        title: 'Contact Support',
        onTap: () => _onTap(context, 'Contact Support'),
      ),
      SettingsItem(
        icon: Icons.pages,
        title: 'Terms of Service',
        onTap: () => _onTap(context, 'Terms of Service'),
      ),
      SettingsItem(
        icon: Icons.policy,
        title: 'Privacy Policy',
        onTap: () => _onTap(context, 'Privacy Policy'),
      ),
    ];

    final last = [
      SettingsItem(
        icon: Icons.logout,
        title: 'LogOut',
        onTap: () => _onTap(context, 'Logout'),
      ),
      SettingsItem(
        icon: Icons.delete,
        iconColor: Colors.red,
        title: 'Delete Account',
        textColor: const Color.fromARGB(255, 181, 41, 31),
        onTap: () => _onTap(context, 'Delete Account'),
      ),
    ];

    return Scaffold(
      appBar: GlobalAppBar(
        profileImage: 'assets/icons/profile.jpg',
        title: 'Settings',
        showProfile: true,
        // showSettings: false,
        onCloseTap: () => Navigator.pop(context),
        onProfileTap: () {},
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
            children: [
              SettingsContainer(
                title: "Account",
                items: account,
                iconBackgroundColor: Colors.grey[200]!,
              ),
              const SizedBox(height: 15),
              SettingsContainer(
                title: "Preferences",
                items: preferences,
                iconBackgroundColor: Colors.grey[200]!,
              ),
              const SizedBox(height: 15),
              SettingsContainer(
                title: "Support & Legal",
                items: supportAndLegal,
                iconBackgroundColor: Colors.grey[200]!,
              ),
              const SizedBox(height: 15),
              SettingsContainer(title: '', items: last),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: GlobalBottomBar(
      //   selectedIndex: _selectedIndex,
      //   onItemTap: _onBottomTap,
      // ),
    );
  }
}
