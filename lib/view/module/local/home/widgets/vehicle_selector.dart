import 'package:flutter/material.dart';

class VehicleSelector extends StatelessWidget {
  final String selectedVehicle;
  final Function(String) onVehicleSelected;

  const VehicleSelector({
    super.key,
    required this.selectedVehicle,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVehicleOption('car', '🚗', 'Car'),
        _buildVehicleOption('city', '🏙️', 'City to city'),
        _buildVehicleOption('bike', '🏍️', 'Bike'),
      ],
    );
  }

  Widget _buildVehicleOption(String type, String emoji, String label) {
    bool isSelected = selectedVehicle == type;
    return GestureDetector(
      onTap: () => onVehicleSelected(type),
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade50 : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: 2,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.orange : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
