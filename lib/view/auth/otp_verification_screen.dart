import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/utils/logger.dart';
import 'package:gb_ride/view/auth/common/otp_field.dart';

class OTPVerificationScreen extends StatefulWidget {
  // const OTPVerificationScreen({super.key});
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});
  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  // String _otp = '';
  // bool _isOTPComplete = false;

  @override
  Widget build(BuildContext context) {
    // final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: GBColor.secondary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        // onTap: () => FocusScope.of(context).unfocus(),
        // child: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),

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
                '+92 ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: GBColor.primary,
                ),
              ),
              // const SizedBox(height: 10),
              SizedBox(height: 60),

              OTPField(
                length: 6,
                fieldWidth: 45,
                fieldHeight: 50,
                spacing: 10,
                onChanged: (value) {
                  setState(() {
                    // _otp = value;
                    // _isOTPComplete = value.length == 6;
                  });
                  logger.i('OTP Changed: $value');
                },
                onCompleted: (value) {
                  setState(() {
                    // _otp = value;
                    // _isOTPComplete = true;
                  });
                  logger.i('OTP Completed: $value');
                },
              ),
              const SizedBox(height: 20),
              //Primary Button
              SecondaryButton(
                title: GBText.continueBtn,
                // backgroundColor: GBColor.secondary,
                onPressed:
                    // _isOTPComplete?
                    () {
                      // Sign up logic here
                      Navigator.pushNamed(context, '/form');
                      // logger.i('Verifying OTP: $_otp');
                    },
                // : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, '/login');
                    },
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
                  Spacer(),
                  Text(
                    GBText.sendBySMS,
                    style: TextStyle(
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
              //Terms of Service Text
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
                      style: const TextStyle(
                        color: GBColor.primary,
                        // decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          logger.i('Terms of Services Tapped');
                        },
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: GBText.privacyPolicy,
                      style: const TextStyle(
                        color: GBColor.primary,
                        // decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          logger.i('Privacy Policy Tapped');
                        },
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
