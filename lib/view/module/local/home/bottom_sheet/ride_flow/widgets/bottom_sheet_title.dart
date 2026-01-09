import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/view/module/local/home/widgets/bottom_sheet_title.dart
=======
import '../../../../../../../utils/constants/text_string.dart';
>>>>>>> d7243f8657b0dfc89ff87f98f6e9dc5b4324a05a:lib/view/module/local/home/bottom_sheet/ride_flow/widgets/bottom_sheet_title.dart

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
