import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
// import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
// import 'package:gb_ride/utils/constants/social_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/utils/logger.dart';
import 'package:gb_ride/view/auth/common/otp_field.dart';
// import '../../common/textfield.dart';

class OTPVerificationScreen extends StatefulWidget {
  // const OTPVerificationScreen({super.key});
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});
  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String _otp = '';
  bool _isOTPComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.primary,
      // resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

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
              Text(
                '+92 ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: GBColor.black,
                ),
              ),
              // const SizedBox(height: 10),
              const SizedBox(height: 50),

              OTPField(
                length: 6,
                fieldWidth: 45,
                fieldHeight: 50,
                spacing: 10,
                onChanged: (value) {
                  setState(() {
                    _otp = value;
                    _isOTPComplete = value.length == 6;
                  });
                  logger.i('OTP Changed: $value');
                },
                onCompleted: (value) {
                  setState(() {
                    _otp = value;
                    _isOTPComplete = true;
                  });
                  logger.i('OTP Completed: $value');
                },
              ),
              //Primary Button
              PrimaryButton(
                title: GBText.signUp,
                onPressed: _isOTPComplete
                    ? () {
                        // Sign up logic here
                        logger.i('Verifying OTP: $_otp');
                      }
                    : null,
              ),
              const SizedBox(height: 30),
              //Divider with text "Or continue with"
              Row(
                children: [
                  Expanded(child: Container(height: 1.5, color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      GBText.orContinuewith,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: GBColor.gray,
                      ),
                    ),
                  ),
                  Expanded(child: Container(height: 1.5, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 40),
              //Social Media Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SocialSignInButton(
              //       title: '',
              //       leadingIcon: Image.asset(
              //         GBImagePath.google,
              //         width: 32,
              //         height: 32,
              //       ),
              //       onPressed: () {
              //         // Handle Google sign-in
              //         logger.i('Google Sign-In Pressed');
              //       },
              //     ),
              //     const SizedBox(width: 25),
              //     //apple button
              //     SocialSignInButton(
              //       title: '',
              //       leadingIcon: Image.asset(
              //         GBImagePath.apple,
              //         width: 32,
              //         height: 32,
              //       ),
              //       // backgroundColor: GBColor.containerColor,
              //       onPressed: () {
              //         // Handle Apple sign-in
              //         logger.i('Apple Sign-In Pressed');
              //       },
              //     ),
              //     //facebook button
              //     const SizedBox(width: 25),
              //     SocialSignInButton(
              //       title: '',
              //       leadingIcon: Image.asset(
              //         GBImagePath.facebook,
              //         width: 32,
              //         height: 32,
              //       ),
              //       // backgroundColor: GBColor.containerColor,
              //       onPressed: () {
              //         // Handle Apple sign-in
              //         logger.i('Apple Sign-In Pressed');
              //       },
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
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
                        color: GBColor.textOrange,
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
                        color: GBColor.textOrange,
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
              const SizedBox(height: 120),

              //Already have an account? Sign In
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: TextSpan(
              //     text: GBText.alreadyhaveAnAccount,
              //     style: const TextStyle(
              //       fontSize: 14,
              //       fontFamily: 'Poppins',
              //       fontWeight: FontWeight.w500,
              //       color: GBColor.gray,
              //     ),
              //     children: [
              //       TextSpan(
              //         text: GBText.signIn,
              //         style: const TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w500,
              //           color: GBColor.textOrange,
              //         ),
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () {
              //             Navigator.pushNamed(context, '/login');
              //             logger.i('Navigate to sign-In Screen');
              //           },
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
