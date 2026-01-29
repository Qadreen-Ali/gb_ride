import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/app_sizes.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

/// ----------------- SETTINGS ITEM MODEL -----------------
class SettingsItem {
  final IconData? icons;
  final String? iconPath;
  final String title;
  final String? extraText; // text in front of title
  final String? subtitle;
  final String? answer; // for FAQ items
  final bool isFaq; // true for FAQ
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? arrowColor;
  final IconData? arrowIcon;
  final double iconVerticalOffset;
  final Color? iconBgColor;
  final bool showArrow;

  const SettingsItem({
    this.icons,
    this.iconPath,
    required this.title,
    this.extraText,
    this.subtitle,
    this.answer,
    this.isFaq = false,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.arrowColor,
    this.arrowIcon,
    this.iconVerticalOffset = 0.0,
    this.iconBgColor,
    this.showArrow = true,
  });
}

/// ----------------- SETTINGS TILE -----------------
class SettingsTile extends StatelessWidget {
  final SettingsItem item;
  final bool isExpanded; // FAQ expansion handled from screen
  final Color iconBackgroundColor;

  const SettingsTile({
    super.key,
    required this.item,
    required this.isExpanded,
    this.iconBackgroundColor = GBColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- FAQ ITEM (ONLY TEXT) ----------
            if (item.isFaq)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        // fontSize: 16,
                        fontSize: GBSizes.fontSizeMd,
                        fontWeight: FontWeight.w500,
                        color: item.textColor ?? GBColor.gray,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    // size: 16,
                    size: GBSizes.iconSm,
                    color: item.arrowColor ?? GBColor.gray,
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Transform.translate(
                    offset: Offset(0, item.iconVerticalOffset),
                    child: CircleAvatar(
                      radius: GBSizes.borderRadiusLg,
                      backgroundColor: item.iconBgColor ?? iconBackgroundColor,
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
                              // size: 16,
                              size: GBSizes.iconSm,
                            )
                          : const SizedBox(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Two independent Columns: left = title+subtitle, right = extraText+dot
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column 1: Title + Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: GBSizes.fontSizeMd,
                                  fontWeight: FontWeight.w500,
                                  color: item.textColor ?? GBColor.gray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (item.subtitle != null)
                                Text(
                                  item.subtitle!,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: GBSizes.fontSizeESm,
                                    color: GBColor.black,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Column 2: Extra Text + Dot
                        if (item.extraText != null)
                          SizedBox(
                            width: 85, // 🔒 FIXED WIDTH (adjust if needed)
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end, // ⬅️ align to end
                              children: [
                                Text(
                                  item.extraText!,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    // fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: GBColor.gray,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: GBColor.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  if (item.showArrow)
                    Icon(
                      item.arrowIcon ?? Icons.arrow_forward_ios,
                      size: GBSizes.iconSm,
                      color: item.arrowColor ?? GBColor.gray,
                    ),
                ],
              ),

            // ---------- FAQ ANSWER ----------
            if (item.isFaq && isExpanded && item.answer != null) ...[
              const SizedBox(height: 8),
              Text(
                item.answer!,
                style: const TextStyle(
                  fontSize: GBSizes.fontSizeSm,
                  color: GBColor.black,
                ),
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
  final bool isExpanded; // only used for FAQ
  final Color iconBackgroundColor;
  final double width;
  final double height;

  const SettingsSingleContainer({
    super.key,
    required this.item,
    required this.isExpanded,
    this.iconBackgroundColor = GBColor.lightGray,
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
