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

import '../../utils/constants/app_sizes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //added controller for phone
  final TextEditingController _phoneController = TextEditingController();
  final AuthController _authController = AuthController.instance;

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

  /// ✅ small helper: scales your fixed sizes on different screens (keeps same UI)
  double _scale(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final s = w / 390.0;
    return s.clamp(0.85, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    final s = _scale(context);

    return Scaffold(
      backgroundColor: GBColor.primary,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: GBSizes.lg * s, // was 24
              vertical: (GBSizes.sm + GBSizes.xs) * s, // ~12-14
            ),
            child: Column(
              children: [
                Spacer(flex: (2 * s).round()),

                Text(
                  GBText.gbRide,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50 * s, // was 50
                    fontWeight: FontWeight.w600,
                    color: GBColor.black,
                  ),
                ),

                Spacer(flex: (3 * s).round()),

                //Input Fields
                TTextField(
                  controller: _phoneController,
                  titleText: '',
                  hintText: '000 0000000',
                  keyboardType: TextInputType.number,
                  inputFormatters: [PakPhoneFormatter()],
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: (GBSizes.md - GBSizes.xs) * s), // was 12
                      Icon(SolarLinearIcons.phone, size: GBSizes.iconMd * s),
                      SizedBox(width: GBSizes.sm * s), // was 8
                      Text(
                        '+92',
                        style: TextStyle(
                          fontSize: GBSizes.fontSizeSm * s, // was 14
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: (GBSizes.md + GBSizes.xs) * s), // was 20
                //Primary Button (keep your button widget, just spacing responsive)
                PrimaryButton(title: GBText.signIn, onPressed: _onSignIn),

                SizedBox(height: (GBSizes.lg + GBSizes.sm) * s), // was 30
                //Divider with text "Or continue with"
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: (GBSizes.dividerHeight + 0.5) * s, // ~1.5
                        color: GBColor.secondary,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (GBSizes.sm + GBSizes.xs) * s,
                      ), // was 12
                      child: Text(
                        GBText.orContinuewith,
                        style: TextStyle(
                          fontSize: GBSizes.fontSizeESm * s, // was 12
                          fontWeight: FontWeight.w500,
                          color: GBColor.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: (GBSizes.dividerHeight + 0.5) * s,
                        color: GBColor.secondary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: (GBSizes.lg + GBSizes.sm) * s), // was 30
                //Social Media Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        'assets/icons/google.png',
                        width: 32 * s,
                        height: 32 * s,
                      ),
                      onPressed: () {
                        logger.i('Google Sign-In Pressed');
                      },
                    ),
                    SizedBox(width: (GBSizes.lg + GBSizes.xs) * s), // was 25
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        'assets/icons/apple.png',
                        width: 32 * s,
                        height: 32 * s,
                      ),
                      onPressed: () {
                        logger.i('Apple Sign-In Pressed');
                      },
                    ),
                    SizedBox(width: (GBSizes.lg + GBSizes.xs) * s), // was 25
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        'assets/icons/facebook.png',
                        width: 32 * s,
                        height: 32 * s,
                      ),
                      onPressed: () {
                        logger.i('Facebook Sign-In Pressed');
                      },
                    ),
                  ],
                ),

                SizedBox(
                  height: (GBSizes.spaceBtwSections + GBSizes.md) * s,
                ), // was 50
                //Terms of Service Text
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: GBSizes.fontSizeESm * s, // was 12
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: GBColor.gray,
                    ),
                    children: [
                      const TextSpan(text: "By Continuing you agree to our "),
                      TextSpan(
                        text: GBText.termsofServices,
                        style: const TextStyle(color: GBColor.secondary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            logger.i('Terms of Services Tapped');
                          },
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: GBText.privacyPolicy,
                        style: const TextStyle(color: GBColor.secondary),
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
      ),
    );
  }
}
