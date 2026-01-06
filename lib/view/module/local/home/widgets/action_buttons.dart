import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ActionButtons extends StatelessWidget {
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final String selectedVehicle;
  final VoidCallback onChatPressed;
  final VoidCallback onNavigationPressed;

  const ActionButtons({
    super.key,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.selectedVehicle,
    required this.onChatPressed,
    required this.onNavigationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
            ),
            onPressed: onChatPressed,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleFindDriver(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Find a Driver',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.navigation,
              color: Colors.white,
            ),
            onPressed: onNavigationPressed,
          ),
        ),
      ],
    );
  }

  void _handleFindDriver(BuildContext context) {
    if (pickupLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pickup location'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (destinationLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a destination'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Searching for $selectedVehicle drivers...',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
