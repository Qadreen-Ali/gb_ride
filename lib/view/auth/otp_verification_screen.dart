import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/utils/logger.dart';
import 'package:gb_ride/view/auth/common/otp_field.dart';
import 'controller/auth_controller.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  //handle OTP verification and resend logic here
  Future<void> _handlePostOtpNavigation() async {
    final user = _authController.currentUser; // from auth controller

    if (user == null) return;

    final existingUser = await _authController.getExistingProfile(user.id);

    if (existingUser != null) {
      // OLD USER → GO HOME
      final role = existingUser['role'];

      if (role == 'driver') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/driver-home',
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/local-home',
          (route) => false,
        );
      }
    } else {
      // NEW USER → REGISTRATION FORM
      Navigator.pushReplacementNamed(context, '/form');
    }
  }

  //
  final AuthController _authController = AuthController.instance;
  String _otp = '';

  bool get _isOTPComplete => _otp.length == 6;

  void _verifyOtp() {
    if (_isOTPComplete) {
      _authController.verifyOtp(
        otp: _otp,
        onSuccess: () async {
          await _handlePostOtpNavigation();
        },
        onError: (error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        },
      );
    }
  }

  void _resendOtp() {
    _authController.requestOtp(
      phone: widget.phoneNumber,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully')),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                GBText.verificationCode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                GBText.codeSent,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: GBColor.gray,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                ' ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: GBColor.primary,
                ),
              ),
              const SizedBox(height: 60),
              OTPField(
                length: 6,
                fieldWidth: 45,
                fieldHeight: 50,
                spacing: 10,
                onChanged: (value) {
                  setState(() {
                    _otp = value;
                  });
                  logger.i('OTP Changed: $value');
                },
                onCompleted: (value) {
                  setState(() {
                    _otp = value;
                  });
                  logger.i('OTP Completed: $value');
                },
              ),
              const SizedBox(height: 20),
              SecondaryButton(title: GBText.continueBtn, onPressed: _verifyOtp),
              const SizedBox(height: 10),
              Row(
                children: [
                  InkWell(
                    onTap: _resendOtp,
                    child: Text(
                      GBText.resendcode,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: GBColor.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    GBText.sendBySMS,
                    style: const TextStyle(
                      color: GBColor.textFieldText,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: GBColor.gray,
                  ),
                  children: [
                    const TextSpan(text: "By Continuing you agree to our "),
                    TextSpan(
                      text: GBText.termsofServices,
                      style: const TextStyle(color: GBColor.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          logger.i('Terms of Services Tapped');
                        },
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: GBText.privacyPolicy,
                      style: const TextStyle(color: GBColor.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          logger.i('Privacy Policy Tapped');
                        },
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
