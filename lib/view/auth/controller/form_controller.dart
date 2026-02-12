import 'package:flutter/material.dart';
import 'package:gb_ride/models/driver_model/driver_model.dart';
import 'package:gb_ride/models/local_model/local_model.dart';
import 'package:gb_ride/services/driver_services/driver_service.dart';
import 'package:gb_ride/services/local_service/local_service.dart';
import 'package:gb_ride/view/auth/controller/auth_controller.dart';

enum UserRole { student, local, driver }

class FormController extends ChangeNotifier {
  bool isSubmitting = false;
  UserRole selectedRole = UserRole.student;
  //  bool get isSubmitting => _isSubmitting;

  // Driver controllers
  final driverFullName = TextEditingController();
  final driverCnic = TextEditingController();
  final driverGender = TextEditingController();
  final driverAge = TextEditingController();
  final driverAddress = TextEditingController();
  final driverLicense = TextEditingController();
  final driverVehicleType = TextEditingController();
  final driverVehicleNumber = TextEditingController();

  // Local controllers
  final localFullName = TextEditingController();
  final localCnic = TextEditingController();
  final localGender = TextEditingController();
  final localAddress = TextEditingController();

  Future<void> submitDriver() async {
    if (isSubmitting) return;


    isSubmitting = true;
    notifyListeners();

    try {
      final phone = AuthController.instance.verifiedPhone;
      if (phone == null) {
        throw Exception('Verified phone not found');
      }

      final driver = DriverModel(
        id: '',
        authId: AuthController.instance.currentUser!.id,
        phoneNumber: phone,
        fullName: driverFullName.text.trim(),
        cnic: driverCnic.text.trim(),
        gender: driverGender.text.trim(),
        age: int.tryParse(driverAge.text) ?? 0,
        address: driverAddress.text.trim(),
        licenseNumber: driverLicense.text.trim(),
        vehicleType: driverVehicleType.text.trim(),
        vehicleNumber: driverVehicleNumber.text.trim(),
      );

      await DriverService().createDriver(driver);
    } finally {
      isSubmitting = false;
       notifyListeners();
    }
  }

  Future<void> submitLocal() async {
    if (isSubmitting) return;

    isSubmitting = true;
     notifyListeners();

    try {
      final phone = AuthController.instance.verifiedPhone;
      if (phone == null) {
        throw Exception('Verified phone not found');
      }

      final local = LocalModel(
        id: '',
        authId: AuthController.instance.currentUser!.id,
        phoneNumber: phone,
        fullName: localFullName.text.trim(),
        cnic: localCnic.text.trim(),
        gender: localGender.text.trim(),
        address: localAddress.text.trim(),
      );

      await LocalService.instance.createLocal(local);
    } finally {
      isSubmitting = false;
       notifyListeners();
    }
  }

  void dispose() {
    driverFullName.dispose();
    driverCnic.dispose();
    driverGender.dispose();
    driverAge.dispose();
    driverAddress.dispose();
    driverLicense.dispose();
    driverVehicleType.dispose();
    driverVehicleNumber.dispose();
    localFullName.dispose();
    localCnic.dispose();
    localGender.dispose();
    localAddress.dispose();
  }
}
