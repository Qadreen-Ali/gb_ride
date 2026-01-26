import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class VehicleOptionCard extends StatelessWidget {
  final String type;
  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;
  final int capacity;

  const VehicleOptionCard({
    super.key,
    required this.type,
    required this.label,
    required this.iconPath,
    required this.capacity,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected
        ? GBColor.primary
        : Colors.grey.shade300;
    final Color bgColor = isSelected
        ? GBColor.selectedContainerColor.withValues(alpha: 0.3)
        : GBColor.secondary;
    // final Color iconColor = isSelected ? Colors.orange : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                height: 40,
                width: 60,
                // color: isSelected ? Colors.orange : null,
              ),

              // const SizedBox(height: 2),
              // Text(
              //   label,
              //   style: TextStyle(
              //     fontSize: 11,
              //     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              //     color: Colors.black,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 12,
                    color: isSelected ? GBColor.black : Colors.grey,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    capacity.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: ),
            ],
          ),
        ),
      ),
    );
  }
}
