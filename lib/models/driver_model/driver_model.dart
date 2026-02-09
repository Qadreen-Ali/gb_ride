class DriverModel {
  final String id;

  // Personal info
  final String fullName;
  final String cnic;
  final String gender;
  final int age;
  final String address;
  final String phoneNumber;

  // Vehicle info
  final String vehicleType; // Bike / Car
  final String vehicleNumber;
  final String licenseNumber;

  // Meta
  final bool isActive;
  final DateTime createdAt;

  DriverModel({
    required this.id,
    required this.fullName,
    required this.cnic,
    required this.gender,
    required this.age,
    required this.address,
    required this.phoneNumber,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.licenseNumber,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert model → Map (API / Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'cnic': cnic,
      'gender': gender,
      'age': age,
      'address': address,
      'phoneNumber': phoneNumber,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert Map → Model (API response)
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      cnic: map['cnic'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] is int ? map['age'] : int.tryParse('${map['age']}') ?? 0,
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// CopyWith (state updates)
  DriverModel copyWith({
    String? fullName,
    String? cnic,
    String? gender,
    int? age,
    String? address,
    String? phoneNumber,
    String? vehicleType,
    String? vehicleNumber,
    bool? isActive,
  }) {
    return DriverModel(
      id: id,
      fullName: fullName ?? this.fullName,
      cnic: cnic ?? this.cnic,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      licenseNumber: licenseNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
