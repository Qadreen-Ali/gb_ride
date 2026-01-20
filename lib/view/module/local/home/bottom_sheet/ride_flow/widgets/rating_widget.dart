import 'package:flutter/material.dart';
import '../../../../../../../utils/constants/color_string.dart';
class RatingWidget extends StatelessWidget {
  final IconData icon;

  const RatingWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 14, color: GBColor.yellow);
  }
}