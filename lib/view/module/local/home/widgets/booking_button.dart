import 'package:flutter/material.dart';

import '../../../../../utils/constants/color_string.dart';
class BookingsButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const BookingsButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: GBColor.primary,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: GBColor.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}