import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/social_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/utils/formatters/pak_phone_formatter.dart';
import 'package:gb_ride/utils/logger.dart';
import 'package:gb_ride/view/auth/controller/auth_controller.dart';
import '../../common/text_field.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:gb_ride/view/home/home.dart';

// import 'package:country_code_picker/country_code_picker.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    final input = _phoneController.text.trim();

    if (!_authController.isValidPakNumber(input)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid Pakistan phone number')),
      );
      return;
    }

    final phone = _authController.toFirebasePhone(input);

    _authController.requestOtp(
      phone: phone,
      onSuccess: () {
        Navigator.pushNamed(context, '/otp', arguments: phone);
      },
      onError: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }

  //added controller for phone
  final TextEditingController _phoneController = TextEditingController();
  // final AuthController _authController = AuthController();
  final AuthController _authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    // final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: GBColor.primary,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 14.0,
            ),
            child: Column(
              children: [
                const Spacer(flex: 2),

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
                const Spacer(flex: 3),
                //Input Fields
                TTextField(
                  controller: _phoneController,
                  titleText: GBText.phoneNumber,
                  hintText: '000 0000000',
                  keyboardType: TextInputType.number,
                  inputFormatters: [PakPhoneFormatter()],

                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 12),
                      Icon(SolarLinearIcons.phone),
                      const SizedBox(width: 8),
                      const Text(
                        '+92',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                //Primary Button
                PrimaryButton(title: GBText.signIn, onPressed: _onSignIn),
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
                // const Spacer(),
                const SizedBox(height: 50),
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
                // const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
