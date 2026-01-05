import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header with profile info
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              child: Row(
                children: [
                  // Profile avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade300, Colors.orange.shade300],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Profile text
                  const Expanded(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  DrawerMenuItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    isSelected: true,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to home
                    },
                  ),

                  DrawerMenuItem(
                    image: Image.asset(GBImagePath.safety, fit: BoxFit.contain),
                    label: 'Safety',
                    imageColor: Colors.black,

                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.settings_sharp,
                    label: 'Setting',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to safety
                    },
                  ),
                  DrawerMenuItem(
                    image: Image.asset(GBImagePath.help, fit: BoxFit.contain),
                    label: 'Help',
                    imageColor: Colors.black,
                    onTap: () {},
                  ),

                  DrawerMenuItem(
                    icon: Icons.history_outlined,
                    label: 'History',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to history
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData? icon;
  final Image? image;
  final Color? imageColor;
  final Color? selectedImageColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerMenuItem({
    Key? key,
    this.icon,
    this.image,
    required this.label,
    this.isSelected = false,
    required this.onTap, this.imageColor, this.selectedImageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? GBColor.primary : GBColor.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: _buildIcon(),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? GBColor.secondary : Colors.black,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildIcon() {
    if (image != null) {
      return SizedBox(
        width: 24,
        height: 24,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            isSelected
                ? (selectedImageColor ?? GBColor.secondary)
                : (imageColor ?? Colors.black),
            BlendMode.srcIn,
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: image!,
          ),
        ),
      );
    } else if (icon != null) {
      return Icon(
        icon,
        color: isSelected ? GBColor.secondary : Colors.black,
        size: 24,
      );
    } else {
      return const SizedBox(width: 24);
    }
  }
}
