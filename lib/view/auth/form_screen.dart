import 'package:flutter/material.dart';
import 'package:gb_ride/common/form_button.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/module/driver/auth/driver_form.dart';
import 'package:gb_ride/view/module/local/auth/local_form.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../module/student/auth/student_form.dart';

enum UserRole { student, local, driver }

class FormScreen extends StatefulWidget {
  final String phoneNumber; // Phone number from OTP verification

  const FormScreen({super.key, required this.phoneNumber});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;

  final GlobalKey<FormState> _studentKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _localKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _driverKey = GlobalKey<FormState>();

  final _authService = AuthService();

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
                title: _isLoading ? 'Saving...' : GBText.continueBtn,
                onPressed: _isLoading ? () {} : () => _handleContinue(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle continue button logic - saves user data to database
  Future<void> _handleContinue() async {
    bool isValid = false;

    switch (_selectedRole) {
      case UserRole.student:
        isValid = _studentKey.currentState?.validate() ?? false;
        if (isValid) {
          // TODO: Implement student registration
          // Navigator.pushNamed(context, '/');
        }
        break;

      case UserRole.local:
        isValid = _localKey.currentState?.validate() ?? false;
        if (isValid) {
          await _saveLocalUserProfile();
        }
        break;

      case UserRole.driver:
        isValid = _driverKey.currentState?.validate() ?? false;
        if (isValid) {
          await _saveDriverProfile();
        }
        break;
    }
  }

  /// Save local (rider) user profile to database
  Future<void> _saveLocalUserProfile() async {
    try {
      setState(() => _isLoading = true);

      final formData = LocalForm.getFormData(context);
      if (formData == null) {
        _showError('Could not retrieve form data');
        return;
      }

      // Save user profile to database using phone number from OTP
      await _authService.completeUserProfile(
        phoneNumber: widget.phoneNumber,
        fullName: formData['fullName'] ?? '',
        role: 'rider',
        gender: formData['gender'],
        cnic: formData['cnic'],
        address: formData['address'],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile saved successfully')),
      );

      // Navigate to local home
      Navigator.pushNamed(context, '/localhome');
    } catch (e) {
      _showError('Error saving profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Save driver profile to database
  Future<void> _saveDriverProfile() async {
    try {
      setState(() => _isLoading = true);

      final formData = DriverForm.getFormData(context);
      if (formData == null) {
        _showError('Could not retrieve form data');
        return;
      }

      // First save user profile using phone number from OTP
      final userProfile = await _authService.completeUserProfile(
        phoneNumber: widget.phoneNumber,
        fullName: formData['fullName'] ?? '',
        role: 'driver',
        gender: formData['gender'],
        cnic: formData['cnic'],
        age: formData['age'],
        address: formData['address'],
      );

      // Then save driver profile
      await _authService.completeDriverProfile(
        userId: userProfile.id,
        licenseNumber: formData['licenseNumber'] ?? '',
        vehicleType: formData['vehicleType'],
        vehicleNumber: formData['vehicleNumber'],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Driver profile saved successfully')),
      );

      // Navigate to driver home
      Navigator.pushNamed(context, '/driverhome');
    } catch (e) {
      _showError('Error saving driver profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Show error message
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('❌ $message')));
  }
}
