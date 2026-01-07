import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class LocationInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onTap;
  final VoidCallback onMapIconPressed;

  const LocationInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconData,
    required this.iconColor,
    required this.onTap,
    required this.onMapIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: GBColor.borderColor),
        ),
        child: Row(
          children: [
            Icon(iconData, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                controller.text.isEmpty ? hintText : controller.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: controller.text.isEmpty ? Colors.grey : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.map, size: 20),
              onPressed: onMapIconPressed,
            ),
          ],
        ),
      ),
    );
  }
}
