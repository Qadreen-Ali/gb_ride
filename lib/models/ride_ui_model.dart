class RideUiModel {
  final String rideId;
  final String pickupLocation;
  final String destinationLocation;
  final double distanceKm;
  final int etaMinutes;
  final double? offeredFare;
  final double? acceptedFare;
  final String driverName;
  final String driverImagePath;

  RideUiModel({
    required this.rideId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.distanceKm,
    required this.etaMinutes,
    this.offeredFare,
    this.acceptedFare,
    required this.driverName,
    required this.driverImagePath,
  });

  /// Helper getters
  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';
  String get formattedEta => '$etaMinutes min';
  String get formattedFare => acceptedFare != null
      ? '${acceptedFare!.toStringAsFixed(0)} PKR'
      : (offeredFare != null
            ? '${offeredFare!.toStringAsFixed(0)} PKR'
            : 'Pending');

  /// Current fare for editing (prioritize accepted over offered)
  double get currentFare => acceptedFare ?? offeredFare ?? 0;

  RideUiModel copyWith({double? offeredFare, double? acceptedFare}) {
    return RideUiModel(
      rideId: rideId,
      pickupLocation: pickupLocation,
      destinationLocation: destinationLocation,
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
      offeredFare: offeredFare ?? this.offeredFare,
      acceptedFare: acceptedFare ?? this.acceptedFare,
      driverName: driverName,
      driverImagePath: driverImagePath,
    );
  }
}
