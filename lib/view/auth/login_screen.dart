import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/app_snackbar_string.dart';
import 'package:get/get.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/social_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
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
  final TextEditingController _emailController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar(
        AppSnackBarString.invalidEmailTitle,
        AppSnackBarString.invalidEmailMessage,
      );
      return;
    }

    await _authController.signInWithEmail(email);
  }

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
              horizontal: GBSizes.lg * s,
              vertical: (GBSizes.sm + GBSizes.xs) * s,
            ),
            child: Column(
              children: [
                Spacer(flex: (2 * s).round()),

                Text(
                  GBText.gbRide,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50 * s,
                    fontWeight: FontWeight.w600,
                    color: GBColor.black,
                  ),
                ),

                Spacer(flex: (3 * s).round()),

                // ✅ EMAIL INPUT (DESIGN UNCHANGED)
                TTextField(
                  controller: _emailController,
                  titleText: '',
                  hintText: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: (GBSizes.md - GBSizes.xs) * s),
                      Icon(SolarLinearIcons.letter, size: GBSizes.iconMd * s),
                      SizedBox(width: GBSizes.sm * s),
                    ],
                  ),
                ),

                SizedBox(height: (GBSizes.md + GBSizes.xs) * s),

                PrimaryButton(title: GBText.signIn, onPressed: _onSignIn),

                SizedBox(height: (GBSizes.lg + GBSizes.sm) * s),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: (GBSizes.dividerHeight + 0.5) * s,
                        color: GBColor.secondary,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (GBSizes.sm + GBSizes.xs) * s,
                      ),
                      child: Text(
                        GBText.orContinuewith,
                        style: TextStyle(
                          fontSize: GBSizes.fontSizeESm * s,
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

                SizedBox(height: (GBSizes.lg + GBSizes.sm) * s),

                // Social buttons (UNCHANGED)
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
                      onPressed: () => logger.i('Google Sign-In Pressed'),
                    ),
                    SizedBox(width: (GBSizes.lg + GBSizes.xs) * s),
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        'assets/icons/apple.png',
                        width: 32 * s,
                        height: 32 * s,
                      ),
                      onPressed: () => logger.i('Apple Sign-In Pressed'),
                    ),
                    SizedBox(width: (GBSizes.lg + GBSizes.xs) * s),
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        'assets/icons/facebook.png',
                        width: 32 * s,
                        height: 32 * s,
                      ),
                      onPressed: () => logger.i('Facebook Sign-In Pressed'),
                    ),
                  ],
                ),

                SizedBox(height: (GBSizes.spaceBtwSections + GBSizes.md) * s),

                // Terms (UNCHANGED)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: GBSizes.fontSizeESm * s,
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
                          ..onTap = () => logger.i('Terms tapped'),
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: GBText.privacyPolicy,
                        style: const TextStyle(color: GBColor.secondary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => logger.i('Privacy tapped'),
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
