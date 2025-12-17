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
    return SizedBox(
      width: width ?? 358,
      height: height ?? 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? GBColor.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            side: BorderSide(color: borderColor ?? GBColor.primary),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontsize ?? 16,
            fontWeight: weight ?? FontWeight.w600,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
