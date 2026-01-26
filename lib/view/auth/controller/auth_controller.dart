import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  AuthController._internal();
  static final AuthController instance = AuthController._internal();

  final supabase = Supabase.instance.client;
  String? _phone;
  String? _debugOtp; // Store debug OTP for testing

  // 1. Validation Logic
  bool isValidPakNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^3\d{9}$').hasMatch(cleaned);
  }

  String normalizePhone(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    return '+92$cleaned';
  }

  // 2. Request OTP (Call Edge Function instead of Supabase Auth)
  Future<void> requestOtp({
    required String phone,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      _phone = phone;

      // Call your Edge Function instead
      final response = await supabase.functions.invoke(
        'send-otp',
        body: {'phone': _phone},
      );

      print('Edge Function Response: ${response.data}');

      if (response.data['success'] == true) {
        // Store debug OTP for testing (remove in production)
        _debugOtp = response.data['debug_otp'];
        print('DEBUG OTP: $_debugOtp'); // You'll see this in console

        onSuccess();
      } else {
        onError(
          'Failed to send OTP: ${response.data['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      onError('Error sending SMS: $e');
    }
  }

  // 3. Verify OTP (Call your verify Edge Function)
  Future<void> verifyOtp({
    required String otp,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'verify-otp',
        body: {'phone': _phone!, 'otp': otp},
      );

      print('Verify Response: ${response.data}');

      if (response.data['success'] == true) {
        // OTP verified successfully
        // Now you can create a user session or navigate to home
        onSuccess();
      } else {
        onError('Invalid verification code');
      }
    } catch (e) {
      onError('Verification Error: $e');
    }
  }

  // Helper: Get debug OTP (for testing only)
  String? getDebugOtp() {
    return _debugOtp;
  }
}
