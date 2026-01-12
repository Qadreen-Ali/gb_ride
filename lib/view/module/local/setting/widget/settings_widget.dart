import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

/// ----------------- SETTINGS ITEM MODEL -----------------
class SettingsItem {
  final IconData? icons;
  final String? iconPath;
  final String title;
  final String? subtitle;
  final String? answer; // for FAQ items
  final bool isFaq; // true for FAQ
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? arrowColor;
  final IconData? arrowIcon;
  final double iconVerticalOffset;

  const SettingsItem({
    this.icons,
    this.iconPath,
    required this.title,
    this.subtitle,
    this.answer,
    this.isFaq = false,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.arrowColor,
    this.arrowIcon,
    this.iconVerticalOffset = 0.0,
  });
}

/// ----------------- SETTINGS TILE -----------------
class SettingsTile extends StatelessWidget {
  final SettingsItem item;
  final bool isExpanded; // ✅ FAQ expansion handled from screen
  final Color iconBackgroundColor;

  const SettingsTile({
    super.key,
    required this.item,
    required this.isExpanded,
    this.iconBackgroundColor = GBColor.gray,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      splashColor: Colors.transparent, // removes blue flash
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- FAQ ITEM (ONLY TEXT) -------------
            if (item.isFaq)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: item.textColor ?? GBColor.gray,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: item.arrowColor ?? GBColor.gray,
                  ),
                ],
              )
            /// ---------- NORMAL SETTINGS (UNCHANGED) -------------
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, item.iconVerticalOffset),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: iconBackgroundColor,
                      child: item.iconPath != null
                          ? Image.asset(
                              item.iconPath!,
                              width: 24,
                              height: 24,
                              color: item.iconColor,
                            )
                          : item.icons != null
                          ? Icon(
                              item.icons,
                              color: item.iconColor ?? GBColor.secondary,
                              size: 16,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: item.textColor ?? GBColor.gray,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: GBColor.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.subtitle!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: GBColor.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    item.arrowIcon ?? Icons.arrow_forward_ios,
                    size: 16,
                    color: item.arrowColor ?? GBColor.gray,
                  ),
                ],
              ),

            /// ---------- FAQ ANSWER -------------
            if (item.isFaq && isExpanded && item.answer != null) ...[
              const SizedBox(height: 8),
              Text(
                item.answer!,
                style: const TextStyle(fontSize: 14, color: GBColor.black),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ----------------- SETTINGS SINGLE CONTAINER -----------------
class SettingsSingleContainer extends StatelessWidget {
  final SettingsItem item;
  final bool isExpanded; // ✅ only used for FAQ
  final Color iconBackgroundColor;
  final double width;
  final double height;

  const SettingsSingleContainer({
    super.key,
    required this.item,
    required this.isExpanded,
    this.iconBackgroundColor = GBColor.gray,
    this.width = double.infinity,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: SettingsTile(
        item: item,
        isExpanded: isExpanded,
        iconBackgroundColor: iconBackgroundColor,
      ),
    );
  }
}
