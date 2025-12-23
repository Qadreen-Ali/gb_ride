import 'package:flutter/material.dart';
import 'color_string.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final double? fontsize;
  final FontWeight? weight;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.fontsize,
    this.weight,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      width: width ?? 378,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              // ignore: deprecated_member_use
              ? GBColor.secondary.withOpacity(0.5)
              : (backgroundColor ?? GBColor.secondary),
          foregroundColor: isDisabled
              // ignore: deprecated_member_use
              ? Colors.black.withOpacity(0.5)
              : (textColor ?? Colors.black),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            side: BorderSide(
              color: isDisabled
                  // ignore: deprecated_member_use
                  ? GBColor.secondary.withOpacity(0.5)
                  : (borderColor ?? GBColor.secondary),
            ),
          ),
          // ignore: deprecated_member_use
          disabledBackgroundColor: GBColor.secondary.withOpacity(0.5),
          // ignore: deprecated_member_use
          disabledForegroundColor: Colors.black.withOpacity(0.5),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontsize ?? 16,
            fontWeight: weight ?? FontWeight.w600,
            color: isDisabled
                // ignore: deprecated_member_use
                ? Colors.black.withOpacity(0.5)
                : (textColor ?? GBColor.black),
          ),
        ),
      ),
    );
  }
}
