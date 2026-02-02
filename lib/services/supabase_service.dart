import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/ride_model.dart';
import '../models/driver_model.dart';
import '../models/notification_model.dart';
import '../models/rating_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  String? getCurrentUserId() => _client.auth.currentUser?.id;

  Future<UserModel?> getUserByPhone(String phoneNumber) async {
    try {
      final res = await _client
          .from('users')
          .select()
          .eq('phone_number', phoneNumber)
          .single();
      return UserModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      return null;
    }
  }

  // ========================================
  // RIDES
  // ========================================

  /// Fetch ALL rides (NO filtering)
  Future<List<RideModel>> fetchAllRides() async {
    try {
      print('📡 Querying Supabase: SELECT * FROM rides');

      final res = await _client
          .from('rides')
          .select()
          .order('created_at', ascending: false);

      print('📦 Raw response length: ${(res as List).length}');

      return (res)
          .map((e) => RideModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching all rides: $e');
      print(stackTrace);
      throw Exception('Error fetching all rides');
    }
  }

  Future<List<RideModel>> fetchRidesByRider(String riderId) async {
    try {
      final res = await _client
          .from('rides')
          .select()
          .eq('rider_id', riderId)
          .order('created_at', ascending: false);
      return (res as List)
          .map((e) => RideModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Error fetching rides: $e');
    }
  }

  Future<RideModel?> fetchRideById(String rideId) async {
    try {
      final res = await _client
          .from('rides')
          .select()
          .eq('id', rideId)
          .single();
      return RideModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      return null;
    }
  }

  Future<RideModel> createRide({
    required String riderId,
    required Map<String, dynamic> pickupLocation,
    required Map<String, dynamic> destinationLocation,
    required String vehicleType,
    required String paymentMethod,
    double? offeredFare,
    int? estimatedMinutes,
    double? distanceKm,
    String? messageForDriver,
  }) async {
    try {
      final res = await _client
          .from('rides')
          .insert({
            'rider_id': riderId,
            'pickup_location': pickupLocation,
            'destination_location': destinationLocation,
            'vehicle_type': vehicleType,
            'payment_method': paymentMethod,
            'offered_fare': offeredFare,
            'estimated_minutes': estimatedMinutes,
            'distance_km': distanceKm,
            'message_for_driver': messageForDriver,
            'status': 'pending',
          })
          .select()
          .single();
      return RideModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      throw Exception('Error creating ride: $e');
    }
  }

  Future<void> updateRideStatus(String rideId, String status) async {
    try {
      await _client.from('rides').update({'status': status}).eq('id', rideId);
    } catch (e) {
      throw Exception('Error updating ride: $e');
    }
  }

  Future<List<RideModel>> fetchPendingRidesByVehicleType(
    String vehicleType,
  ) async {
    try {
      final res = await _client
          .from('rides')
          .select()
          .eq('vehicle_type', vehicleType)
          .eq('status', 'pending')
          .order('created_at', ascending: false);
      return (res as List)
          .map((e) => RideModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Error fetching pending rides: $e');
    }
  }

  // ✅ FIXED TYPE ERROR ONLY
  Future<void> acceptRideAsDriver(
    String rideId,
    String driverId, {
    double? acceptedFare,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'driver_id': driverId,
        'status': 'driverAssigned',
      };

      if (acceptedFare != null) {
        updates['accepted_fare'] = acceptedFare; // ✅ double
      }

      await _client.from('rides').update(updates).eq('id', rideId);
    } catch (e) {
      throw Exception('Error accepting ride: $e');
    }
  }

  // ✅ FIXED TYPE ERROR ONLY
  Future<void> completeRide(
    String rideId, {
    double? finalFare,
    double? actualDistance,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'status': 'completed',
        'end_time': DateTime.now().toIso8601String(),
      };

      if (finalFare != null) {
        updates['accepted_fare'] = finalFare; // ✅ double
      }
      if (actualDistance != null) {
        updates['distance_km'] = actualDistance; // ✅ double
      }

      await _client.from('rides').update(updates).eq('id', rideId);
    } catch (e) {
      throw Exception('Error completing ride: $e');
    }
  }

  // ========================================
  // USERS
  // ========================================

  Future<UserModel?> fetchUserById(String userId) async {
    try {
      final res = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> createOrUpdateUser({
    required String userId,
    required String email,
    required String phoneNumber,
    required String fullName,
    required String role,
    String? gender,
    String? cnic,
    int? age,
    String? address,
    String? profileImageUrl,
  }) async {
    try {
      final res = await _client
          .from('users')
          .upsert({
            'id': userId,
            'email': email,
            'phone_number': phoneNumber,
            'full_name': fullName,
            'role': role,
            'gender': gender,
            'cnic': cnic,
            'age': age,
            'address': address,
            'profile_image_url': profileImageUrl,
            'is_verified': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      return UserModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      throw Exception('Error creating/updating user: $e');
    }
  }

  // ========================================
  // DRIVERS
  // ========================================

  Future<DriverModel?> getDriverByUserId(String userId) async {
    try {
      final res = await _client
          .from('drivers')
          .select()
          .eq('user_id', userId)
          .single();
      return DriverModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      print('Error fetching driver: $e');
      return null;
    }
  }

  Future<DriverModel> createDriver({
    required String userId,
    required String licenseNumber,
    String? licenseImageUrl,
    String? vehicleType,
    String? vehicleNumber,
  }) async {
    try {
      final res = await _client
          .from('drivers')
          .insert({
            'user_id': userId,
            'license_number': licenseNumber,
            'license_image_url': licenseImageUrl,
            'vehicle_type': vehicleType,
            'vehicle_number': vehicleNumber,
            'status': 'available',
            'is_online': false,
          })
          .select()
          .single();
      return DriverModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      throw Exception('Error creating driver: $e');
    }
  }

  Future<List<RideModel>> fetchRidesByDriver(String driverId) async {
    try {
      final res = await _client
          .from('rides')
          .select()
          .eq('driver_id', driverId)
          .order('created_at', ascending: false);
      return (res as List)
          .map((e) => RideModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Error fetching driver rides: $e');
    }
  }

  Future<void> updateDriverStatus(
  String driverId, {
  required String status,
  bool? isOnline,
}) async {
  try {
    final Map<String, dynamic> updates = {
      'status': status,
    };

    if (isOnline != null) {
      updates['is_online'] = isOnline;
    }

    await _client.from('drivers').update(updates).eq('id', driverId);
  } catch (e) {
    throw Exception('Error updating driver status: $e');
  }
}

Future<void> updateDriverLocation(
  String driverId,
  double latitude,
  double longitude,
) async {
  try {
    await _client
        .from('drivers')
        .update({
          'current_latitude': latitude,
          'current_longitude': longitude,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', driverId);
  } catch (e) {
    throw Exception('Error updating driver location: $e');
  }
}


  // ========================================
  // NOTIFICATIONS
  // ========================================

  Future<List<NotificationModel>> fetchNotifications(String userId) async {
    try {
      final res = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (res as List)
          .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Error updating notification: $e');
    }
  }

  // ========================================
  // RATINGS
  // ========================================

  Future<void> createRating({
    required String rideId,
    required String raterId,
    required String ratedUserId,
    required int rating,
    List<String>? tags,
    int? tip,
    String? comment,
  }) async {
    try {
      await _client.from('ratings').insert({
        'ride_id': rideId,
        'rater_id': raterId,
        'rated_user_id': ratedUserId,
        'rating': rating,
        'tags': tags ?? [],
        'tip': tip,
        'comment': comment,
      });
    } catch (e) {
      throw Exception('Error creating rating: $e');
    }
  }
}
