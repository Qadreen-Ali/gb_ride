import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class DriverForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const DriverForm({super.key, required this.formKey});

  @override
  State<DriverForm> createState() => _DriverFormState();

  /// Get form data for driver registration
  static Map<String, dynamic>? getFormData(BuildContext context) {
    final state = context.findAncestorStateOfType<_DriverFormState>();
    if (state == null) {
      return null;
    }

    return {
      'fullName': state._nameController.text,
      'cnic': state._cnicController.text,
      'gender': state._genderController.text,
      'age': int.tryParse(state._ageController.text),
      'address': state._addressController.text,
      'vehicleType': state._vehicleController.text,
      'vehicleNumber': state._vehicleNumberController.text,
      'licenseNumber': state._licenseController.text,
    };
  }
}

class _DriverFormState extends State<DriverForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TTextField(
            titleText: '',
            hintText: 'Full Name (as per CNIC)',
            controller: _nameController,
          ),
          TTextField(
            titleText: '',
            hintText: 'CNIC / B-Form',
            controller: _cnicController,
            keyboardType: TextInputType.number,
          ),
          TTextField(
            titleText: '',
            hintText: 'Gender',
            controller: _genderController,
            readOnly: true,
            onTap: () {
              showSelectionBottomSheet(
                context: context,
                title: 'Select Gender',
                options: ['Male', 'Female', 'Other'],
                onSelected: (value) {
                  _genderController.text = value;
                },
              );
            },
          ),
          TTextField(
            titleText: '',
            hintText: 'Age',
            controller: _ageController,
            keyboardType: TextInputType.number,
          ),
          TTextField(
            titleText: '',
            hintText: 'Address',
            controller: _addressController,
          ),
          TTextField(
            titleText: '',
            hintText: 'Vehicle Type',
            controller: _vehicleController,
            readOnly: true,
            onTap: () {
              showSelectionBottomSheet(
                context: context,
                title: 'Select Vehicle',
                options: ['Bike', 'Car'],
                onSelected: (value) {
                  _vehicleController.text = value;
                },
              );
            },
          ),
          TTextField(
            titleText: '',
            hintText: 'Vehicle Number/Registration',
            controller: _vehicleNumberController,
            keyboardType: TextInputType.text,
          ),
          TTextField(
            titleText: '',
            hintText: 'License Number',
            controller: _licenseController,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
