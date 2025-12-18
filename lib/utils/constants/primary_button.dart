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
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? GBColor.secondary,
          foregroundColor: textColor ?? Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            side: BorderSide(color: borderColor ?? GBColor.secondary),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontsize ?? 16,
            fontWeight: weight ?? FontWeight.w600,
            color: textColor ?? GBColor.black,
          ),
        ),
      ),
    );
  }
}
