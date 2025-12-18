import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfile;
  final VoidCallback? onProfileTap; // optional override
  final VoidCallback? onCloseTap;
  final String? profileImage; // optional
  final bool showSettings;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.showProfile = true,
    this.onProfileTap,
    this.onCloseTap,
    this.profileImage,
    this.showSettings = true,
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
      leading: showProfile
          ? GestureDetector(
              onTap: () {
                if (onProfileTap != null) {
                  onProfileTap!(); // use custom behavior if provided
                } else {
                  _defaultProfileTap(context); // otherwise use default
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(
                    profileImage ?? 'assets/icons/profile.png',
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        if (onCloseTap != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.close),
              iconSize: 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              splashRadius: 20,
              color: Colors.black,
              onPressed: onCloseTap,
            ),
          )
        else
          const SizedBox(width: 12),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
