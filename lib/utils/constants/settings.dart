import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

/// Model for each item
class SettingsItem {
  final IconData icons;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor; // optional icon color
  final Color? textColor;
  final Color? arrowColor;

  const SettingsItem({
    required this.icons,
    required this.title,
    required this.onTap,
    this.iconColor, // optional
    this.textColor,
    this.arrowColor,
  });
}

/// Single tile with circular icon background
class SettingsTile extends StatelessWidget {
  final SettingsItem item;
  final Color iconBackgroundColor;

  const SettingsTile({
    super.key,
    required this.item,
    this.iconBackgroundColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: iconBackgroundColor,
        child: Icon(
          item.icons,
          color:
              item.iconColor ??
              GBColor.gray, // use custom icon color if provided
          size: 20,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 18,
          color:
              item.textColor ??
              Colors.black, // use custom text color if provided
        ),
      ),

      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: item.arrowColor ?? Colors.grey, // use arrowColor if provided
      ),
      onTap: item.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}

/// Reusable container for any number of items
class SettingsContainer extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;
  final Color iconBackgroundColor;
  final double width;
  final double? height; // optional height

  const SettingsContainer({
    super.key,
    required this.title,
    required this.items,
    this.iconBackgroundColor = const Color(0xFFE0E0E0),
    this.width = 399,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 5),

        // Main container
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              return Column(
                children: [
                  SettingsTile(
                    item: items[index],
                    iconBackgroundColor: iconBackgroundColor,
                  ),
                  if (index != items.length - 1) ...[
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 33),
                      height: 1,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
