import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/ride_flow_screen.dart';
import 'package:gb_ride/view/module/driver/models/ride_model.dart';

class DriverCommonItemWidget extends StatelessWidget {
  final RideModel rideModel;

  const DriverCommonItemWidget({super.key, required this.rideModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// DRIVER CARD
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
                  child: Image.asset(GBImagePath.profile, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),

              // Driver Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rideModel.driverName,
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

        /// LOCATION CARD
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
                      rideModel.pickupLocation,
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
                      rideModel.destinationLocation,
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
              Text(
                rideModel.formattedDistance,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
