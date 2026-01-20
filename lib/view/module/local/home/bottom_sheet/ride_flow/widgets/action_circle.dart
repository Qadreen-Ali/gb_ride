import 'package:flutter/material.dart';

import '../../../../../../../utils/constants/color_string.dart';
class ActionCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ActionCircle({super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14),
      child: SizedBox(
        width: 86, // fixed width so row never overflows
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: GBColor.driverContainerColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: GBColor.secondary),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}