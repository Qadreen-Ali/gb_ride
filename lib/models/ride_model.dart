import 'ride_status.dart';

class RideModel {
  final String id;
  final String riderId;
  final String? driverId;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> destinationLocation;
  final String vehicleType; // 'car'|'bike'|'city'
  final double? offeredFare;
  final double? acceptedFare;
  final String paymentMethod; // 'cash'|'card'|'easyPaisa'
  final RideStatus status;
  final double? distanceKm;
  final int? estimatedMinutes;
  final DateTime? pickupTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? cancelledBy;
  final String? cancellationReason;
  final bool autoAccept;
  final String? messageForDriver;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RideModel({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.vehicleType,
    this.offeredFare,
    this.acceptedFare,
    required this.paymentMethod,
    required this.status,
    this.distanceKm,
    this.estimatedMinutes,
    this.pickupTime,
    this.startTime,
    this.endTime,
    this.cancelledBy,
    this.cancellationReason,
    this.autoAccept = false,
    this.messageForDriver,
    this.createdAt,
    this.updatedAt,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] as String,
      riderId: json['rider_id'] as String,
      driverId: json['driver_id'] as String?,
      pickupLocation: Map<String, dynamic>.from(json['pickup_location'] as Map),
      destinationLocation: Map<String, dynamic>.from(
        json['destination_location'] as Map,
      ),
      vehicleType: json['vehicle_type'] as String,
      offeredFare: json['offered_fare'] != null
          ? (json['offered_fare'] as num).toDouble()
          : null,
      acceptedFare: json['accepted_fare'] != null
          ? (json['accepted_fare'] as num).toDouble()
          : null,
      paymentMethod: json['payment_method'] as String,
      status: RideStatus.fromString(json['status'] as String?),
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
      estimatedMinutes: json['estimated_minutes'] as int?,
      pickupTime: json['pickup_time'] != null
          ? DateTime.parse(json['pickup_time'])
          : null,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'])
          : null,
      cancelledBy: json['cancelled_by'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      autoAccept: (json['auto_accept'] ?? false) as bool,
      messageForDriver: json['message_for_driver'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'rider_id': riderId,
    'driver_id': driverId,
    'pickup_location': pickupLocation,
    'destination_location': destinationLocation,
    'vehicle_type': vehicleType,
    'offered_fare': offeredFare,
    'accepted_fare': acceptedFare,
    'payment_method': paymentMethod,
    'status': status.dbValue,
    'distance_km': distanceKm,
    'estimated_minutes': estimatedMinutes,
    'pickup_time': pickupTime?.toIso8601String(),
    'start_time': startTime?.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'cancelled_by': cancelledBy,
    'cancellation_reason': cancellationReason,
    'auto_accept': autoAccept,
    'message_for_driver': messageForDriver,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  /// UI Helpers
  String get formattedDistance =>
      distanceKm != null ? '${distanceKm!.toStringAsFixed(1)} km' : 'N/A';
  String get formattedEta =>
      estimatedMinutes != null ? '$estimatedMinutes min' : 'N/A';
  String get formattedFare => acceptedFare != null
      ? '${acceptedFare!.toStringAsFixed(0)} PKR'
      : (offeredFare != null
            ? '${offeredFare!.toStringAsFixed(0)} PKR'
            : 'Pending');
}

// class RideModel {
//   final String rideId;

//   // Locations
//   final String pickupLocation;
//   final String destinationLocation;

//   // Ride info
//   final double distanceKm;
//   final int etaMinutes;
//   final double fare;

//   // Driver info
//   final String driverName;
//   final String driverImagePath;

//   RideModel({
//     required this.rideId,
//     required this.pickupLocation,
//     required this.destinationLocation,
//     required this.distanceKm,
//     required this.etaMinutes,
//     required this.fare,
//     required this.driverName,
//     required this.driverImagePath,
//   });

//   /// Helper getters
//   String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';
//   String get formattedEta => '$etaMinutes min';
//   String get formattedFare => '${fare.toStringAsFixed(0)} PKR';

//   RideModel copyWith({double? fare}) {
//     return RideModel(
//       rideId: rideId,
//       pickupLocation: pickupLocation,
//       destinationLocation: destinationLocation,
//       distanceKm: distanceKm,
//       etaMinutes: etaMinutes,
//       fare: fare ?? this.fare,
//       driverName: driverName,
//       driverImagePath: driverImagePath,
//     );
//   }
// }
