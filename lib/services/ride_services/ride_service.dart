import 'dart:math' as Math;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gb_ride/models/ride_model.dart';


class RideService {
  RideService._();
  static final RideService instance = RideService._();

  final SupabaseClient _client = Supabase.instance.client;

  /// 1️⃣ LOCAL CREATES RIDE REQUEST
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

  /// 2️⃣ FIND NEARBY DRIVERS (within 5km)
  Future<List<Map<String, dynamic>>> findNearbyDrivers({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    try {
      // Get all online drivers
      final drivers = await _client
          .from('drivers')
          .select()
          .eq('is_online', true)
          .eq('is_deleted', false);

      // Filter by distance (simple calculation)
      final nearby = drivers.where((driver) {
        final dLat = (driver['current_lat'] ?? 0.0).toDouble();
        final dLng = (driver['current_lng'] ?? 0.0).toDouble();

        final distance = _calculateDistance(lat, lng, dLat, dLng);
        return distance <= radiusKm;
      }).toList();

      return nearby;
    } catch (e) {
      throw Exception('Find drivers error: $e');
    }
  }

  /// 3️⃣ NOTIFY NEARBY DRIVERS (in real-time)
  Stream<List<Map<String, dynamic>>> watchRideRequests(String driverId) {
    return _client
        .from('rides')
        .stream(primaryKey: ['id'])
        .eq('status', 'requested')
        .map((rides) => rides);
  }

  /// 4️⃣ DRIVER ACCEPTS RIDE
  Future<void> acceptRide({
    required String rideId,
    required String driverId,
    required String driverName,
    required String driverPhone,
  }) async {
    try {
      await _client
          .from('rides')
          .update({
            'driver_id': driverId,
            'driver_name': driverName,
            'driver_phone': driverPhone,
            'status': 'accepted',
            'accepted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', rideId);
    } catch (e) {
      throw Exception('Accept ride error: $e');
    }
  }

  /// 5️⃣ DRIVER REJECTS RIDE
  Future<void> rejectRide(String rideId) async {
    try {
      await _client.from('rides').delete().eq('id', rideId);
    } catch (e) {
      throw Exception('Reject ride error: $e');
    }
  }

  /// 6️⃣ UPDATE RIDE STATUS
  Future<void> updateRideStatus(String rideId, RideStatus status) async {
    try {
      await _client
          .from('rides')
          .update({'status': status.toString().split('.').last})
          .eq('id', rideId);
    } catch (e) {
      throw Exception('Update status error: $e');
    }
  }

  /// 7️⃣ LISTEN TO RIDE CHANGES (Real-time for both)
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

  /// 8️⃣ CANCEL RIDE
  Future<void> cancelRide(String rideId) async {
    try {
      await _client
          .from('rides')
          .update({'status': 'cancelled'})
          .eq('id', rideId);
    } catch (e) {
      throw Exception('Cancel ride error: $e');
    }
  }

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
