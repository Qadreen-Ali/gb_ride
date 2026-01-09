import 'package:flutter/material.dart';

class BottomSheetTopTitle extends StatelessWidget {
  final String tiltetext;
  final Image? image;

  const BottomSheetTopTitle({super.key, required this.tiltetext, this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          tiltetext,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        SizedBox(width: 60, height: 40, child: image!),
      ],
    );
  }
}
