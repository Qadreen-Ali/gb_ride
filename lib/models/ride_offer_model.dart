class RideOfferModel {
  final String offerId;
  final String rideId;
  final String driverId;
  final String? driverName;
  final String? driverPhone;
  final String? driverImage;
  final double driverRating;
  final int driverTotalRides;
  final double offeredFare;
  final int etaMinutes;
  final String status; // 'pending', 'accepted', 'expired'
  final DateTime createdAt;

  RideOfferModel({
    required this.offerId,
    required this.rideId,
    required this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverImage,
    this.driverRating = 0.0,
    this.driverTotalRides = 0,
    required this.offeredFare,
    this.etaMinutes = 0,
    this.status = 'pending',
    required this.createdAt,
  });

  /// Convert to Supabase map (for INSERT)
  Map<String, dynamic> toMap() {
    return {
      'ride_id': rideId,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'driver_image': driverImage,
      'driver_rating': driverRating,
      'driver_total_rides': driverTotalRides,
      'offered_fare': offeredFare,
      'eta_minutes': etaMinutes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert from Supabase map (for SELECT)
  factory RideOfferModel.fromMap(Map<String, dynamic> map) {
    return RideOfferModel(
      offerId: map['id']?.toString() ?? '',
      rideId: map['ride_id']?.toString() ?? '',
      driverId: map['driver_id']?.toString() ?? '',
      driverName: map['driver_name'],
      driverPhone: map['driver_phone'],
      driverImage: map['driver_image'],
      driverRating: (map['driver_rating'] ?? 0.0).toDouble(),
      driverTotalRides: (map['driver_total_rides'] ?? 0).toInt(),
      offeredFare: (map['offered_fare'] ?? 0.0).toDouble(),
      etaMinutes: (map['eta_minutes'] ?? 0).toInt(),
      status: map['status'] ?? 'pending',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Create a modified copy
  RideOfferModel copyWith({
    String? offerId,
    String? rideId,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? driverImage,
    double? driverRating,
    int? driverTotalRides,
    double? offeredFare,
    int? etaMinutes,
    String? status,
    DateTime? createdAt,
  }) {
    return RideOfferModel(
      offerId: offerId ?? this.offerId,
      rideId: rideId ?? this.rideId,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverImage: driverImage ?? this.driverImage,
      driverRating: driverRating ?? this.driverRating,
      driverTotalRides: driverTotalRides ?? this.driverTotalRides,
      offeredFare: offeredFare ?? this.offeredFare,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Helper getters
  String get formattedFare => '${offeredFare.toStringAsFixed(0)} PKR';
  String get formattedEta => '$etaMinutes min';
  String get formattedRating => driverRating.toStringAsFixed(1);
}
