import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gb_ride/common/form_button.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/module/driver/auth/driver_form.dart';
import 'package:gb_ride/view/module/driver/home/driver_home_screen.dart';
import 'package:gb_ride/view/module/local/auth/local_form.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import '../module/student/auth/student_form.dart';
import 'package:gb_ride/view/auth/controller/form_controller.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _studentKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _localKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _driverKey = GlobalKey<FormState>();

  // ✅ SINGLE controller instance
  final FormController controller = Get.find<FormController>();

  bool _checkingRoute = true;

  @override
  void initState() {
    super.initState();
    _decideRoute();
  }

  /// 🔐 AUTO REDIRECT LOGIC (FROM NEW VERSION)
  Future<void> _decideRoute() async {
    final route = await controller.checkUserRoute();

    if (!mounted) return;

    switch (route) {
      case FormRoute.driverHome:
        Get.offAllNamed('/driverhome');
        break;

      case FormRoute.localHome:
        Get.offAllNamed('/localhome');
        break;

      case FormRoute.formSelection:
        setState(() => _checkingRoute = false);
        break;

      case FormRoute.login:
      Get.offAllNamed('/login');
    }
  }

  /// 📤 SUBMIT HANDLER (UNCHANGED UI FLOW)
  Future<void> _handleSubmit() async {
    switch (controller.selectedRole) {
      case UserRole.student:
        if (_studentKey.currentState?.validate() ?? false) {}
        break;

      case UserRole.local:
        if (!(_localKey.currentState?.validate() ?? false)) return;

        try {
          await controller.submitLocal();
          if (!mounted) return;
          Get.offAllNamed('/localhome');
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
        break;

      case UserRole.driver:
        if (!(_driverKey.currentState?.validate() ?? false)) return;

        try {
          await controller.submitDriver();
          if (!mounted) return;
          Get.offAll(() => const DriverHomeScreen());
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
        break;
    }
  }

  Widget _buildForm() {
    switch (controller.selectedRole) {
      case UserRole.student:
        return StudentForm(formKey: _studentKey);

      case UserRole.local:
        return LocalForm(
          formKey: _localKey,
          fullNameController: controller.localFullName,
          phoneController: controller.phoneNumber, // NEW phone controller
          cnicController: controller.localCnic,
          genderController: controller.localGender,
          addressController: controller.localAddress,
        );

      case UserRole.driver:
        return DriverForm(
          formKey: _driverKey,
          fullNameController: controller.driverFullName,
          phoneController: controller.phoneNumber, // NEW phone controller
          cnicController: controller.driverCnic,
          genderController: controller.driverGender,
          ageController: controller.driverAge,
          addressController: controller.driverAddress,
          licenseController: controller.driverLicense,
          vehicleTypeController: controller.driverVehicleType,
          vehicleNumberController: controller.driverVehicleNumber,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⏳ WAIT UNTIL AUTO-CHECK IS DONE
    if (_checkingRoute) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: GBColor.secondary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Text(
                GBText.createYourAccount,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: GBColor.black,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                GBText.continueAs,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: GBColor.textFieldText,
                ),
              ),

              const SizedBox(height: 16),

              // 🎯 ROLE BUTTONS (UI UNCHANGED)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormButton(
                    title: 'Student',
                    isSelected:
                        controller.selectedRole == UserRole.student,
                    prefixIcon: Image.asset(
                      'assets/icons/ph_student.png',
                      width: 28,
                      height: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        controller.selectedRole = UserRole.student;
                      });
                    },
                  ),
                  FormButton(
                    title: 'Local',
                    isSelected:
                        controller.selectedRole == UserRole.local,
                    width: 90,
                    prefixIcon: Image.asset(
                      'assets/icons/local.png',
                      width: 28,
                      height: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        controller.selectedRole = UserRole.local;
                      });
                    },
                  ),
                  FormButton(
                    title: 'Driver',
                    isSelected:
                        controller.selectedRole == UserRole.driver,
                    prefixIcon: Image.asset(
                      'assets/icons/driver.png',
                      width: 28,
                      height: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        controller.selectedRole = UserRole.driver;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildForm(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SecondaryButton(
                title: controller.isSubmitting
                    ? 'Please wait…'
                    : GBText.continueBtn,
                onPressed:
                    controller.isSubmitting ? null : _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
