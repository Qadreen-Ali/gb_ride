import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gb_ride/models/ride_offer_model.dart';
import 'package:gb_ride/view/module/local/controller/ride_controller.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

/// Overlay that shows incoming driver offer cards at the top of the home screen.
/// Each card has driver info, offered fare, ETA, and Decline / Accept buttons.
class DriverOfferOverlay extends StatelessWidget {
  final VoidCallback? onAccepted;

  const DriverOfferOverlay({super.key, this.onAccepted});

  @override
  Widget build(BuildContext context) {
    final rideController = Get.find<RideController>();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 16,
      right: 16,
      child: Obx(() {
        final offers = rideController.incomingOffers;
        if (offers.isEmpty) return const SizedBox.shrink();

        return Column(
          children: offers
              .map((offer) => _OfferCard(offer: offer, onAccepted: onAccepted))
              .toList(),
        );
      }),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final RideOfferModel offer;
  final VoidCallback? onAccepted;

  const _OfferCard({required this.offer, this.onAccepted});

  @override
  Widget build(BuildContext context) {
    final rideController = Get.find<RideController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Driver avatar
              CircleAvatar(
                radius: 24,
                backgroundImage:
                    offer.driverImage != null && offer.driverImage!.isNotEmpty
                    ? NetworkImage(offer.driverImage!)
                    : const AssetImage('assets/images/profile.png')
                          as ImageProvider,
              ),
              const SizedBox(width: 12),

              // Driver name + rating + rides
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            offer.driverName ?? 'Driver',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          offer.formattedRating,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${offer.driverTotalRides})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${offer.driverTotalRides} rides',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Fare + ETA
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PKR ${offer.offeredFare.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${offer.etaMinutes} min',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Decline / Accept buttons
          Row(
            children: [
              // Decline
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    rideController.incomingOffers.removeWhere(
                      (o) => o.offerId == offer.offerId,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Accept
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await rideController.acceptOffer(offer);
                    onAccepted?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GBColor.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
