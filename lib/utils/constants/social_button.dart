import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class SocialSignInButton extends StatelessWidget {
  // We mirror the parameters used in your SecondaryButton,
  // even if title/textColor aren't visually used for the icon-only look.
  final String
  title; // Required by your template, but we will ignore it in the build
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? textColor; // Ignored for the icon-only look
  final Widget? leadingIcon; // This holds the Google/Apple Icon/Image

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 92,
      height: height ?? 68,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: textColor ?? GBColor.containerGrayColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
          side: BorderSide(
            color: borderColor ?? GBColor.containerColor,
            width: 1.8,
          ),
          padding: EdgeInsets.zero, // ← Remove padding so image fills button
        ),
        child: leadingIcon,
      ),
    );
  }
}
