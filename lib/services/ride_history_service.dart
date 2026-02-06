import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gb_ride/models/ride_history_model.dart';
import 'package:gb_ride/models/driver_model.dart';

class RideHistoryService {
  final SupabaseClient _client = Supabase.instance.client;

  /// ================= RIDER HISTORY =================
  Future<List<RideHistoryModel>> getRideHistoryForRider(String riderId) async {
    final response = await _client
        .from('rides')
        .select('*')
        .eq('rider_id', riderId)
        .inFilter('ride_status', ['completed', 'cancelled'])
        .order('created_at', ascending: false);

    if (response == null || response.isEmpty) return [];

    return (response as List)
        .map((e) => RideHistoryModel.fromJson(e))
        .toList();
  }

  /// ================= DRIVER HISTORY =================
  Future<List<RideHistoryModel>> getRideHistoryForDriver(String driverId) async {
    final response = await _client
        .from('rides')
        .select('*')
        .eq('driver_id', driverId)
        .inFilter('ride_status', ['completed', 'cancelled'])
        .order('created_at', ascending: false);

    if (response == null || response.isEmpty) return [];

    return (response as List)
        .map((e) => RideHistoryModel.fromJson(e))
        .toList();
  }

  /// ================= DRIVER DETAILS =================
  Future<DriverModel?> getDriverById(String driverId) async {
    final response = await _client
        .from('drivers')
        .select('*')
        .eq('id', driverId)
        .maybeSingle();

    if (response == null) return null;

    return DriverModel.fromJson(response);
  }
}
