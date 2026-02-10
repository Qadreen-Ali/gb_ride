import 'package:gb_ride/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  AuthController._internal();
  static final AuthController instance = AuthController._internal();

  //handle all auth related logic here (requesting OTP, verifying OTP, fetching user profile, etc.)
  User? get currentUser => supabase.auth.currentUser;

  final supabase = Supabase.instance.client;
  String? _phone;
  String? _debugOtp;
  String? get verifiedPhone => _phone;

  bool isValidPakNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^(0?3\d{9}|92\d{10})$').hasMatch(cleaned);
  }

  String normalizePhone(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    return cleaned.startsWith('92') ? '+$cleaned' : '+92$cleaned';
  }

  Future<void> requestOtp({
    required String phone,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      _phone = normalizePhone(phone);

      final response = await supabase.functions.invoke(
        'send-otp',
        body: {'phone': _phone},
      );

      if (response.data['success'] == true) {
        _debugOtp = response.data['debug_otp']; // DEV only
        onSuccess();
      } else {
        onError(response.data['error'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      onError('Error sending OTP: $e');
    }
  }

  Future<void> verifyOtp({
    required String otp,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      // 🔥 DEV MODE BYPASS (MUST BE FIRST)
      if (otp.trim() == '123456') {
        logger.i('DEV OTP ACCEPTED');
        await supabase.auth.signInAnonymously();
        logger.i('AUTH USER: ${supabase.auth.currentUser}');
        onSuccess();
        return;
      }

      // 🛑 SAFETY CHECK
      if (_phone == null) {
        onError('Phone number missing. Please retry.');
        return;
      }

      // 🔴 PRODUCTION OTP (WILL FAIL IN DEV – THAT’S OK)
      await supabase.auth.verifyOTP(
        phone: _phone!,
        token: otp.trim(),
        type: OtpType.sms,
      );

      onSuccess();
    } catch (e) {
      onError('Invalid OTP');
    }
  }

  // Fetch user profile from 'drivers' or 'locals' table based on current user's phone number
  Future<Map<String, dynamic>?> getExistingProfile(String authId) async {
    try {
      // check driver first
      final driver = await supabase
          .from('drivers')
          .select()
          .eq('auth_id', authId)
          .maybeSingle();

      if (driver != null) {
        return {'role': 'driver', 'data': driver};
      }

      // check local
      final local = await supabase
          .from('locals')
          .select()
          .eq('auth_id', authId)
          .maybeSingle();

      if (local != null) {
        return {'role': 'local', 'data': local};
      }

      return null; // new user
    } catch (_) {
      return null;
    }
  }

  // Logout user
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  String? getDebugOtp() => _debugOtp;
}
