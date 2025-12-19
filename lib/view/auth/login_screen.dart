import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/social_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/utils/logger.dart';
import '../../common/textfield.dart';
import 'package:flutter/services.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class PakPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Get only digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    // Remove leading zero
    if (digitsOnly.startsWith('0')) {
      digitsOnly = digitsOnly.substring(1);
    }
    // Limit to 10 digits
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }
    // Format: 3456 789012 (space after 4th digit)
    String formatted = '';
    if (digitsOnly.length <= 3) {
      formatted = digitsOnly;
    } else {
      formatted = '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3)}';
    }
    // kept cursor at the end - this prevents the stuck issue
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: GBColor.primary,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: keyboardIsOpen ? 60 : 180),

                  // const SizedBox(height: 10),
                  Text(
                    GBText.gbRide,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      color: GBColor.black,
                    ),
                  ),
                  SizedBox(height: keyboardIsOpen ? 60 : 160),
                  //Input Fields
                  TTextField(
                    // controller: _phoneController,
                    titleText: GBText.phoneNumber,
                    hintText: '000 0000000',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      PakPhoneFormatter(),
                      // LengthLimitingTextInputFormatter(10),
                      // FilteringTextInputFormatter.digitsOnly,
                    ],

                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Vital: prevents the Row from taking full width
                      children: [
                        const SizedBox(width: 12),
                        Icon(SolarLinearIcons.phone),
                        const SizedBox(width: 8),
                        const Text(
                          '+92',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // Ensure color is visible
                          ),
                        ),
                      ],
                    ),
                    // Remove the separate 'prefix' property as it is now inside prefixIcon
                  ),

                  const SizedBox(height: 20),
                  //Primary Button
                  PrimaryButton(
                    title: GBText.signIn,
                    onPressed: () {
                      Navigator.pushNamed(context, '/otp');
                      // Sign In logic here
                      logger.i('Sign In button pressed');
                    },
                  ),
                  const SizedBox(height: 30),
                  //Divider with text "Or continue with"
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1.5, color: GBColor.secondary),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          GBText.orContinuewith,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: GBColor.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1.5, color: GBColor.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  //Social Media Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialSignInButton(
                        title: '',
                        leadingIcon: Image.asset(
                          'assets/icons/google.png',
                          width: 32,
                          height: 32,
                        ),
                        onPressed: () {
                          // Handle Google sign-in
                          logger.i('Google Sign-In Pressed');
                        },
                      ),
                      const SizedBox(width: 25),
                      SocialSignInButton(
                        title: '',
                        leadingIcon: Image.asset(
                          'assets/icons/apple.png',
                          width: 32,
                          height: 32,
                        ),
                        // backgroundColor: GBColor.containerColor,
                        onPressed: () {
                          // Handle Apple sign-in
                          logger.i('Apple Sign-In Pressed');
                        },
                      ),
                      const SizedBox(width: 25),
                      SocialSignInButton(
                        title: '',
                        leadingIcon: Image.asset(
                          'assets/icons/facebook.png',
                          width: 32,
                          height: 32,
                        ),
                        // backgroundColor: GBColor.containerColor,
                        onPressed: () {
                          // Handle Apple sign-in
                          logger.i('Apple Sign-In Pressed');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
                            color: GBColor.secondary,
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
                            color: GBColor.secondary,
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
