enum RideStatus {
  requested, // Local requested, waiting for driver
  accepted, // Driver accepted the ride
  onWay, // Driver is on the way to pickup
  waiting, // Driver arrived at pickup, waiting for passenger
  ongoing, // Ride started, heading to destination
  completed, // Ride completed
  cancelled, // Cancelled by either party
}

class RideModel {
  final String
  rideId; // Keep as String (Supabase will return it as String from API)
  final String localId; // Keep as String
  final String? driverId; // Keep as String

  // Locations
  final String pickupLocation;
  final String destinationLocation;
  final double pickupLat; // 🆕 Pickup coordinates
  final double pickupLng;
  final double destLat; // 🆕 Destination coordinates
  final double destLng;

  // Ride info
  final double distanceKm;
  final int etaMinutes;
  final double fare;
  final RideStatus status; // 🆕 Real-time status

  // Driver info
  final String? driverName;
  final String? driverImagePath;
  final String? driverPhone; // 🆕 Direct contact

  // Timestamps
  final DateTime createdAt; // 🆕 When ride was requested
  final DateTime? acceptedAt; // 🆕 When driver accepted
  final DateTime? completedAt; // 🆕 When ride ended

  RideModel({
    required this.rideId,
    required this.localId,
    this.driverId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.destLat,
    required this.destLng,
    required this.distanceKm,
    required this.etaMinutes,
    required this.fare,
    this.status = RideStatus.requested,
    this.driverName,
    this.driverImagePath,
    this.driverPhone,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
  });

  /// Helper getters
  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';
  String get formattedEta => '$etaMinutes min';
  String get formattedFare => '${fare.toStringAsFixed(0)} PKR';
  String get statusText => status.toString().split('.').last;

  /// Convert to Supabase map
  Map<String, dynamic> toMap() {
    return {
      // Don't include 'id' - let Supabase auto-generate it
      'local_id': localId,
      'driver_id': driverId,
      'pickup_location': pickupLocation,
      'destination_location': destinationLocation,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'dest_lat': destLat,
      'dest_lng': destLng,
      'distance_km': distanceKm,
      'eta_minutes': etaMinutes,
      'fare': fare,
      'status': status.toString().split('.').last,
      'driver_name': driverName,
      'driver_image': driverImagePath,
      'driver_phone': driverPhone,
      'created_at': createdAt.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Convert from Supabase map
  factory RideModel.fromMap(Map<String, dynamic> map) {
    return RideModel(
      rideId: map['id'] ?? '',
      localId: map['local_id'] ?? '',
      driverId: map['driver_id'],
      pickupLocation: map['pickup_location'] ?? '',
      destinationLocation: map['destination_location'] ?? '',
      pickupLat: (map['pickup_lat'] ?? 0.0).toDouble(),
      pickupLng: (map['pickup_lng'] ?? 0.0).toDouble(),
      destLat: (map['dest_lat'] ?? 0.0).toDouble(),
      destLng: (map['dest_lng'] ?? 0.0).toDouble(),
      distanceKm: (map['distance_km'] ?? 0.0).toDouble(),
      etaMinutes: map['eta_minutes'] ?? 0,
      fare: (map['fare'] ?? 0.0).toDouble(),
      status: _parseStatus(map['status']),
      driverName: map['driver_name'],
      driverImagePath: map['driver_image'],
      driverPhone: map['driver_phone'],
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      acceptedAt: map['accepted_at'] != null
          ? DateTime.parse(map['accepted_at'])
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
    );
  }

  static RideStatus _parseStatus(String? status) {
    switch (status) {
      case 'requested':
        return RideStatus.requested;
      case 'accepted':
        return RideStatus.accepted;
      case 'onWay':
        return RideStatus.onWay;
      case 'waiting':
        return RideStatus.waiting;
      case 'ongoing':
        return RideStatus.ongoing;
      case 'completed':
        return RideStatus.completed;
      case 'cancelled':
        return RideStatus.cancelled;
      default:
        return RideStatus.requested;
    }
  }

  RideModel copyWith({
    String? rideId,
    String? localId,
    String? driverId,
    double? fare,
    RideStatus? status,
    String? driverName,
    String? driverPhone,
    DateTime? acceptedAt,
    DateTime? completedAt,
  }) {
    return RideModel(
      rideId: rideId ?? this.rideId,
      localId: localId ?? this.localId,
      driverId: driverId ?? this.driverId,
      pickupLocation: pickupLocation,
      destinationLocation: destinationLocation,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      destLat: destLat,
      destLng: destLng,
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      driverName: driverName ?? this.driverName,
      driverImagePath: driverImagePath,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
