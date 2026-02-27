class LocalModel {
  final String id;
  final String authId;

  // Auth / identity
  final String phoneNumber; // 🔑 from otp_verifications

  // Profile info
  final String fullName;
  final String cnic;
  final String gender;



  final String address;

  final DateTime createdAt;

  LocalModel( {
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.cnic,
    required this.gender,
    required this.address,
    required this.authId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert model → Supabase insert map
  Map<String, dynamic> toMap() {
    return {
      'phone_number': phoneNumber,
      'id': id,
      'authId': authId,
      'full_name': fullName,
      'cnic': cnic,
      'gender': gender,
      'address': address,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert Supabase response → model
  factory LocalModel.fromMap(Map<String, dynamic> map) {
    return LocalModel(
      id: map['id'] ?? '',
      authId: map['authId'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      fullName: map['full_name'] ?? '',
      cnic: map['cnic'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : DateTime.now(),
    );
  }

  LocalModel copyWith({
    String? fullName,
    String? cnic,
    String? gender,
    int? age,
    String? address,
  }) {
    return LocalModel(
      id: id,
      authId: authId,
      phoneNumber: phoneNumber,
      fullName: fullName ?? this.fullName,
      cnic: cnic ?? this.cnic,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      createdAt: createdAt,
    );
  }
}
