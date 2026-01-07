import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfile;
  final VoidCallback? onProfileTap; // optional override
  final VoidCallback? onCloseTap;
  final String? profileImage; // optional
  // final bool showSettings;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.showProfile = true,
    this.onProfileTap,
    this.onCloseTap,
    this.profileImage,
    // this.showSettings = true,
  });

  void _defaultProfileTap(BuildContext context) {
    // Default action when profile is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DefaultProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,

      elevation: 0,
      leadingWidth: 72,
      toolbarHeight: 120,
      leading: showProfile
          ? GestureDetector(
              onTap: () {
                if (onProfileTap != null) {
                  onProfileTap!();
                } else {
                  _defaultProfileTap(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: profileImage != null
                      ? AssetImage(profileImage!)
                      : null,
                  child: profileImage == null ? const Icon(Icons.person) : null,
                ),
              ),
            )
          : const SizedBox.shrink(), // 👈 THIS IS THE KEY

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        if (onCloseTap != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: onCloseTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: GBColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: GBColor.secondary,
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

// Example default profile screen
class DefaultProfileScreen extends StatelessWidget {
  const DefaultProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Default Profile Screen')),
    );
  }
}
