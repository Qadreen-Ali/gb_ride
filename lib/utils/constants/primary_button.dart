import 'package:flutter/material.dart';
import 'color_string.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Widget? child; // 👈 NEW
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
    this.child,
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
              ? GBColor.secondary.withValues(alpha: 0.5)
              : (backgroundColor ?? GBColor.secondary),
          foregroundColor: isDisabled
              ? Colors.black.withValues(alpha: 0.5)
              : (textColor ?? Colors.black),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            side: BorderSide(
              color: isDisabled
                  ? GBColor.secondary.withValues(alpha: 0.5)
                  : (borderColor ?? GBColor.secondary),
            ),
          ),
          disabledBackgroundColor: GBColor.secondary.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.black.withValues(alpha: 0.5),
        ),
        child:
            child ??
            Text(
              title,
              style: TextStyle(
                fontSize: fontsize ?? 16,
                fontFamily: 'Poppins',
                fontWeight: weight ?? FontWeight.w600,
                color: isDisabled
                    ? Colors.black.withValues(alpha: 0.5)
                    : (textColor ?? GBColor.black),
              ),
              maxLines: 1,
            ),
      ),
    );
  }
}
