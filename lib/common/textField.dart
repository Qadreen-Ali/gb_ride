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
  final Color? titleTextColor; // ✅ Custom text color

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
    this.textColor, this.titleTextColor, // ✅ Added
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
        // Text(
        //   widget.,
        //   style: TextStyle(
        //     color: widget.titleTextColor ??
        //         GBColor.gray,
        //     fontSize: 14,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        const SizedBox(height: 8),
        SizedBox(
          width: 378,
          height: 54,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            style: TextStyle(
              color: widget.textColor ??
                  GBColor.textFieldText, // ✅ Use custom color if provided
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: GBColor.textFieldText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: GBColor.textFieldText.withOpacity(0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: GBColor.textFieldText.withOpacity(0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: GBColor.textFieldText),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
