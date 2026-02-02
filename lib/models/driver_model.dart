class DriverModel {
  final String id;
  final String userId;
  final String licenseNumber;
  final String? licenseImageUrl;
  final String? vehicleType; // 'Car' | 'Bike'
  final String? vehicleNumber;
  final bool isOnline;
  final double? currentLatitude;
  final double? currentLongitude;
  final String status; // 'offline'|'available'|'onRide'|'busy'
  final double? rating;
  final int totalTrips;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DriverModel({
    required this.id,
    required this.userId,
    required this.licenseNumber,
    this.licenseImageUrl,
    this.vehicleType,
    this.vehicleNumber,
    this.isOnline = false,
    this.currentLatitude,
    this.currentLongitude,
    required this.status,
    this.rating,
    this.totalTrips = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      licenseNumber: json['license_number'] as String,
      licenseImageUrl: json['license_image_url'] as String?,
      vehicleType: json['vehicle_type'] as String?,
      vehicleNumber: json['vehicle_number'] as String?,
      isOnline: (json['is_online'] ?? false) as bool,
      currentLatitude: json['current_latitude'] != null
          ? (json['current_latitude'] as num).toDouble()
          : null,
      currentLongitude: json['current_longitude'] != null
          ? (json['current_longitude'] as num).toDouble()
          : null,
      status: json['status'] as String,
      rating: (json['rating'] == null)
          ? null
          : (json['rating'] as num).toDouble(),
      totalTrips: (json['total_trips'] ?? 0) as int,
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
    'user_id': userId,
    'license_number': licenseNumber,
    'license_image_url': licenseImageUrl,
    'vehicle_type': vehicleType,
    'vehicle_number': vehicleNumber,
    'is_online': isOnline,
    'current_latitude': currentLatitude,
    'current_longitude': currentLongitude,
    'status': status,
    'rating': rating,
    'total_trips': totalTrips,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
