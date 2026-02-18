import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gb_ride/models/driver_model/driver_model.dart';
import 'package:gb_ride/models/local_model/local_model.dart';
import 'package:gb_ride/services/driver_services/driver_service.dart';
import 'package:gb_ride/services/local_service/local_service.dart';
import 'package:gb_ride/view/auth/controller/auth_controller.dart';

/// ROLE ENUM (UI NEEDS THIS)
enum UserRole { student, local, driver }

/// ROUTE DECISION ENUM
enum FormRoute { login, formSelection, driverHome, localHome }

class FormController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool isSubmitting = false;
  UserRole selectedRole = UserRole.student;

  // ================= DRIVER CONTROLLERS =================
  final driverFullName = TextEditingController();
  final driverCnic = TextEditingController();
  final driverGender = TextEditingController();
  final driverAge = TextEditingController();
  final driverAddress = TextEditingController();
  final driverLicense = TextEditingController();
  final driverVehicleType = TextEditingController();
  final driverVehicleNumber = TextEditingController();

  // ================= LOCAL CONTROLLERS =================
  final localFullName = TextEditingController();
  final localCnic = TextEditingController();
  final localGender = TextEditingController();
  final phoneNumber = TextEditingController();
  final localAddress = TextEditingController();

  // ================= ROUTE CHECK (NEW LOGIC) =================
  Future<FormRoute> checkUserRoute() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return FormRoute.login;
    }

    final userId = user.id;

    // Check driver first
    final driver = await _supabase
        .from('drivers')
        .select('id')
        .eq('auth_id', userId) // ✅ matches your DB
        .maybeSingle();

    if (driver != null) {
      return FormRoute.driverHome;
    }

    // Check local
    final local = await _supabase
        .from('locals')
        .select('id')
        .eq('auth_id', userId) // ✅ matches your DB
        .maybeSingle();

    if (local != null) {
      return FormRoute.localHome;
    }

    return FormRoute.formSelection;
  }

  // ================= SUBMIT DRIVER =================
  Future<void> submitDriver() async {
    if (isSubmitting) return;

    isSubmitting = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;

      if (user == null || user.phone == null) {
        throw Exception('User not authenticated');
      }

      final driver = DriverModel(
        id: '',
        authId: user.id,
        phoneNumber: phoneNumber.text.trim(),
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

  // ================= SUBMIT LOCAL =================
  Future<void> submitLocal() async {
    if (isSubmitting) return;

    isSubmitting = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;

      if (user == null || user.phone == null) {
        throw Exception('User not authenticated');
      }

      final local = LocalModel(
        id: '',
        authId: user.id,
        phoneNumber: phoneNumber.text.trim(),
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

  @override
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
    super.dispose();
  }
}
