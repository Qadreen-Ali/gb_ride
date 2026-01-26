import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class OnTheWayWidget extends StatefulWidget {
  const OnTheWayWidget({super.key});

  @override
  State<OnTheWayWidget> createState() => _OnTheWayWidgetState();
}

class _OnTheWayWidgetState extends State<OnTheWayWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'On the way to Pickup',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: GBColor.black,
          ),
        ),
        const SizedBox(height: 8),

        // Time Info
        Row(
          children: [
            const Text(
              '12min',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GBColor.black,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 14, color: Colors.grey.shade300),
            const SizedBox(width: 8),
            Text(
              '5 min estimate',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
