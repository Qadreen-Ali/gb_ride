import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:gb_ride/models/ride_offer_model.dart';
import 'package:gb_ride/services/ride_services/ride_service.dart';
import 'package:gb_ride/services/map_services/location_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverController extends GetxController {
  final rideService = RideService.instance;
  final locationService = LocationService.instance;
  final supabase = Supabase.instance.client;

  // ─── Observable State ───────────────────────────────────
  final Rx<RideModel?> activeRide = Rx<RideModel?>(null);
  final RxList<Map<String, dynamic>> incomingRequests =
      <Map<String, dynamic>>[].obs;
  final RxBool isOnline = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSendingOffer = false.obs;

  // Driver profile info (loaded once on init)
  final RxString driverName = ''.obs;
  final RxString driverPhone = ''.obs;
  final RxString driverImage = ''.obs;
  final RxString driverDbId = ''.obs; // drivers table UUID (not auth_id)

  late String _authId;
  StreamSubscription? _requestsSubscription;
  StreamSubscription? _rideSubscription;
  StreamSubscription? _offerSubscription;
  Timer? _offerExpiryTimer;
  // ignore: unused_field
  String? _currentOfferId; // kept for future cancel-offer logic

  @override
  void onInit() {
    super.onInit();
    _authId = supabase.auth.currentUser?.id ?? '';
    _loadDriverProfile();
  }

  @override
  void onClose() {
    _requestsSubscription?.cancel();
    _rideSubscription?.cancel();
    _offerSubscription?.cancel();
    _offerExpiryTimer?.cancel();
    super.onClose();
  }

  // ─── Load Driver Profile ────────────────────────────────
  /// Fetch driver's name, phone, image from drivers table
  Future<void> _loadDriverProfile() async {
    try {
      final response = await supabase
          .from('drivers')
          .select()
          .eq('auth_id', _authId)
          .maybeSingle();

      if (response != null) {
        driverDbId.value = response['id']?.toString() ?? '';
        driverName.value = response['full_name'] ?? '';
        driverPhone.value = response['phone_number'] ?? '';
        driverImage.value = response['profile_image'] ?? '';
      }
    } catch (e) {
      // Profile load failed — will retry on goOnline
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ONLINE / OFFLINE
  // ═══════════════════════════════════════════════════════════

  /// GO ONLINE: Start receiving ride requests
  Future<void> goOnline() async {
    try {
      isLoading.value = true;

      // Ensure profile is loaded
      if (driverDbId.value.isEmpty) await _loadDriverProfile();

      // Update driver status in Supabase
      await supabase
          .from('drivers')
          .update({'is_online': true})
          .eq('id', driverDbId.value);

      // Start broadcasting GPS location
      locationService.startLocationBroadcast(
        userId: driverDbId.value,
        userType: 'driver',
      );

      // Listen to incoming ride requests
      _listenToIncomingRequests();

      isOnline.value = true;
      Get.snackbar('Online', 'You are now receiving ride requests');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// GO OFFLINE: Stop receiving requests
  Future<void> goOffline() async {
    try {
      locationService.stopLocationBroadcast();
      _requestsSubscription?.cancel();

      await supabase
          .from('drivers')
          .update({'is_online': false})
          .eq('id', driverDbId.value);

      incomingRequests.clear();
      isOnline.value = false;
      Get.snackbar('Offline', 'You stopped receiving ride requests');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════
  // INCOMING RIDE REQUESTS
  // ═══════════════════════════════════════════════════════════

  /// Listen to all ride requests with status 'requested'
  void _listenToIncomingRequests() {
    _requestsSubscription?.cancel();
    _requestsSubscription = rideService.watchRideRequests().listen((requests) {
      incomingRequests.value = requests;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // SEND OFFER (InDrive-style)
  // ═══════════════════════════════════════════════════════════

  /// Driver sends a fare offer to a ride request
  /// [rideId] — the ride to bid on
  /// [offeredFare] — the fare the driver proposes
  Future<void> sendOffer({
    required String rideId,
    required double offeredFare,
    int etaMinutes = 0,
  }) async {
    try {
      isSendingOffer.value = true;

      // Fetch real avg rating & total rides from DB
      final avgRating = await rideService.getDriverAverageRating(
        driverDbId.value,
      );
      final totalRides = await rideService.getDriverTotalRides(
        driverDbId.value,
      );

      // Build the offer
      final offer = RideOfferModel(
        offerId: '', // Supabase auto-generates
        rideId: rideId,
        driverId: driverDbId.value,
        driverName: driverName.value,
        driverPhone: driverPhone.value,
        driverImage: driverImage.value,
        driverRating: avgRating,
        driverTotalRides: totalRides,
        offeredFare: offeredFare,
        etaMinutes: etaMinutes,
        createdAt: DateTime.now(),
      );

      final offerId = await rideService.sendOffer(offer);
      _currentOfferId = offerId;

      Get.snackbar(
        'Offer Sent',
        'PKR ${offeredFare.toStringAsFixed(0)} — waiting for response (12s)',
      );

      // Watch if the local accepts this offer
      _watchMyOffer(offerId, rideId);

      // Start 12-second expiry timer
      _offerExpiryTimer?.cancel();
      _offerExpiryTimer = Timer(const Duration(seconds: 12), () {
        _onOfferExpired(offerId);
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSendingOffer.value = false;
    }
  }

  /// Called when the 12-second timer runs out without acceptance
  Future<void> _onOfferExpired(String offerId) async {
    _offerSubscription?.cancel();
    _offerExpiryTimer?.cancel();
    _currentOfferId = null;

    // Expire the offer in Supabase so hasDriverOffered returns false
    await rideService.expireOffer(offerId);

    Get.snackbar(
      'Offer Expired',
      'You can send a new offer with a different fare',
    );
  }

  /// Watch if the local accepted our offer
  void _watchMyOffer(String offerId, String rideId) {
    _offerSubscription?.cancel();
    _offerSubscription = rideService.watchMyOffer(offerId).listen((offer) {
      if (offer == null) return;

      if (offer.status == 'accepted') {
        _offerSubscription?.cancel();
        _offerExpiryTimer?.cancel();
        _currentOfferId = null;

        // Offer accepted! Start watching the ride
        _startWatchingRide(rideId);
        Get.snackbar('Ride Confirmed', 'Head to pickup location');
      } else if (offer.status == 'expired') {
        _offerSubscription?.cancel();
        _offerExpiryTimer?.cancel();
        _currentOfferId = null;
        Get.snackbar('Offer Expired', 'You can send a new offer');
      }
    });
  }

  // ═══════════════════════════════════════════════════════════
  // RIDE LIFECYCLE (After offer is accepted)
  // ═══════════════════════════════════════════════════════════

  /// Start watching ride updates after local accepts our offer
  void _startWatchingRide(String rideId) {
    _rideSubscription?.cancel();
    _rideSubscription = rideService.watchRide(rideId).listen((ride) {
      activeRide.value = ride;

      if (ride?.status == RideStatus.cancelled) {
        _rideSubscription?.cancel();
        activeRide.value = null;
        Get.snackbar('Ride Cancelled', 'The rider cancelled the ride');
      }
    });
  }

  /// Update ride status: onWay → waiting → ongoing → completed
  Future<void> updateRideStatus(RideStatus status) async {
    if (activeRide.value == null) return;

    try {
      await rideService.updateRideStatus(activeRide.value!.rideId, status);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Complete ride and clear state
  Future<void> completeRide() async {
    if (activeRide.value == null) return;

    try {
      final completedRide = activeRide.value!; // capture before clearing
      await rideService.updateRideStatus(
        completedRide.rideId,
        RideStatus.completed,
      );

      _rideSubscription?.cancel();
      activeRide.value = null;

      // Show completion summary dialog
      Get.defaultDialog(
        title: 'Ride Completed!',
        titleStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          fontFamily: 'Poppins',
        ),
        middleText:
            'Fare: ${completedRide.formattedFare}\n'
            'Distance: ${completedRide.formattedDistance}\n'
            'Duration: ${completedRide.formattedEta}',
        middleTextStyle: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        buttonColor: const Color(0xFF1B1B1B),
        onConfirm: () => Get.back(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
