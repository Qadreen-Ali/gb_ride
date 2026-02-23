import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  final SupabaseClient _client = Supabase.instance.client;
  Timer? _locationTimer;
  bool _isTracking = false;

  /// Start broadcasting location every 10 seconds
  void startLocationBroadcast({
    required String userId,
    required String userType, // 'driver' or 'local'
  }) {
    if (_isTracking) return;

    _isTracking = true;

    // Send location immediately
    _broadcastLocation(userId, userType);

    // Then every 10 seconds
    _locationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _broadcastLocation(userId, userType),
    );
  }

  /// Stop broadcasting
  void stopLocationBroadcast() {
    _locationTimer?.cancel();
    _isTracking = false;
  }

  /// Broadcast current location to Supabase
  Future<void> _broadcastLocation(String userId, String userType) async {
    try {
      final position = await _getCurrentLocation();

      if (userType == 'driver') {
        await _client
            .from('drivers')
            .update({
              'current_lat': position.latitude,
              'current_lng': position.longitude,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId);
      } else if (userType == 'local') {
        await _client
            .from('locals')
            .update({
              'current_lat': position.latitude,
              'current_lng': position.longitude,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId);
      }
    } catch (e) {
      print('❌ Location broadcast error: $e');
    }
  }

  /// Get current GPS location
  Future<Position> _getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }

  /// Get driver's current location
  Future<Map<String, double>?> getDriverLocation(String driverId) async {
    try {
      final data = await _client
          .from('drivers')
          .select('current_lat, current_lng')
          .eq('id', driverId)
          .maybeSingle();

      if (data == null) return null;

      return {
        'lat': (data['current_lat'] ?? 0.0).toDouble(),
        'lng': (data['current_lng'] ?? 0.0).toDouble(),
      };
    } catch (e) {
      print('❌ Get driver location error: $e');
      return null;
    }
  }

  /// Listen to driver location in real-time
  Stream<Map<String, double>> watchDriverLocation(String driverId) {
    return _client
        .from('drivers')
        .stream(primaryKey: ['id'])
        .eq('id', driverId)
        .map((drivers) {
          if (drivers.isEmpty) return {'lat': 0.0, 'lng': 0.0};
          final driver = drivers.first;
          return {
            'lat': (driver['current_lat'] ?? 0.0).toDouble(),
            'lng': (driver['current_lng'] ?? 0.0).toDouble(),
          };
        });
  }
}
