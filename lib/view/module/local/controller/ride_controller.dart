import 'package:get/get.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:gb_ride/services/ride_services/ride_service.dart';
import 'package:gb_ride/services/map_services/location_service.dart';

class RideController extends GetxController {
  final rideService = RideService.instance;
  final locationService = LocationService.instance;

  // Observable state
  final Rx<RideModel?> currentRide = Rx<RideModel?>(null);
  final RxList<Map<String, dynamic>> nearbyDrivers =
      <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;

  /// LOCAL: Request a ride
  Future<void> requestRide(RideModel ride, String localId) async {
    try {
      isLoading.value = true;

      // Create ride in Supabase
      final rideId = await rideService.createRideRequest(
        ride.copyWith(rideId: DateTime.now().millisecondsSinceEpoch.toString()),
      );

      // Start listening to ride changes
      _listenToRide(rideId);

      // Start searching nearby drivers
      isSearching.value = true;
      final nearby = await rideService.findNearbyDrivers(
        lat: ride.pickupLat,
        lng: ride.pickupLng,
      );
      nearbyDrivers.value = nearby;

      Get.snackbar('✅ Ride requested', 'Searching for drivers...');
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Listen to real-time ride updates
  void _listenToRide(String rideId) {
    rideService.watchRide(rideId).listen((ride) {
      currentRide.value = ride;

      if (ride != null) {
        if (ride.status == RideStatus.accepted) {
          isSearching.value = false;
          Get.snackbar('🎉 Driver accepted!', 'Your ride is confirmed');
        } else if (ride.status == RideStatus.completed) {
          Get.snackbar('✅ Ride completed', 'Rate your driver');
        } else if (ride.status == RideStatus.cancelled) {
          Get.snackbar('❌ Ride cancelled', 'Searching for another driver');
        }
      }
    });
  }

  /// Cancel ride
  Future<void> cancelRide() async {
    if (currentRide.value == null) return;

    try {
      await rideService.cancelRide(currentRide.value!.rideId);
      currentRide.value = null;
      isSearching.value = false;
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    }
  }

  /// Complete ride (after reaching destination)
  Future<void> completeRide() async {
    if (currentRide.value == null) return;

    try {
      await rideService.updateRideStatus(
        currentRide.value!.rideId,
        RideStatus.completed,
      );
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    }
  }
}
