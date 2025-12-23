import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class FormButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? prefixIcon;
  final double width;
  final double height;
  final bool isSelected;

  const FormButton({
    super.key,
    required this.title,
    this.onPressed,
    this.enabled = true,
    this.prefixIcon,
    this.width = 110,
    this.height = 48,
    this.isSelected = false,
  });

  @override
  State<FormButton> createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.enabled
              ? GBColor.secondary
              : GBColor.gray.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected ? GBColor.primary : GBColor.lineColor,
            width: 1.2,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: GBColor.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),

        // 👇 CONTENT (ICON + TEXT)
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              widget.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: widget.isSelected ? GBColor.primary : GBColor.gray,
              ),
            ),
            const SizedBox(width: 6),
            if (widget.prefixIcon != null) ...[widget.prefixIcon!],
          ],
        ),
      ),
    );
  }
}
