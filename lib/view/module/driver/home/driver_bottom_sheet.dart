import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/driver/home/widgets/offer_fare_card.dart';
import 'package:gb_ride/models/ride_model.dart';

class DriverBottomSheet extends StatefulWidget {
  final VoidCallback? onOfferTap;
  final VoidCallback? onOfferClose;

  const DriverBottomSheet({super.key, this.onOfferTap, this.onOfferClose});

  @override
  State<DriverBottomSheet> createState() => _DriverBottomSheetState();
}

class _DriverBottomSheetState extends State<DriverBottomSheet> {
  final List<RideModel> mockRides = [
    RideModel(
      rideId: 'r1',
      localId: 'local1',
      pickupLocation: 'Noor Plaza, Gilgit',
      destinationLocation: 'Jutial, Gilgit',
      pickupLat: 35.9176,
      pickupLng: 74.3149,
      destLat: 35.9200,
      destLng: 74.3200,
      distanceKm: 3.4,
      etaMinutes: 8,
      fare: 200,
      driverName: 'Hassan',
      driverImagePath: 'assets/images/profile.png',
      createdAt: DateTime.now(),
    ),
    RideModel(
      rideId: 'r2',
      localId: 'local2',
      pickupLocation: 'KIU Road',
      destinationLocation: 'Baseen',
      pickupLat: 35.9100,
      pickupLng: 74.3100,
      destLat: 35.9300,
      destLng: 74.3300,
      distanceKm: 5.1,
      etaMinutes: 12,
      fare: 350,
      driverName: 'Hassan',
      driverImagePath: 'assets/images/profile.png',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          /// Drag handle
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          /// LIST
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: mockRides.length,
              itemBuilder: (context, index) {
                return OfferFareCard(
                  rideModel: mockRides[index],
                  onOfferTap: widget.onOfferTap,
                  onOfferClose: widget.onOfferClose,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
