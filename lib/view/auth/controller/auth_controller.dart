import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  AuthController._internal();
  static final AuthController instance = AuthController._internal();

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
      if (_phone == null) {
        onError('Phone number missing. Please retry.');
        return;
      }

      final response = await supabase.functions.invoke(
        'verify-otp',
        body: {'phone': _phone, 'otp': otp},
      );

      if (response.data['success'] == true) {
        onSuccess();
      } else {
        onError('Invalid verification code');
      }
    } catch (e) {
      onError('Verification error: $e');
    }
  }

  String? getDebugOtp() => _debugOtp;
}
