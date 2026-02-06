import 'supabase_service.dart';
import '../models/ride_model.dart';
import '../models/saved_address_model.dart';
import '../models/payment_method_model.dart';

class RiderService {
  final SupabaseService _supabaseService;

  RiderService(this._supabaseService);

  // ========================================
  // RIDE CREATION & MANAGEMENT
  // ========================================

  /// Create a new ride request as a rider
  Future<RideModel> createRideRequest({
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
      final ride = await _supabaseService.createRide(
        riderId: riderId,
        pickupLocation: pickupLocation,
        destinationLocation: destinationLocation,
        vehicleType: vehicleType,
        paymentMethod: paymentMethod,
        offeredFare: offeredFare,
        estimatedMinutes: estimatedMinutes,
        distanceKm: distanceKm,
        messageForDriver: messageForDriver,
      );
      print('✅ Ride request created: ${ride.id}');
      return ride;
    } catch (e) {
      print('❌ Error creating ride request: $e');
      rethrow;
    }
  }

  /// Cancel a ride (rider initiated)
  Future<void> cancelRide(String rideId, {String? reason}) async {
    try {
      await _supabaseService.updateRideStatus(rideId, 'cancelledByRider');
      print('✅ Ride cancelled by rider: $rideId');
    } catch (e) {
      print('❌ Error cancelling ride: $e');
      rethrow;
    }
  }

  /// Fetch ride history for a rider
  Future<List<RideModel>> getRideHistory(String riderId) async {
    try {
      final rides = await _supabaseService.fetchRidesByRider(riderId);
      return rides.where((ride) {
        final completedStates = [
          'completed',
          'cancelledByRider',
          'cancelledByDriver',
        ];
        return completedStates.contains(ride.status);
      }).toList();
    } catch (e) {
      print('❌ Error fetching ride history: $e');
      rethrow;
    }
  }

  /// Get active ride for rider (if any)
  Future<RideModel?> getActiveRide(String riderId) async {
    try {
      final rides = await _supabaseService.fetchRidesByRider(riderId);
      final activeRides = rides.where((ride) {
        final activeStates = [
          'pending',
          'driverAssigned',
          'driverArrived',
          'rideStarted',
        ];
        return activeStates.contains(ride.status);
      }).toList();

      return activeRides.isNotEmpty ? activeRides.first : null;
    } catch (e) {
      print('❌ Error getting active ride: $e');
      return null;
    }
  }

  /// Track specific ride by ID
  Future<RideModel?> trackRide(String rideId) async {
    try {
      return await _supabaseService.fetchRideById(rideId);
    } catch (e) {
      print('❌ Error tracking ride: $e');
      return null;
    }
  }

  // ========================================
  // RIDER PROFILE
  // ========================================

  /// Initialize rider profile on first signup
  Future<void> initializeRiderProfile(String userId) async {
    try {
      await _supabaseService.createOrUpdateRiderProfile(userId);
      print('✅ Rider profile initialized: $userId');
    } catch (e) {
      print('❌ Error initializing rider profile: $e');
      rethrow;
    }
  }

  /// Update rider preferences
  Future<void> updateRiderPreferences({
    required String userId,
    String? preferredPaymentMethod,
  }) async {
    try {
      await _supabaseService.createOrUpdateRiderProfile(
        userId,
        preferredPaymentMethod: preferredPaymentMethod,
      );
      print('✅ Rider preferences updated');
    } catch (e) {
      print('❌ Error updating rider preferences: $e');
      rethrow;
    }
  }

  // ========================================
  // SAVED ADDRESSES
  // ========================================

  /// Fetch all saved addresses for rider
  Future<List<SavedAddressModel>> getSavedAddresses(String userId) async {
    try {
      final addresses = await _supabaseService.fetchSavedAddresses(userId);
      return addresses.map((a) => SavedAddressModel.fromJson(a)).toList();
    } catch (e) {
      print('❌ Error fetching saved addresses: $e');
      rethrow;
    }
  }

  /// Add a new saved address
  Future<SavedAddressModel> addSavedAddress({
    required String userId,
    required String name,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final result = await _supabaseService.addSavedAddress(
        userId: userId,
        name: name,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      print('✅ Saved address added: $name');
      return SavedAddressModel.fromJson(result);
    } catch (e) {
      print('❌ Error adding saved address: $e');
      rethrow;
    }
  }

  /// Delete a saved address
  Future<void> deleteSavedAddress(String addressId) async {
    try {
      await _supabaseService.deleteSavedAddress(addressId);
      print('✅ Saved address deleted');
    } catch (e) {
      print('❌ Error deleting saved address: $e');
      rethrow;
    }
  }

  // ========================================
  // PAYMENT METHODS
  // ========================================

  /// Fetch all payment methods for rider
  Future<List<PaymentMethodModel>> getPaymentMethods(String userId) async {
    try {
      final methods = await _supabaseService.fetchPaymentMethods(userId);
      return methods.map((m) => PaymentMethodModel.fromJson(m)).toList();
    } catch (e) {
      print('❌ Error fetching payment methods: $e');
      rethrow;
    }
  }

  /// Add a new payment method
  Future<PaymentMethodModel> addPaymentMethod({
    required String userId,
    required String type,
    String? cardLast4,
    String? bankName,
  }) async {
    try {
      final result = await _supabaseService.addPaymentMethod(
        userId: userId,
        type: type,
        cardLast4: cardLast4,
        bankName: bankName,
      );
      print('✅ Payment method added');
      return PaymentMethodModel.fromJson(result);
    } catch (e) {
      print('❌ Error adding payment method: $e');
      rethrow;
    }
  }

  /// Set default payment method
  Future<void> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      await _supabaseService.setDefaultPaymentMethod(paymentMethodId);
      print('✅ Default payment method set');
    } catch (e) {
      print('❌ Error setting default payment method: $e');
      rethrow;
    }
  }

  /// Delete a payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      await _supabaseService.deletePaymentMethod(paymentMethodId);
      print('✅ Payment method deleted');
    } catch (e) {
      print('❌ Error deleting payment method: $e');
      rethrow;
    }
  }

  // ========================================
  // NOTIFICATIONS
  // ========================================

  /// Fetch notifications for rider
  Future<void> getNotifications(String userId) async {
    try {
      final notifications = await _supabaseService.fetchNotifications(userId);
      print('✅ Fetched ${notifications.length} notifications');
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      rethrow;
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _supabaseService.markNotificationAsRead(notificationId);
      print('✅ Notification marked as read');
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      rethrow;
    }
  }
}
