import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gb_ride/models/driver_model/driver_model.dart';

class DriverService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createDriver(DriverModel driver) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _client.from('drivers').insert({
        'auth_id': user.id,
        'phone_number': driver.phoneNumber,
        'full_name': driver.fullName,
        'gender': driver.gender,
        'cnic': driver.cnic,
        'age': driver.age,
        'address': driver.address,
        'license_number': driver.licenseNumber,
        'vehicle_type': driver.vehicleType,
        'vehicle_number': driver.vehicleNumber,
      });
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Fetch driver by phone number
  Future<Map<String, dynamic>?> getDriverByPhone(String phoneNumber) async {
    final response = await _client
        .from('drivers')
        .select()
        .eq('phone_number', phoneNumber)
        .maybeSingle();

    return response;
  }

  /// Fetch driver by id
  Future<Map<String, dynamic>?> getDriverById(String id) async {
    final response = await _client
        .from('drivers')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response;
  }
}
