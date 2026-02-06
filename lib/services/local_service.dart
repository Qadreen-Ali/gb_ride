import 'package:supabase_flutter/supabase_flutter.dart';

class LocalService {
  final _client = Supabase.instance.client;

  Future<void> createLocal({
    required String phoneNumber,
    required String fullName,
    String? gender,
    String? cnic,
    String? address,
  }) async {
    try {
      await _client.from('locals').insert({
        'phone_number': phoneNumber,
        'full_name': fullName,
        'gender': gender,
        'cnic': cnic,
        'address': address,
      });
    } catch (e) {
      throw Exception('Error creating local user: $e');
    }
  }
}
