import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gb_ride/models/local_model/local_model.dart';

class LocalService {
  LocalService._();
  static final LocalService instance = LocalService._();

  final SupabaseClient _client = Supabase.instance.client;

  /// Insert local user
  Future<void> createLocal(LocalModel local) async {
    try {
      await _client.from('locals').insert(local.toMap());
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get local by phone number
  Future<LocalModel?> getLocalByPhone(String phoneNumber) async {
    try {
      final data = await _client
          .from('locals')
          .select()
          .eq('phone_number', phoneNumber)
          .maybeSingle();

      if (data == null) return null;
      return LocalModel.fromMap(data);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }
}
