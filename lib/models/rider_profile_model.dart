class RiderProfileModel {
  final String id;
  final String userId;
  final int totalRides;
  final double rating;
  final bool isVerified;
  final List<String> savedAddresses;
  final String? preferredPaymentMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RiderProfileModel({
    required this.id,
    required this.userId,
    this.totalRides = 0,
    this.rating = 0.0,
    this.isVerified = false,
    this.savedAddresses = const [],
    this.preferredPaymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert JSON from Supabase to RiderProfileModel
  factory RiderProfileModel.fromJson(Map<String, dynamic> json) {
    return RiderProfileModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      totalRides: json['total_rides'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      isVerified: json['is_verified'] ?? false,
      savedAddresses: List<String>.from(json['saved_addresses'] ?? []),
      preferredPaymentMethod: json['preferred_payment_method'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert RiderProfileModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_rides': totalRides,
      'rating': rating,
      'is_verified': isVerified,
      'saved_addresses': savedAddresses,
      'preferred_payment_method': preferredPaymentMethod,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Copy with method for updates
  RiderProfileModel copyWith({
    String? id,
    String? userId,
    int? totalRides,
    double? rating,
    bool? isVerified,
    List<String>? savedAddresses,
    String? preferredPaymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RiderProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalRides: totalRides ?? this.totalRides,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      preferredPaymentMethod:
          preferredPaymentMethod ?? this.preferredPaymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'RiderProfileModel(id: $id, userId: $userId, totalRides: $totalRides, rating: $rating, isVerified: $isVerified)';
}
