class LocalModel {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String cnic;
  final String gender;
  final String address;
  final DateTime createdAt;



  LocalModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.cnic,
    required this.gender,
    required this.address,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'phone_number': phoneNumber,
      'full_name': fullName,
      'cnic': cnic,
      'gender': gender,
      // 'age': age,
      'address': address,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory LocalModel.fromMap(Map<String, dynamic> map) {
    return LocalModel(
      id: map['id']?.toString() ?? '',
      phoneNumber: map['phone_number']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      cnic: map['cnic']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      // age: (map['age'] is int)
      //     ? map['age'] as int
      //     : int.tryParse(map['age']?.toString() ?? '') ?? 0,
      address: map['address']?.toString() ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  LocalModel copyWith({
    String? phoneNumber,
    String? fullName,
    String? cnic,
    String? gender,
    /// int? age,
    String? address,
  }) {
    return LocalModel(
      id: id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      cnic: cnic ?? this.cnic,
      gender: gender ?? this.gender,
      // age: age ?? this.age,
      address: address ?? this.address,
      createdAt: createdAt,
    );
  }
}
