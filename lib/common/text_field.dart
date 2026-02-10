import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class TTextField extends StatelessWidget {
  final String titleText;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Color? textColor;
  final Color? titleTextColor;
  final Color? hintTextColor;

  const TTextField({
    super.key,
    required this.titleText,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.textColor,
    this.titleTextColor,
    this.hintTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleText.isNotEmpty)
          Text(
            titleText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleTextColor ?? GBColor.gray,
            ),
          ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          validator: validator,
          inputFormatters: inputFormatters,
          style: TextStyle(
            color: textColor ?? GBColor.textFieldText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: GBColor.secondary,
            hintText: hintText,
            hintStyle: TextStyle(
              color: hintTextColor ?? GBColor.textFieldText,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GBColor.lineColor.withValues(alpha: 0.4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GBColor.textFieldText.withValues(alpha: 0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: GBColor.primary),
            ),

            // 🔥 REQUIRED FOR VALIDATION UI
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),

            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: prefixIcon,
                  ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
