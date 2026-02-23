import 'package:get/get.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:gb_ride/services/ride_services/ride_service.dart';
import 'package:gb_ride/services/map_services/location_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverController extends GetxController {
  final rideService = RideService.instance;
  final locationService = LocationService.instance;
  final supabase = Supabase.instance.client;

  // Observable state
  final Rx<RideModel?> activeRide = Rx<RideModel?>(null);
  final RxList<Map<String, dynamic>> incomingRequests =
      <Map<String, dynamic>>[].obs;
  final RxBool isOnline = false.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, double> driverLocation = <String, double>{}.obs;

  late String _driverId;

  @override
  void onInit() {
    super.onInit();
    _driverId = supabase.auth.currentUser?.id ?? '';
  }

  /// GO ONLINE: Start accepting rides
  Future<void> goOnline() async {
    try {
      isLoading.value = true;

      // Update driver status
      await supabase
          .from('drivers')
          .update({'is_online': true})
          .eq('auth_id', _driverId);

      // Start broadcasting location
      locationService.startLocationBroadcast(
        userId: _driverId,
        userType: 'driver',
      );

      // Listen to incoming ride requests
      _listenToIncomingRequests();

      isOnline.value = true;
      Get.snackbar('🟢 Online', 'You are now accepting rides');
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// GO OFFLINE
  Future<void> goOffline() async {
    try {
      // Stop location broadcasting
      locationService.stopLocationBroadcast();

      // Update driver status
      await supabase
          .from('drivers')
          .update({'is_online': false})
          .eq('auth_id', _driverId);

      isOnline.value = false;
      Get.snackbar('🔴 Offline', 'You stopped accepting rides');
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    }
  }

  /// Listen to incoming ride requests in real-time
  void _listenToIncomingRequests() {
    rideService.watchRideRequests(_driverId).listen((requests) {
      incomingRequests.value = requests;

      if (requests.isNotEmpty) {
        Get.snackbar('🔴 New ride request!', 'Tap to view');
      }
    });
  }

  /// ACCEPT RIDE
  Future<void> acceptRide(
    String rideId,
    String driverName,
    String driverPhone,
  ) async {
    try {
      isLoading.value = true;

      await rideService.acceptRide(
        rideId: rideId,
        driverId: _driverId,
        driverName: driverName,
        driverPhone: driverPhone,
      );

      // Load the accepted ride
      rideService.watchRide(rideId).listen((ride) {
        activeRide.value = ride;
      });

      Get.snackbar('✅ Ride accepted!', 'Head to pickup location');
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// REJECT RIDE
  Future<void> rejectRide(String rideId) async {
    try {
      await rideService.rejectRide(rideId);
      Get.snackbar('Ride rejected', '');
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    }
  }

  /// Update ride status (onWay, ongoing, completed)
  Future<void> updateRideStatus(RideStatus status) async {
    if (activeRide.value == null) return;

    try {
      await rideService.updateRideStatus(activeRide.value!.rideId, status);
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    }
  }

  /// Complete ride
  Future<void> completeRide() async {
    if (activeRide.value == null) return;

    try {
      await rideService.updateRideStatus(
        activeRide.value!.rideId,
        RideStatus.completed,
      );
      activeRide.value = null;
    } catch (e) {
      Get.snackbar('❌ Error', e.toString());
    }
  }
}
