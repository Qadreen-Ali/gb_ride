import 'package:flutter/material.dart';
import '../../../../../utils/constants/color_string.dart';

class HeadingText extends StatelessWidget {
  final String titleText;

  const HeadingText({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        color: GBColor.gray,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    );
  }
}
