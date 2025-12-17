import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
// import 'package:gb_ride/utils/constants/socialsignin_button.dart';
import 'package:gb_ride/utils/constants/social_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/utils/logger.dart';
import '../../common/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 70),

                Text(
                  GBText.createYourAccount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  GBText.connectingGilgitBaltistan,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: GBColor.gray,
                  ),
                ),
                const SizedBox(height: 10),
                //Input Fields
                TTextField(
                  //controller: _emailController,
                  titleText: GBText.emailAddress,
                  hintText: GBText.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                TTextField(
                  //controller: _phoneController,
                  titleText: GBText.phone,
                  hintText: GBText.phone,
                  prefixIcon: Icon(Icons.phone_android_outlined),
                ),
                TTextField(
                  //controller: _passwordController,
                  titleText: GBText.password,
                  hintText: GBText.password,
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: GestureDetector(
                    //Toggle eye icon
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  obscureText: !_isPasswordVisible, //Hide Password characters
                ),
                const SizedBox(height: 30),
                //Primary Button
                PrimaryButton(
                  title: GBText.signUp,
                  onPressed: () {
                    // Sign up logic here
                    logger.i('Sign Up button pressed');
                  },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        GBImagePath.google,
                        width: 32,
                        height: 32,
                      ),
                      onPressed: () {
                        // Handle Google sign-in
                        logger.i('Google Sign-In Pressed');
                      },
                    ),
                    const SizedBox(width: 25),
                    //apple button
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        GBImagePath.apple,
                        width: 32,
                        height: 32,
                      ),
                      // backgroundColor: GBColor.containerColor,
                      onPressed: () {
                        // Handle Apple sign-in
                        logger.i('Apple Sign-In Pressed');
                      },
                    ),
                    //facebook button
                    const SizedBox(width: 25),
                    SocialSignInButton(
                      title: '',
                      leadingIcon: Image.asset(
                        GBImagePath.facebook,
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
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: GBText.alreadyhaveAnAccount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: GBColor.gray,
                    ),
                    children: [
                      TextSpan(
                        text: GBText.signIn,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GBColor.textOrange,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/login');
                            logger.i('Navigate to sign-In Screen');
                          },
                      ),
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
