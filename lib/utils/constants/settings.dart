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
  final Color? headerColor;

  const SettingsItem({
    required this.icons,
    required this.title,
    required this.onTap,
    this.iconColor, // optional
    this.textColor,
    this.arrowColor,
    this.headerColor,
  });
}

/// Single tile with circular icon background (custom row for proper centering)
class SettingsTile extends StatelessWidget {
  final SettingsItem item;
  final Color iconBackgroundColor;

  const SettingsTile({
    super.key,
    required this.item,
    this.iconBackgroundColor = GBColor.gray,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: iconBackgroundColor,
              child: Icon(
                item.icons,
                color: item.iconColor ?? GBColor.secondary,
                size: 16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  color: item.textColor ?? GBColor.gray,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: item.arrowColor ?? GBColor.gray,
            ),
          ],
        ),
      ),
    );
  }
}

/// Single container for one settings item
class SettingsSingleContainer extends StatelessWidget {
  final SettingsItem item;
  final Color iconBackgroundColor;
  final double width;
  final double height;

  const SettingsSingleContainer({
    super.key,
    required this.item,
    this.iconBackgroundColor = GBColor.lineColor,
    this.width = 392,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: SettingsTile(item: item, iconBackgroundColor: iconBackgroundColor),
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
    this.iconBackgroundColor = GBColor.lineColor,
    this.width = 399,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title text
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: GBColor.gray,
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
                      color: Colors.black.withOpacity(0.2),
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
