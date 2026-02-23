import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/models/ride_model.dart';

class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.rideModel,
    this.showContacts = true,
    this.showFare = false,
  });

  final RideModel rideModel;
  final bool showContacts;
  final bool showFare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: GBColor.borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// PROFILE IMAGE
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: ClipOval(
              child: Image.asset(GBImagePath.profile, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),

          /// DRIVER INFO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rideModel.driverName ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: GBColor.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Verified Rider',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: GBColor.primary,
                ),
              ),
            ],
          ),

          const Spacer(),

          /// 🔹 RIGHT SIDE (DYNAMIC)
          if (showFare) _FareChip(amount: rideModel.fare),

          if (showContacts) ...[
            ContactWidget(
              icon: Icons.message,
              color: GBColor.black,
              bgColor: GBColor.secondary,
            ),
            const SizedBox(width: 12),
            ContactWidget(
              icon: Icons.phone,
              color: GBColor.secondary,
              bgColor: GBColor.primary,
            ),
          ],
        ],
      ),
    );
  }
}

class ContactWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  const ContactWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: GBColor.borderColor, width: 1),
      ),
      child: ClipOval(child: Icon(icon, color: color)),
    );
  }
}

class _FareChip extends StatelessWidget {
  final double amount;
  const _FareChip({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: GBColor.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GBColor.primary),
      ),
      child: Text(
        'PKR ${amount.toInt()}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: GBColor.primary,
        ),
      ),
    );
  }
}
