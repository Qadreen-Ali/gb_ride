class UserModel {
  final String id;
  final String email;
  final int? phoneNumber;
  final String fullName;
  final String? profileImageUrl;
  final String role; // 'rider' | 'driver' | 'both'
  final String? gender; // 'Male' | 'Female' | 'Other'
  final String? cnic; // CNIC or B-Form number
  final int? age;
  final String? address;
  final double? rating;
  final int totalRides;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.fullName,
    this.profileImageUrl,
    required this.role,
    this.gender,
    this.cnic,
    this.age,
    this.address,
    this.rating,
    this.totalRides = 0,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as int?,
      fullName: json['full_name'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      role: json['role'] as String,
      gender: json['gender'] as String?,
      cnic: json['cnic'] as String?,
      age: json['age'] as int?,
      address: json['address'] as String?,
      rating: (json['rating'] == null)
          ? null
          : (json['rating'] as num).toDouble(),
      totalRides: (json['total_rides'] ?? 0) as int,
      isVerified: (json['is_verified'] ?? false) as bool,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'role': role,
      'gender': gender,
      'cnic': cnic,
      'age': age,
      'address': address,
      'rating': rating,
      'total_rides': totalRides,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
