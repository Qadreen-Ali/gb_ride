import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';

class RideFlowScreen extends StatefulWidget {
  final String? pickupLocation;
  final String? destinationLocation;
  final String? distanceKm;
  final String? etaMinutes;

  const RideFlowScreen({
    super.key,
    this.pickupLocation,
    this.destinationLocation,
    this.distanceKm,
    this.etaMinutes,
  });

  @override
  State<RideFlowScreen> createState() => _RideFlowScreenState();
}

class _RideFlowScreenState extends State<RideFlowScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
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
              const SizedBox(height: 20),

              // Driver Profile Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: GBColor.borderColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Profile Picture
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          GBImagePath.profile, // Replace with actual image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Driver Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hassan',
                          style: TextStyle(
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
                    const SizedBox(width: 80),
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
                ),
              ),
              const SizedBox(height: 16),

              // Location Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: GBColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: GBColor.secondary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: GBColor.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.pickupLocation ?? 'Pickup',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: GBColor.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.destinationLocation ?? 'Destination',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Center(
                      child: Text(
                        '${double.tryParse(widget.distanceKm ?? '0')?.toStringAsFixed(1) ?? '0'} km',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Message Buttons
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        title: 'Message',
                        leadingIcon: const Icon(
                          Icons.message,
                          size: 18,
                          color: GBColor.black,
                        ),
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        textColor: GBColor.black,
                        borderColor: GBColor.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SecondaryButton(
                        title: 'Call',
                        leadingIcon: const Icon(
                          Icons.phone,
                          size: 18,
                          color: GBColor.black,
                        ),
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        textColor: GBColor.black,
                        borderColor: GBColor.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Arrived Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: 'Arrived',
                  onPressed: () {},
                  backgroundColor: GBColor.primary,
                  textColor: GBColor.secondary,
                  fontsize: 16,
                ),
              ),
            ],
          ),
        ),
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
