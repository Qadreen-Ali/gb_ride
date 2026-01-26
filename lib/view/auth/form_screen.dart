import 'package:flutter/material.dart';
import 'package:gb_ride/common/form_button.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/utils/logger.dart';
import 'package:gb_ride/view/module/driver/auth/driver_form.dart';
import 'package:gb_ride/view/module/local/auth/local_form.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import '../module/student/auth/student_form.dart';

enum UserRole { student, local, driver }

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  UserRole _selectedRole = UserRole.student;

  final GlobalKey<FormState> _studentKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _localKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _driverKey = GlobalKey<FormState>();

  Widget _buildForm() {
    switch (_selectedRole) {
      case UserRole.student:
        return StudentForm(formKey: _studentKey);
      case UserRole.local:
        return LocalForm(formKey: _localKey);
      case UserRole.driver:
        return DriverForm(formKey: _driverKey);
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
                    isSelected: _selectedRole == UserRole.student,
                    prefixIcon: Image.asset(
                      'assets/icons/ph_student.png',
                      width: 28,
                      height: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRole = UserRole.student;
                      });
                    },
                  ),
                  FormButton(
                    title: 'Local',
                    isSelected: _selectedRole == UserRole.local,
                    width: 90,
                    prefixIcon: Image.asset(
                      'assets/icons/local.png',
                      width: 28,
                      height: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRole = UserRole.local;
                      });
                    },
                  ),
                  FormButton(
                    title: 'Driver',
                    isSelected: _selectedRole == UserRole.driver,
                    prefixIcon: Image.asset(
                      'assets/icons/driver.png',
                      width: 28,
                      height: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRole = UserRole.driver;
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
                onPressed: () {
                  bool isValid = false;

                  switch (_selectedRole) {
                    case UserRole.student:
                      isValid = _studentKey.currentState?.validate() ?? false;
                      if (isValid) {
                        // Navigator.pushNamed(context, '/');
                      }
                      break;

                    case UserRole.local:
                      isValid = _localKey.currentState?.validate() ?? false;
                      if (isValid) {
                        Navigator.pushNamed(context, '/localhome');
                      }
                      break;

                    case UserRole.driver:
                      isValid = _driverKey.currentState?.validate() ?? false;
                      if (isValid) {
                        Navigator.pushNamed(context, '/driverhome');
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
}
