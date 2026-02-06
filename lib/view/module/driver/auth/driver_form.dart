import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class DriverForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const DriverForm({
    super.key,
    required this.formKey,
  });

  @override
  DriverFormState createState() => DriverFormState();
}

class DriverFormState extends State<DriverForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  Map<String, dynamic> getFormData() {
    return {
      'fullName': _nameController.text.trim(),
      'cnic': _cnicController.text.trim(),
      'gender': _genderController.text.trim(),
      'age': int.tryParse(_ageController.text),
      'address': _addressController.text.trim(),
      'vehicleType': _vehicleController.text.trim(),
      'vehicleNumber': _vehicleNumberController.text.trim(),
      'licenseNumber': _licenseController.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TTextField(
            titleText: '',
            hintText: 'Full Name',
            controller: _nameController,
          ),
          TTextField(
            titleText: '',
            hintText: 'CNIC',
            controller: _cnicController,
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
                onSelected: (v) => _genderController.text = v,
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
                onSelected: (v) => _vehicleController.text = v,
              );
            },
          ),
          TTextField(
            titleText: '',
            hintText: 'Vehicle Number',
            controller: _vehicleNumberController,
          ),
          TTextField(
            titleText: '',
            hintText: 'License Number',
            controller: _licenseController,
          ),
        ]
      ),
          );
  }
}
