import 'package:flutter/material.dart';
import 'package:gb_ride/common/form_button.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/module/driver/auth/driver_form.dart';
import 'package:gb_ride/view/module/driver/home/driver_home_screen.dart';
import 'package:gb_ride/view/module/local/auth/local_form.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import '../module/student/auth/student_form.dart';
import 'package:gb_ride/view/auth/controller/form_controller.dart';

// enum UserRole { student, local, driver }

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _studentKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _localKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _driverKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = FormController();
  }

  late final FormController controller;

  Widget _buildForm() {
    switch (controller.selectedRole) {
      case UserRole.student:
        return StudentForm(formKey: _studentKey);

      case UserRole.local:
        return LocalForm(
          formKey: _localKey,
          fullNameController: controller.localFullName,
          cnicController: controller.localCnic,
          genderController: controller.localGender,
          addressController: controller.localAddress,
        );

      case UserRole.driver:
        return DriverForm(
          formKey: _driverKey,
          fullNameController: controller.driverFullName,
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
    return Scaffold(
      backgroundColor: GBColor.secondary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // title
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

              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormButton(
                    title: 'Student',
                    isSelected: controller.selectedRole == UserRole.student,
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
                    isSelected: controller.selectedRole == UserRole.local,
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
                    isSelected: controller.selectedRole == UserRole.driver,
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

              //FORM AREA
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildForm(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              //Continue button pinned at bottom
              SecondaryButton(
                title: GBText.continueBtn,
                onPressed: () async {
                  bool isValid = false;

                  switch (controller.selectedRole) {
                    case UserRole.student:
                      isValid = _studentKey.currentState?.validate() ?? false;
                      if (isValid) {
                        // Navigator.pushNamed(context, '/');
                      }
                      break;

                    case UserRole.local:
                      if (!(_localKey.currentState?.validate() ?? false)) {
                        return;
                      }

                      try {
                        await controller.submitLocal();
                        if (!mounted) return;
                        Navigator.pushNamed(context, '/localhome');
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                      break;

                    case UserRole.driver:
                      if (!(_driverKey.currentState?.validate() ?? false))
                        return;

                      try {
                        await controller.submitDriver();

                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const DriverHomeScreen(),
                          ),
                          (_) => false,
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
