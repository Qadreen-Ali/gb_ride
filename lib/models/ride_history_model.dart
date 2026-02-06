class RideHistoryModel {
  final String id;
  final String riderId;
  final String driverId;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> destinationLocation;
  final String vehicleType;
  final double distanceKm;
  final int estimatedMinutes;
  final double offeredFare;
  final double acceptedFare;
  final double? finalFare;
  final String paymentMethod;
  final String rideStatus; // 'completed', 'cancelled', etc.
  final DateTime startTime;
  final DateTime endTime;
  final int? riderRating;
  final String? riderComment;
  final int? driverRating;
  final String? driverComment;
  final bool isPaymentComplete;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  RideHistoryModel({
    required this.id,
    required this.riderId,
    required this.driverId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.vehicleType,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.offeredFare,
    required this.acceptedFare,
    this.finalFare,
    required this.paymentMethod,
    required this.rideStatus,
    required this.startTime,
    required this.endTime,
    this.riderRating,
    this.riderComment,
    this.driverRating,
    this.driverComment,
    this.isPaymentComplete = false,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert JSON from Supabase to RideHistoryModel
  factory RideHistoryModel.fromJson(Map<String, dynamic> json) {
    return RideHistoryModel(
      id: json['id'] ?? '',
      riderId: json['rider_id'] ?? '',
      driverId: json['driver_id'] ?? '',
      pickupLocation: json['pickup_location'] is String
          ? {}
          : json['pickup_location'] ?? {},
      destinationLocation: json['destination_location'] is String
          ? {}
          : json['destination_location'] ?? {},
      vehicleType: json['vehicle_type'] ?? 'bike',
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      estimatedMinutes: json['estimated_minutes'] ?? 0,
      offeredFare: (json['offered_fare'] ?? 0).toDouble(),
      acceptedFare: (json['accepted_fare'] ?? 0).toDouble(),
      finalFare: json['final_fare'] != null
          ? (json['final_fare'] as num).toDouble()
          : null,
      paymentMethod: json['payment_method'] ?? 'cash',
      rideStatus: json['ride_status'] ?? 'completed',
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : DateTime.now(),
      riderRating: json['rider_rating'] as int?,
      riderComment: json['rider_comment'] as String?,
      driverRating: json['driver_rating'] as int?,
      driverComment: json['driver_comment'] as String?,
      isPaymentComplete: json['is_payment_complete'] ?? false,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convert RideHistoryModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rider_id': riderId,
      'driver_id': driverId,
      'pickup_location': pickupLocation,
      'destination_location': destinationLocation,
      'vehicle_type': vehicleType,
      'distance_km': distanceKm,
      'estimated_minutes': estimatedMinutes,
      'offered_fare': offeredFare,
      'accepted_fare': acceptedFare,
      'final_fare': finalFare,
      'payment_method': paymentMethod,
      'ride_status': rideStatus,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'rider_rating': riderRating,
      'rider_comment': riderComment,
      'driver_rating': driverRating,
      'driver_comment': driverComment,
      'is_payment_complete': isPaymentComplete,
      'cancellation_reason': cancellationReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Copy with method for updates
  RideHistoryModel copyWith({
    String? id,
    String? riderId,
    String? driverId,
    Map<String, dynamic>? pickupLocation,
    Map<String, dynamic>? destinationLocation,
    String? vehicleType,
    double? distanceKm,
    int? estimatedMinutes,
    double? offeredFare,
    double? acceptedFare,
    double? finalFare,
    String? paymentMethod,
    String? rideStatus,
    DateTime? startTime,
    DateTime? endTime,
    int? riderRating,
    String? riderComment,
    int? driverRating,
    String? driverComment,
    bool? isPaymentComplete,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RideHistoryModel(
      id: id ?? this.id,
      riderId: riderId ?? this.riderId,
      driverId: driverId ?? this.driverId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      vehicleType: vehicleType ?? this.vehicleType,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      offeredFare: offeredFare ?? this.offeredFare,
      acceptedFare: acceptedFare ?? this.acceptedFare,
      finalFare: finalFare ?? this.finalFare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rideStatus: rideStatus ?? this.rideStatus,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      riderRating: riderRating ?? this.riderRating,
      riderComment: riderComment ?? this.riderComment,
      driverRating: driverRating ?? this.driverRating,
      driverComment: driverComment ?? this.driverComment,
      isPaymentComplete: isPaymentComplete ?? this.isPaymentComplete,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'RideHistoryModel(id: $id, riderId: $riderId, driverId: $driverId, finalFare: $finalFare)';
}
