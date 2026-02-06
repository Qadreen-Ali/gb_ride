class SavedAddressModel {
  final String id;
  final String userId;
  final String name; // 'Home', 'Work', 'Airport', etc.
  final double latitude;
  final double longitude;
  final String address; // Full address string
  final DateTime? createdAt;

  SavedAddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.createdAt,
  });

  /// Convert JSON from Supabase to SavedAddressModel
  factory SavedAddressModel.fromJson(Map<String, dynamic> json) {
    return SavedAddressModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert SavedAddressModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Copy with method for updates
  SavedAddressModel copyWith({
    String? id,
    String? userId,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    DateTime? createdAt,
  }) {
    return SavedAddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'SavedAddressModel(id: $id, name: $name, address: $address)';
}
