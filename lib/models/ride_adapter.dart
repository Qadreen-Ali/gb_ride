import 'ride_model.dart';
import 'ride_ui_model.dart';

/// Converts canonical RideModel (from Supabase) → RideUiModel (for UI display)
class RideAdapter {
  /// Extract location name from JSONB location object
  static String _extractLocationName(Map<String, dynamic>? location) {
    if (location == null) return 'Unknown';

    // Try common field names for location name
    return (location['name'] as String?) ??
        (location['address'] as String?) ??
        (location['display_name'] as String?) ??
        'Unknown Location';
  }

  /// Convert canonical RideModel to UI-friendly RideUiModel (simple version)
  static RideUiModel toUiModel(RideModel ride) {
    return RideUiModel(
      rideId: ride.id,
      pickupLocation: _extractLocationName(ride.pickupLocation),
      destinationLocation: _extractLocationName(ride.destinationLocation),
      distanceKm: ride.distanceKm ?? 0,
      etaMinutes: ride.estimatedMinutes ?? 0,
      offeredFare: ride.offeredFare,
      acceptedFare: ride.acceptedFare,
      driverName: 'Driver',
      driverImagePath: 'assets/images/profile.png',
    );
  }

  /// Convert canonical RideModel to UI-friendly RideUiModel (with driver details)
  static RideUiModel fromCanonical({
    required RideModel ride,
    required String driverName,
    required String driverImagePath,
  }) {
    return RideUiModel(
      rideId: ride.id,
      pickupLocation: _extractLocationName(ride.pickupLocation),
      destinationLocation: _extractLocationName(ride.destinationLocation),
      distanceKm: ride.distanceKm ?? 0,
      etaMinutes: ride.estimatedMinutes ?? 0,
      offeredFare: ride.offeredFare,
      acceptedFare: ride.acceptedFare,
      driverName: driverName,
      driverImagePath: driverImagePath,
    );
  }

  /// Batch convert multiple rides
  static List<RideUiModel> fromCanonicalList({
    required List<RideModel> rides,
    required Map<String, Map<String, String>>
    driverInfo, // driverId -> {name, imagePath}
  }) {
    return rides.map((ride) {
      final driver =
          driverInfo[ride.driverId] ??
          {'name': 'Driver', 'imagePath': 'assets/images/profile.png'};
      return fromCanonical(
        ride: ride,
        driverName: driver['name'] ?? 'Driver',
        driverImagePath: driver['imagePath'] ?? 'assets/images/profile.png',
      );
    }).toList();
  }
}
