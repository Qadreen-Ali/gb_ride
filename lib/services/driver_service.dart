import 'package:supabase_flutter/supabase_flutter.dart';

class DriverService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createDriver({
    required String phoneNumber,
    required String fullName,
    String? gender,
    String? cnic,
    int? age,
    String? address,
    required String licenseNumber,
    required String vehicleType,
    required String vehicleNumber,
  }) async {
    try {
      await _client.from('drivers').insert({
        'phone_number': phoneNumber,
        'full_name': fullName,
        'gender': gender,
        'cnic': cnic,
        'age': age,
        'address': address,
        'license_number': licenseNumber,
        'vehicle_type': vehicleType,
        'vehicle_number': vehicleNumber,
      });
    } catch (e) {
      throw Exception('Error creating driver: $e');
    }
  }
}
