import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

import 'app_sizes.dart';


class SocialSignInButton extends StatelessWidget {
  final String title; // (kept as you have it)
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final Widget? leadingIcon;

  const SocialSignInButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.textColor,
    this.leadingIcon,
  });

  double _scale(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final s = w / 390.0; // base design width
    return s.clamp(0.85, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    final s = _scale(context);

    return SizedBox(
      // ✅ using GBSizes + responsive scaling
      width: width ?? (92 * s),
      height: height ?? (68 * s),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: textColor ?? GBColor.containerGrayColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            borderRadius ?? BorderRadius.circular((GBSizes.buttonRadius + 13) * s), // 25 approx
          ),
          side: BorderSide(
            color: borderColor ?? GBColor.containerColor,
            width: (GBSizes.dividerHeight + 0.8) * s, // ~1.8
          ),
          padding: EdgeInsets.zero,
        ),

        child: leadingIcon == null
            ? const SizedBox.shrink()
            : Center(
          child: SizedBox(
            width: (GBSizes.iconLg) * s,  // 32
            height: (GBSizes.iconLg) * s, // 32
            child: FittedBox(
              fit: BoxFit.contain,
              child: leadingIcon!,
            ),
          ),
        ),
      ),
    );
  }
}
