import '../models/ride_model.dart';
import '../models/ride_status.dart';
import '../models/ride_ui_model.dart';
import '../models/ride_adapter.dart';
import '../models/driver_model.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class RideService {
  final _supabaseService = SupabaseService();

  /// Create a new ride request (Rider initiates)
  Future<RideModel> createRideRequest({
    required String riderId,
    required Map<String, dynamic> pickupLocation,
    required Map<String, dynamic> destinationLocation,
    required String vehicleType, // 'car' | 'bike' | 'city'
    required String paymentMethod,
    double? offeredFare,
    double? estimatedDistance,
    int? estimatedMinutes,
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
        distanceKm: estimatedDistance,
        messageForDriver: messageForDriver,
      );

      return ride;
    } catch (e) {
      throw Exception('Error creating ride request: $e');
    }
  }

  /// Accept ride as driver (assign driver to ride)
  Future<void> acceptRide({
    required String rideId,
    required String driverId,
    double? acceptedFare,
  }) async {
    try {
      // Accept ride and assign driver
      await _supabaseService.acceptRideAsDriver(
        rideId,
        driverId,
        acceptedFare: acceptedFare,
      );

      // Update driver status to onRide
      await _supabaseService.updateDriverStatus(driverId, status: 'onRide');
    } catch (e) {
      throw Exception('Error accepting ride: $e');
    }
  }

  /// Get available rides for driver (pending rides for their vehicle type)
  Future<List<RideUiModel>> getAvailableRidesForDriver(
    DriverModel driver,
  ) async {
    try {
      if (driver.vehicleType == null) {
        throw Exception('Driver vehicle type not set');
      }

      final rideModels = await _supabaseService.fetchPendingRidesByVehicleType(
        driver.vehicleType!,
      );

      // Fetch rider info for each ride to create UI models
      List<RideUiModel> uiRides = [];
      for (final ride in rideModels) {
        final rider = await _supabaseService.fetchUserById(ride.riderId);
        if (rider != null) {
          final uiModel = RideAdapter.fromCanonical(
            ride: ride,
            driverName: rider.fullName,
            driverImagePath:
                rider.profileImageUrl ?? 'assets/images/profile.png',
          );
          uiRides.add(uiModel);
        }
      }

      return uiRides;
    } catch (e) {
      throw Exception('Error fetching available rides: $e');
    }
  }

  /// Get active rides for rider
  Future<List<RideModel>> getActiveRidesForRider(String riderId) async {
    try {
      final rides = await _supabaseService.fetchRidesByRider(riderId);

      // Filter for active rides
      return rides.where((ride) => ride.status.isActive).toList();
    } catch (e) {
      throw Exception('Error fetching active rides: $e');
    }
  }

  /// Get ride history for rider
  Future<List<RideModel>> getRideHistoryForRider(String riderId) async {
    try {
      final rides = await _supabaseService.fetchRidesByRider(riderId);

      // Filter for completed or cancelled rides
      return rides.where((ride) => ride.status.isFinal).toList();
    } catch (e) {
      throw Exception('Error fetching ride history: $e');
    }
  }

  /// Update ride status (driver progresses through statuses)
  Future<void> updateRideStatus(String rideId, RideStatus newStatus) async {
    try {
      await _supabaseService.updateRideStatus(rideId, newStatus.dbValue);
    } catch (e) {
      throw Exception('Error updating ride status: $e');
    }
  }

  /// Complete ride (mark as completed with final details)
  Future<void> completeRide({
    required String rideId,
    required double finalFare,
    double? actualDistance,
  }) async {
    try {
      await _supabaseService.completeRide(
        rideId,
        finalFare: finalFare,
        actualDistance: actualDistance,
      );
    } catch (e) {
      throw Exception('Error completing ride: $e');
    }
  }

  /// Cancel ride
  Future<void> cancelRide({
    required String rideId,
    required String cancelledBy, // 'rider' | 'driver'
    String? cancellationReason,
  }) async {
    try {
      final updates = {
        'status': RideStatus.cancelled.dbValue,
        'cancelled_by': cancelledBy,
      };
      if (cancellationReason != null) {
        updates['cancellation_reason'] = cancellationReason;
      }

      // Manual update since we don't have a direct cancel method
      await _supabaseService.updateRideStatus(
        rideId,
        RideStatus.cancelled.dbValue,
      );
    } catch (e) {
      throw Exception('Error cancelling ride: $e');
    }
  }

  /// Get specific ride details
  Future<RideModel?> getRideDetails(String rideId) async {
    try {
      return await _supabaseService.fetchRideById(rideId);
    } catch (e) {
      return null;
    }
  }
}
