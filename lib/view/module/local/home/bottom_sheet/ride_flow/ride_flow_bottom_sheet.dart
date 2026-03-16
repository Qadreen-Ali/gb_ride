import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../utils/constants/color_string.dart';
import '../../../../../../utils/constants/primary_button.dart';
import '../../../controller/ride_controller.dart';
import '../../../../../../models/ride_model.dart';

/// Inline bottom sheet shown during an active ride.
/// Displays real driver info, pickup/destination, fare, and status-based actions.
/// NOT a modal — swapped in by the home screen based on RideController.isInRide.
class RideFlowBottomSheet extends StatelessWidget {
  final VoidCallback? onCancelled;

  const RideFlowBottomSheet({super.key, this.onCancelled});

  @override
  Widget build(BuildContext context) {
    final rideCtrl = Get.find<RideController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(GBSizes.cardRadiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final ride = rideCtrl.currentRide.value;
        if (ride == null) return const SizedBox(height: 80);

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ─── Drag handle ───
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ─── Status header ───
                _buildStatusHeader(ride.status),
                const SizedBox(height: 16),

                // ─── Driver info card ───
                _buildDriverCard(ride),
                const SizedBox(height: 14),

                // ─── Pickup & Destination ───
                _buildLocations(ride),
                const SizedBox(height: 14),

                // ─── Fare row ───
                _buildFareRow(ride),
                const SizedBox(height: 20),

                // ─── Action buttons ───
                ..._buildActions(ride, rideCtrl),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─── Status Header ─────────────────────────────────────

  Widget _buildStatusHeader(RideStatus status) {
    final cfg = _statusCfg(status);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cfg.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(cfg.icon, color: cfg.color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cfg.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: GBColor.black,
                ),
              ),
              if (cfg.subtitle != null)
                Text(
                  cfg.subtitle!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Driver Card ───────────────────────────────────────

  Widget _buildDriverCard(RideModel ride) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GBColor.containerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GBColor.borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: GBColor.primary,
            child: Text(
              (ride.driverName ?? 'D')[0].toUpperCase(),
              style: const TextStyle(
                color: GBColor.secondary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride.driverName ?? 'Driver',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: GBColor.black,
                  ),
                ),
                if (ride.driverPhone?.isNotEmpty == true)
                  Text(
                    ride.driverPhone!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins',
                    ),
                  ),
              ],
            ),
          ),
          if (ride.driverPhone?.isNotEmpty == true)
            GestureDetector(
              onTap: () {
                // TODO: url_launcher phone call
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone, color: Colors.green, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Locations ─────────────────────────────────────────

  Widget _buildLocations(RideModel ride) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GBColor.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _locationRow(Colors.green, ride.pickupLocation),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              children: List.generate(
                3,
                (_) => Container(
                  width: 2,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          _locationRow(Colors.red, ride.destinationLocation),
        ],
      ),
    );
  }

  Widget _locationRow(Color dotColor, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: GBColor.black,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Fare Row ──────────────────────────────────────────

  Widget _buildFareRow(RideModel ride) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: GBColor.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Agreed Fare',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            ride.formattedFare,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: GBColor.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Action Buttons ────────────────────────────────────

  List<Widget> _buildActions(RideModel ride, RideController ctrl) {
    switch (ride.status) {
      case RideStatus.accepted:
      case RideStatus.onWay:
      case RideStatus.waiting:
        return [
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: 'Cancel Ride',
              onPressed: () {
                ctrl.cancelRide();
                onCancelled?.call();
              },
              backgroundColor: GBColor.black.withValues(alpha: 0.06),
              textColor: Colors.red,
            ),
          ),
        ];
      case RideStatus.ongoing:
        return [
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: 'SOS Emergency',
              onPressed: () {
                // TODO: SOS functionality
              },
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
          ),
        ];
      default:
        return [];
    }
  }

  // ─── Status Config ─────────────────────────────────────

  _StatusCfg _statusCfg(RideStatus status) {
    switch (status) {
      case RideStatus.accepted:
        return _StatusCfg(
          title: 'Driver Assigned',
          subtitle: 'Preparing to pick you up',
          icon: Icons.check_circle_outline,
          color: GBColor.primary,
        );
      case RideStatus.onWay:
        return _StatusCfg(
          title: 'Driver on the Way',
          subtitle: 'Heading to your pickup location',
          icon: Icons.directions_car,
          color: Colors.blue,
        );
      case RideStatus.waiting:
        return _StatusCfg(
          title: 'Driver Arrived',
          subtitle: 'Waiting at your pickup location',
          icon: Icons.location_on,
          color: Colors.orange,
        );
      case RideStatus.ongoing:
        return _StatusCfg(
          title: 'Trip in Progress',
          subtitle: 'Enjoy your ride!',
          icon: Icons.navigation,
          color: Colors.green,
        );
      default:
        return _StatusCfg(
          title: 'Ride',
          icon: Icons.directions_car,
          color: Colors.grey,
        );
    }
  }
}

class _StatusCfg {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  _StatusCfg({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
  });
}
