import 'package:flutter/material.dart';

import '../../../../../utils/constants/color_string.dart';

class TabOption extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final Function(int) onTap;
  final String image;
  final String label;
  final String count;

  const TabOption({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.image,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 100,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? GBColor.secondary : Colors.white,
          border: Border.all(
            color: isSelected ?  GBColor.borderColor : Colors.white,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: 63,
              height: 35,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.black,
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}