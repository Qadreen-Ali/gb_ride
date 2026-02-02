class VehicleModel {
  final String id;
  final String driverId;
  final String type; // 'car'|'bike'|'city'
  final String make;
  final String model;
  final String color;
  final String plateNumber;
  final int year;
  final int capacity;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VehicleModel({
    required this.id,
    required this.driverId,
    required this.type,
    required this.make,
    required this.model,
    required this.color,
    required this.plateNumber,
    required this.year,
    required this.capacity,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    id: json['id'] as String,
    driverId: json['driver_id'] as String,
    type: json['type'] as String,
    make: json['make'] as String,
    model: json['model'] as String,
    color: json['color'] as String,
    plateNumber: json['plate_number'] as String,
    year: (json['year'] as num).toInt(),
    capacity: (json['capacity'] as num).toInt(),
    imageUrl: json['image_url'] as String?,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'driver_id': driverId,
    'type': type,
    'make': make,
    'model': model,
    'color': color,
    'plate_number': plateNumber,
    'year': year,
    'capacity': capacity,
    'image_url': imageUrl,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}