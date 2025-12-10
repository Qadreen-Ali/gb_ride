import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final Widget? leadingIcon;

  const SecondaryButton({
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
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? GBColor.primary,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 14.2,
                fontWeight: FontWeight.w400,
                color: textColor ?? GBColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
