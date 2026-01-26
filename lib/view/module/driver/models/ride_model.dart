class RideModel {
  final String rideId;

  // Locations
  final String pickupLocation;
  final String destinationLocation;

  // Ride info
  final double distanceKm;
  final int etaMinutes;
  final double fare;

  // Driver info
  final String driverName;
  final String driverImagePath;

  RideModel({
    required this.rideId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.distanceKm,
    required this.etaMinutes,
    required this.fare,
    required this.driverName,
    required this.driverImagePath,
  });

  /// Helper getters
  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';
  String get formattedEta => '$etaMinutes min';
  String get formattedFare => '${fare.toStringAsFixed(0)} PKR';

  RideModel copyWith({double? fare}) {
    return RideModel(
      rideId: rideId,
      pickupLocation: pickupLocation,
      destinationLocation: destinationLocation,
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
      fare: fare ?? this.fare,
      driverName: driverName,
      driverImagePath: driverImagePath,
    );
  }
}
