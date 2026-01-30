import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';

class OngoingTripWidget extends StatelessWidget {
  final Duration timeLeft;
  final double distanceLeftKm;
  final VoidCallback onEndTrip;
  final VoidCallback onSOS;

  const OngoingTripWidget({
    super.key,
    required this.timeLeft,
    required this.distanceLeftKm,
    required this.onEndTrip,
    required this.onSOS,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    return '$minutes min';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TIME + DISTANCE ROW
        Row(
          children: [
            Expanded(
              child: _InfoBox(
                title: 'Time Left',
                value: _formatDuration(timeLeft),
                icon: Icons.access_time,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoBox(
                title: 'Distance Left',
                value: '${distanceLeftKm.toStringAsFixed(1)} km',
                icon: Icons.location_on,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ACTION BUTTONS
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                title: 'SOS',
                onPressed: onSOS,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontsize: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                title: 'End Trip',
                onPressed: onEndTrip,
                backgroundColor: GBColor.primary,
                textColor: GBColor.secondary,
                fontsize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//infobox
class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GBColor.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: GBColor.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: GBColor.black),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
