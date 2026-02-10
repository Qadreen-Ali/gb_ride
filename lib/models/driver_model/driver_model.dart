class DriverModel {
  final String id;

  // 🔑 Auth linkage
  final String authId;

  // Personal info
  final String phoneNumber;
  final String fullName;
  final String? gender;
  final String? cnic;
  final int? age;
  final String? address;

  // Vehicle info
  final String licenseNumber;
  final String vehicleType;
  final String vehicleNumber;

  final DateTime createdAt;

  DriverModel({
    required this.id,
    required this.authId,
    required this.phoneNumber,
    required this.fullName,
    this.gender,
    this.cnic,
    this.age,
    this.address,
    required this.licenseNumber,
    required this.vehicleType,
    required this.vehicleNumber,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert model → Supabase insert/update map
  Map<String, dynamic> toMap() {
    return {
      'auth_id': authId, // 🔑 REQUIRED
      'phone_number': phoneNumber,
      'full_name': fullName,
      'gender': gender,
      'cnic': cnic,
      'age': age,
      'address': address,
      'license_number': licenseNumber,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert Supabase response → model
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] ?? '',
      authId: map['auth_id'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      fullName: map['full_name'] ?? '',
      gender: map['gender'],
      cnic: map['cnic'],
      age: map['age'],
      address: map['address'],
      licenseNumber: map['license_number'] ?? '',
      vehicleType: map['vehicle_type'] ?? '',
      vehicleNumber: map['vehicle_number'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : DateTime.now(),
    );
  }

  DriverModel copyWith({
    String? fullName,
    String? gender,
    String? cnic,
    int? age,
    String? address,
    String? vehicleType,
    String? vehicleNumber,
  }) {
    return DriverModel(
      id: id,
      authId: authId,
      phoneNumber: phoneNumber,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      cnic: cnic ?? this.cnic,
      age: age ?? this.age,
      address: address ?? this.address,
      licenseNumber: licenseNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      createdAt: createdAt,
    );
  }
}
