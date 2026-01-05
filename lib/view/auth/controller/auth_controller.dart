import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  AuthController._internal();
  static final AuthController instance = AuthController._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  /// Validates Pakistani phone number (03XXXXXXXXX)
  bool isValidPakNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^3\d{9}$').hasMatch(cleaned);
  }

  /// Converts 03XXXXXXXXX → +923XXXXXXXXX
  String toFirebasePhone(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    return '+92$cleaned';
  }

  void requestOtp({
    required String phone,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) {
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // OPTIONAL: auto-login
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onSuccess();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOtp({
    required String otp,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      if (_verificationId == null) {
        onError('OTP expired. Please resend.');
        return;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      onSuccess();
    } catch (e) {
      onError('Invalid OTP');
    }
  }
}
