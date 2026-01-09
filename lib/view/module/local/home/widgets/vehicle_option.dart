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
    final Color borderColor = isSelected ? Colors.orange : Colors.grey.shade300;
    final Color bgColor = isSelected
        ? Colors.orange.shade50
        : GBColor.secondary;
    final Color iconColor = isSelected ? Colors.orange : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                height: 40,
                width: 40,
                color: isSelected ? Colors.orange : null,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 12, color: Colors.grey),
                  const SizedBox(width: 2),
                  Text(
                    capacity.toString(),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
