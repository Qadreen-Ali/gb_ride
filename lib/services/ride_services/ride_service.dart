import 'dart:math' as Math;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:gb_ride/models/ride_offer_model.dart';

class RideService {
  RideService._();
  static final RideService instance = RideService._();

  final SupabaseClient _client = Supabase.instance.client;

  // ═══════════════════════════════════════════════════════════
  // RIDE REQUESTS (Local/Rider side)
  // ═══════════════════════════════════════════════════════════

  /// 1️⃣ LOCAL CREATES RIDE REQUEST
  /// Local sets pickup, destination, base fare → inserts into rides table
  Future<String> createRideRequest(RideModel ride) async {
    try {
      final response = await _client
          .from('rides')
          .insert(ride.toMap())
          .select();

      if (response.isEmpty) throw Exception('Failed to create ride');
      return response[0]['id'];
    } catch (e) {
      throw Exception('Create ride error: $e');
    }
  }

  /// 2️⃣ FIND NEARBY DRIVERS (within radius)
  /// Used to determine which drivers can see the ride request
  Future<List<Map<String, dynamic>>> findNearbyDrivers({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    try {
      final drivers = await _client
          .from('drivers')
          .select()
          .eq('is_online', true)
          .eq('is_deleted', false);

      final nearby = drivers.where((driver) {
        final dLat = (driver['current_lat'] ?? 0.0).toDouble();
        final dLng = (driver['current_lng'] ?? 0.0).toDouble();
        if (dLat == 0.0 && dLng == 0.0) return false;

        final distance = _calculateDistance(lat, lng, dLat, dLng);
        return distance <= radiusKm;
      }).toList();

      return nearby;
    } catch (e) {
      throw Exception('Find drivers error: $e');
    }
  }

  /// 3️⃣ DRIVERS WATCH FOR NEARBY RIDE REQUESTS (Real-time)
  /// All online drivers see rides with status 'requested'
  Stream<List<Map<String, dynamic>>> watchRideRequests() {
    return _client
        .from('rides')
        .stream(primaryKey: ['id'])
        .eq('status', 'requested')
        .map((rides) => rides);
  }

  /// 4️⃣ CANCEL RIDE (Local cancels before a driver is assigned)
  Future<void> cancelRide(String rideId) async {
    try {
      await _client
          .from('rides')
          .update({'status': 'cancelled'})
          .eq('id', rideId);

      // Also expire all pending offers for this ride
      await _client
          .from('ride_offers')
          .update({'status': 'expired'})
          .eq('ride_id', rideId)
          .eq('status', 'pending');
    } catch (e) {
      throw Exception('Cancel ride error: $e');
    }
  }

  /// 5️⃣ UPDATE LOCAL'S BASE FARE (when local adjusts with -5/+5)
  Future<void> updateRideFare(String rideId, double newFare) async {
    try {
      await _client.from('rides').update({'fare': newFare}).eq('id', rideId);
    } catch (e) {
      throw Exception('Update fare error: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // OFFERS (InDrive-style bidding)
  // ═══════════════════════════════════════════════════════════

  /// 6️⃣ DRIVER SENDS FARE OFFER TO A RIDE
  /// Driver sees the ride request → offers a fare (can be higher/lower than base)
  Future<String> sendOffer(RideOfferModel offer) async {
    try {
      final response = await _client
          .from('ride_offers')
          .insert(offer.toMap())
          .select();

      if (response.isEmpty) throw Exception('Failed to send offer');
      return response[0]['id'];
    } catch (e) {
      throw Exception('Send offer error: $e');
    }
  }

  /// 7️⃣ LOCAL WATCHES INCOMING OFFERS (Real-time)
  /// Local sees driver offers appearing as cards on their screen
  Stream<List<RideOfferModel>> watchOffers(String rideId) {
    return _client
        .from('ride_offers')
        .stream(primaryKey: ['id'])
        .eq('ride_id', rideId)
        .map(
          (offers) => offers
              .where((o) => o['status'] == 'pending')
              .map((o) => RideOfferModel.fromMap(o))
              .toList(),
        );
  }

  /// 8️⃣ LOCAL ACCEPTS A DRIVER'S OFFER
  /// Updates both the ride (assigns driver) and the offer (marks accepted)
  /// Expires all other pending offers for this ride
  Future<void> acceptOffer({
    required String offerId,
    required String rideId,
    required String driverId,
    required String? driverName,
    required String? driverPhone,
    required String? driverImage,
    required double acceptedFare,
  }) async {
    try {
      // 1. Update the ride — assign driver, set fare, mark accepted
      await _client
          .from('rides')
          .update({
            'driver_id': driverId,
            'driver_name': driverName,
            'driver_image': driverImage,
            'driver_phone': driverPhone,
            'fare': acceptedFare,
            'status': 'accepted',
            'accepted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', rideId);

      // 2. Mark the accepted offer
      await _client
          .from('ride_offers')
          .update({'status': 'accepted'})
          .eq('id', offerId);

      // 3. Expire all other pending offers for this ride
      await _client
          .from('ride_offers')
          .update({'status': 'expired'})
          .eq('ride_id', rideId)
          .eq('status', 'pending');
    } catch (e) {
      throw Exception('Accept offer error: $e');
    }
  }

  /// 9️⃣ CHECK IF DRIVER ALREADY SENT AN OFFER FOR THIS RIDE
  Future<bool> hasDriverOffered({
    required String rideId,
    required String driverId,
  }) async {
    try {
      final response = await _client
          .from('ride_offers')
          .select('id')
          .eq('ride_id', rideId)
          .eq('driver_id', driverId)
          .eq('status', 'pending');

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // RIDE LIFECYCLE (After offer is accepted)
  // ═══════════════════════════════════════════════════════════

  /// 🔟 UPDATE RIDE STATUS (onWay → waiting → ongoing → completed)
  Future<void> updateRideStatus(String rideId, RideStatus status) async {
    try {
      final Map<String, dynamic> data = {'status': status.name};

      // Auto-set completedAt timestamp
      if (status == RideStatus.completed) {
        data['completed_at'] = DateTime.now().toIso8601String();
      }

      await _client.from('rides').update(data).eq('id', rideId);
    } catch (e) {
      throw Exception('Update status error: $e');
    }
  }

  /// 1️⃣1️⃣ WATCH RIDE CHANGES (Real-time for both local & driver)
  Stream<RideModel?> watchRide(String rideId) {
    return _client
        .from('rides')
        .stream(primaryKey: ['id'])
        .eq('id', rideId)
        .map((rides) {
          if (rides.isEmpty) return null;
          return RideModel.fromMap(rides.first);
        });
  }

  /// 1️⃣2️⃣ DRIVER WATCHES IF THEIR OFFER GOT ACCEPTED
  /// Driver listens to their own offers to know when local accepts
  Stream<RideOfferModel?> watchMyOffer(String offerId) {
    return _client
        .from('ride_offers')
        .stream(primaryKey: ['id'])
        .eq('id', offerId)
        .map((offers) {
          if (offers.isEmpty) return null;
          return RideOfferModel.fromMap(offers.first);
        });
  }

  /// 1️⃣2️⃣.5️⃣ EXPIRE A SINGLE OFFER (12-second timeout)
  Future<void> expireOffer(String offerId) async {
    try {
      await _client
          .from('ride_offers')
          .update({'status': 'expired'})
          .eq('id', offerId)
          .eq('status', 'pending');
    } catch (e) {
      // Silently fail — offer may already be accepted/expired
    }
  }

  /// 1️⃣3️⃣ GET RIDE BY ID (one-time fetch)
  Future<RideModel?> getRide(String rideId) async {
    try {
      final response = await _client
          .from('rides')
          .select()
          .eq('id', rideId)
          .maybeSingle();

      if (response == null) return null;
      return RideModel.fromMap(response);
    } catch (e) {
      throw Exception('Get ride error: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════

  /// Calculate distance between two coordinates (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadiusKm = 6371;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLng = _degreesToRadians(lng2 - lng1);

    final a =
        (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
        (Math.cos(_degreesToRadians(lat1)) *
            Math.cos(_degreesToRadians(lat2)) *
            Math.sin(dLng / 2) *
            Math.sin(dLng / 2));

    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}
