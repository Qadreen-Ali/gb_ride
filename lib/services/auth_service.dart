import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/driver_model.dart';
import 'supabase_service.dart';

class AuthService {
  final _supabase = Supabase.instance.client;
  final _supabaseService = SupabaseService();

  /// Register or complete user profile after OTP verification
  /// This is called for both riders and drivers during registration
  Future<UserModel> completeUserProfile({
    required String phoneNumber,
    required String fullName,
    required String role, // 'rider' | 'driver'
    String? gender,
    String? cnic,
    int? age,
    String? address,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final email =
          _supabase.auth.currentUser?.email ?? '$phoneNumber@gb-ride.app';

      // Create or update user
      final user = await _supabaseService.createOrUpdateUser(
        userId: userId,
        email: email,
        phoneNumber: phoneNumber,
        fullName: fullName,
        role: role,
        gender: gender,
        cnic: cnic,
        age: age,
        address: address,
      );

      return user;
    } catch (e) {
      throw Exception('Error completing user profile: $e');
    }
  }

  /// Register driver profile after user registration
  Future<DriverModel> completeDriverProfile({
    required String userId,
    required String licenseNumber,
    String? vehicleType,
    String? vehicleNumber,
    String? licenseImageUrl,
  }) async {
    try {
      // Create driver record
      final driver = await _supabaseService.createDriver(
        userId: userId,
        licenseNumber: licenseNumber,
        vehicleType: vehicleType,
        vehicleNumber: vehicleNumber,
        licenseImageUrl: licenseImageUrl,
      );

      return driver;
    } catch (e) {
      throw Exception('Error completing driver profile: $e');
    }
  }

  /// Get current user's full profile (User + Driver if applicable)
  Future<({UserModel user, DriverModel? driver})>
  getCurrentUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final user = await _supabaseService.fetchUserById(userId);
      if (user == null) {
        throw Exception('User profile not found');
      }

      // If user is a driver, fetch driver profile
      DriverModel? driver;
      if (user.role == 'driver' || user.role == 'both') {
        driver = await _supabaseService.getDriverByUserId(userId);
      }

      return (user: user, driver: driver);
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  /// Check if user is a driver
  Future<bool> isDriver() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final user = await _supabaseService.fetchUserById(userId);
      return user?.role == 'driver' || user?.role == 'both';
    } catch (e) {
      return false;
    }
  }

  /// Check if user is a rider
  Future<bool> isRider() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final user = await _supabaseService.fetchUserById(userId);
      return user?.role == 'rider' || user?.role == 'both';
    } catch (e) {
      return false;
    }
  }
}
