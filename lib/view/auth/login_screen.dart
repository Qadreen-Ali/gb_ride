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
import 'package:country_code_picker/country_code_picker.dart';
import 'package:gb_ride/view/home/home.dart';
// import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final bool _isPasswordVisible = false;
  // State fields
  // final TextEditingController _phoneController = TextEditingController();
  // String _selectedCountryCode = '+92';

  // @override
  // void dispose() {
  //   _phoneController.dispose(); // important to avoid memory leaks
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.primary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 180),

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
                const SizedBox(height: 160),
                //Input Fields
                TTextField(
                  // controller: _phoneController,
                  titleText: GBText.phoneNumber,
                  hintText: '0000000000', // show 10-digit placeholder
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    // allow only digits, max 10 digits
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  prefixIcon: Icon(SolarLinearIcons.phone),
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '+92',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //Primary Button
                PrimaryButton(
                  title: GBText.signIn,
                  onPressed: () {
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
    );
  }
}
