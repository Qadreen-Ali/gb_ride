import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor; // ✅ NEW
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;
  final String? trailingText;

  const NotificationTile({
    super.key,
    required this.icon,
    this.iconColor = GBColor.secondary, // default
    this.iconBgColor = GBColor.primary, // default
    required this.title,
    required this.subtitle,
    required this.time,
    this.unread = false,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// 🔹 UNREAD INDICATOR
          if (unread)
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: GBColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),

          /// 🔹 OPTIONAL TRAILING TEXT
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(trailingText!, style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
