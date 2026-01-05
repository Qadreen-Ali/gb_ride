import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class VehicleOptionCard extends StatelessWidget {
  final String type;
  final String label;
  final ImageProvider image;
  final bool isSelected;
  final VoidCallback onTap;
  final int capacity;

  const VehicleOptionCard({
    super.key,
    required this.type,
    required this.label,
    required this.image,
    required this.isSelected,
    required this.onTap,
    this.capacity = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        height: 69,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade50 : GBColor.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : GBColor.secondary!,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: image,
                width: 60,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.black,
                  ),
                  Text(
                    capacity.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
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
