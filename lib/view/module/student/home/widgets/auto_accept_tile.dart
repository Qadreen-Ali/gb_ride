import 'package:flutter/material.dart';

import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/text_string.dart';
class AutoAcceptTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AutoAcceptTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GBColor.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                GBText.automaticallyAcceptTheNearestDriver,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Switch(
              value: value,
              activeColor: GBColor.primary,
              inactiveTrackColor: GBColor.borderColor,
              inactiveThumbColor: GBColor.secondary,
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}