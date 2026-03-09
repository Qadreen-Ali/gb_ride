import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/driver/home/widgets/offer_fare_card.dart';
import 'package:gb_ride/view/module/driver/controller/driver_controller.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:get/get.dart';

class DriverBottomSheet extends StatefulWidget {
  final VoidCallback? onOfferTap;
  final VoidCallback? onOfferClose;
  final void Function(
    double pickupLat,
    double pickupLng,
    double destLat,
    double destLng,
  )?
  onShowRide;

  const DriverBottomSheet({
    super.key,
    this.onOfferTap,
    this.onOfferClose,
    this.onShowRide,
  });

  @override
  State<DriverBottomSheet> createState() => _DriverBottomSheetState();
}

class _DriverBottomSheetState extends State<DriverBottomSheet> {
  final DriverController _driverController = Get.find<DriverController>();

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

          /// Go Online / Offline Toggle
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _driverController.isLoading.value
                      ? null
                      : () {
                          if (_driverController.isOnline.value) {
                            _driverController.goOffline();
                          } else {
                            _driverController.goOnline();
                          }
                        },
                  icon: Icon(
                    _driverController.isOnline.value
                        ? Icons.wifi_off
                        : Icons.wifi,
                  ),
                  label: _driverController.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _driverController.isOnline.value
                              ? 'Go Offline'
                              : 'Go Online',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _driverController.isOnline.value
                        ? Colors.red.shade400
                        : Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// LIST — Real-time ride requests from Supabase
          Flexible(
            child: Obx(() {
              if (!_driverController.isOnline.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'You are offline',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Go online to start receiving ride requests',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              final requests = _driverController.incomingRequests;

              if (requests.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'No ride requests nearby',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'New requests will appear here',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final rideMap = requests[index];
                  final ride = RideModel.fromMap(rideMap);

                  return OfferFareCard(
                    rideModel: ride,
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                    onShowRide: widget.onShowRide,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
