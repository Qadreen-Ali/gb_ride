import 'dart:async';
import 'package:get/get.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:gb_ride/models/ride_offer_model.dart';
import 'package:gb_ride/services/ride_services/ride_service.dart';
import 'package:gb_ride/services/map_services/location_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RideController extends GetxController {
  final rideService = RideService.instance;
  final locationService = LocationService.instance;
  final _client = Supabase.instance.client;

  // Ride state
  final currentRide = Rx<RideModel?>(null);
  final incomingOffers = <RideOfferModel>[].obs;
  final isSearching = false.obs;
  final isLoading = false.obs;
  final currentFare = 0.0.obs;

  // Local's DB ID (locals table UUID, NOT auth UUID)
  String _localDbId = '';
  String? currentRideId;

  // Stream subscriptions
  StreamSubscription? _rideSubscription;
  StreamSubscription? _offersSubscription;

  // Offer expiry timers (12-second countdown per offer)
  final Map<String, Timer> _offerTimers = {};

  @override
  void onInit() {
    super.onInit();
    _loadLocalProfile();
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }

  /// Fetch the actual locals table UUID from auth_id
  Future<void> _loadLocalProfile() async {
    try {
      final authId = _client.auth.currentUser?.id ?? '';
      if (authId.isEmpty) return;

      final response = await _client
          .from('locals')
          .select('id')
          .eq('auth_id', authId)
          .single();

      _localDbId = response['id'].toString();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // RIDE REQUEST
  // ═══════════════════════════════════════════════════════════

  /// Local requests a ride — uses locals table UUID
  Future<void> requestRide(RideModel ride) async {
    try {
      if (_localDbId.isEmpty) {
        await _loadLocalProfile();
        if (_localDbId.isEmpty) {
          Get.snackbar('Error', 'Profile not loaded. Please try again.');
          return;
        }
      }

      isSearching.value = true;

      // Use locals table UUID, NOT auth UUID
      final rideWithLocalId = ride.copyWith(localId: _localDbId);
      final rideId = await rideService.createRideRequest(rideWithLocalId);

      currentRideId = rideId;
      currentFare.value = ride.fare;

      // Start listening for driver offers
      _listenToOffers(rideId);

      // Start listening to ride status changes
      _listenToRide(rideId);

      Get.snackbar('Ride Requested', 'Waiting for driver offers...');
    } catch (e) {
      isSearching.value = false;
      Get.snackbar('Error', 'Failed to request ride: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // OFFERS (InDrive-style)
  // ═══════════════════════════════════════════════════════════

  /// Listen to incoming fare offers from drivers
  void _listenToOffers(String rideId) {
    _offersSubscription?.cancel();
    _offersSubscription = rideService
        .watchOffers(rideId)
        .listen(
          (offers) {
            // Cancel timers for offers no longer present
            final currentIds = offers.map((o) => o.offerId).toSet();
            _offerTimers.keys
                .where((id) => !currentIds.contains(id))
                .toList()
                .forEach((id) {
                  _offerTimers[id]?.cancel();
                  _offerTimers.remove(id);
                });

            // Start 12-second timers for new offers
            for (final offer in offers) {
              if (!_offerTimers.containsKey(offer.offerId)) {
                _offerTimers[offer.offerId] = Timer(
                  const Duration(seconds: 12),
                  () {
                    // Auto-remove expired offer from UI
                    incomingOffers.removeWhere(
                      (o) => o.offerId == offer.offerId,
                    );
                    _offerTimers.remove(offer.offerId);
                    // Expire in database so driver can re-send
                    rideService.expireOffer(offer.offerId);
                  },
                );
              }
            }

            incomingOffers.assignAll(offers);
          },
          onError: (e) {
            print('Offer stream error: $e');
          },
        );
  }

  /// Local accepts a driver's offer
  Future<void> acceptOffer(RideOfferModel offer) async {
    try {
      isLoading.value = true;

      await rideService.acceptOffer(
        rideId: offer.rideId,
        offerId: offer.offerId,
        driverId: offer.driverId,
        driverName: offer.driverName ?? '',
        driverPhone: offer.driverPhone ?? '',
        driverImage: offer.driverImage ?? '',
        acceptedFare: offer.offeredFare,
      );

      // Clear offers — ride is now assigned
      incomingOffers.clear();
      isSearching.value = false;

      Get.snackbar('Ride Accepted', '${offer.driverName} is on the way!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept offer: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Local adjusts base fare (+5 / -5 buttons)
  Future<void> adjustFare(double newFare) async {
    if (currentRideId == null) return;
    try {
      currentFare.value = newFare;
      await rideService.updateRideFare(currentRideId!, newFare);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update fare: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // RIDE STATUS TRACKING
  // ═══════════════════════════════════════════════════════════

  /// Listen to ride status changes in real-time
  void _listenToRide(String rideId) {
    _rideSubscription?.cancel();
    _rideSubscription = rideService
        .watchRide(rideId)
        .listen(
          (ride) {
            if (ride != null) {
              currentRide.value = ride;

              switch (ride.status) {
                case RideStatus.requested:
                  // Still waiting for offers
                  break;
                case RideStatus.accepted:
                  isSearching.value = false;
                  Get.snackbar(
                    'Driver Assigned',
                    '${ride.driverName} accepted your ride!',
                  );
                  break;
                case RideStatus.onWay:
                  Get.snackbar(
                    'On the Way',
                    '${ride.driverName} is coming to pick you up',
                  );
                  break;
                case RideStatus.waiting:
                  Get.snackbar(
                    'Driver Arrived',
                    '${ride.driverName} is waiting at pickup',
                  );
                  break;
                case RideStatus.ongoing:
                  Get.snackbar(
                    'Trip Started',
                    'Heading to ${ride.destinationLocation}',
                  );
                  break;
                case RideStatus.completed:
                  Get.snackbar('Trip Completed', 'You have arrived!');
                  _cleanup();
                  break;
                case RideStatus.cancelled:
                  Get.snackbar('Ride Cancelled', 'The ride has been cancelled');
                  _cleanup();
                  break;
              }
            }
          },
          onError: (e) {
            print('Ride stream error: $e');
          },
        );
  }

  // ═══════════════════════════════════════════════════════════
  // CANCEL
  // ═══════════════════════════════════════════════════════════

  Future<void> cancelRide() async {
    if (currentRideId == null) return;
    try {
      await rideService.cancelRide(currentRideId!);
      _cleanup();
      Get.snackbar('Cancelled', 'Ride request cancelled');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel ride: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════

  void _cleanup() {
    _rideSubscription?.cancel();
    _offersSubscription?.cancel();
    _rideSubscription = null;
    _offersSubscription = null;
    // Cancel all offer expiry timers
    for (final timer in _offerTimers.values) {
      timer.cancel();
    }
    _offerTimers.clear();
    currentRide.value = null;
    currentRideId = null;
    incomingOffers.clear();
    isSearching.value = false;
    isLoading.value = false;
    currentFare.value = 0.0;
  }
}
