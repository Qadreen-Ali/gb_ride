import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class TTextField extends StatefulWidget {
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
  final Color? textColor; // ✅ Custom text color
  final Color? titleTextColor;
  final Color? hintTextColor;

  final dynamic prefix; // ✅ Custom text color

  const TTextField({
    super.key,
    required this.titleText,
    required this.hintText,
    this.hintTextColor,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.enabled = true,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.textColor,
    this.titleTextColor,
    ValueChanged<String>? onChanged,
  });

  @override
  State<TTextField> createState() => _TTextFieldState();
}

class _TTextFieldState extends State<TTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleText != null && widget.titleText!.isNotEmpty)
          Text(
            widget.titleText!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: GBColor.gray,
            ),
          ),

        const SizedBox(height: 10),
        SizedBox(
          width: 378,
          height: 48,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            textAlign: TextAlign.start,
            onTap: widget.onTap,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            style: TextStyle(
              color:
                  widget.textColor ??
                  GBColor.textFieldText, // ✅ Use custom color if provided
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              filled: true,
              fillColor: GBColor.secondary,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: widget.hintTextColor ?? GBColor.textFieldText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 18,
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
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: widget.prefixIcon,
                    ),

              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
