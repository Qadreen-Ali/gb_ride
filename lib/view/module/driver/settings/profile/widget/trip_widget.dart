import 'package:flutter/material.dart';

import '../../../../../../utils/constants/color_string.dart';
class Tripwidget extends StatelessWidget {
  final String text1;
  final String text2;

  const Tripwidget({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(color: GBColor.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text1,
            style: TextStyle(
              color: GBColor.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            text2,
            style: TextStyle(
              color: GBColor.gray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}