import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class DriverForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  // final TextEditingController phoneController;
  final TextEditingController cnicController;
  final TextEditingController genderController;
  final TextEditingController ageController;
  final TextEditingController addressController;
  final TextEditingController licenseController;
  final TextEditingController vehicleTypeController;
  final TextEditingController vehicleNumberController;
  const DriverForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    // required this.phoneController,
    required this.cnicController,
    required this.genderController,
    required this.ageController,
    required this.addressController,
    required this.licenseController,
    required this.vehicleTypeController,
    required this.vehicleNumberController,
  });

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // // Name
          TTextField(
            titleText: '',
            hintText: 'Full Name (as per CNIC)',
            controller: widget.fullNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          // CNIC / B-Form
          TTextField(
            titleText: '',
            hintText: 'CNIC / B-Form',
            keyboardType: TextInputType.number,
            controller: widget.cnicController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'CNIC is required';
              }
              return null;
            },
          ),

          // Gender
          TTextField(
            titleText: '',
            hintText: 'Gender',
            controller: widget.genderController,
            readOnly: true,
            onTap: () {
              showSelectionBottomSheet(
                context: context,
                title: 'Select Gender',
                options: ['Male', 'Female', 'Other'],
                onSelected: (value) {
                  widget.genderController.text = value;
                },
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Gender is required';
              }
              return null;
            },
          ),
          // Number
          TTextField(
            titleText: '',
            hintText: 'Age',
            controller: widget.ageController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Age is required';
              }
              return null;
            },
          ),
          // Address
          TTextField(
            titleText: '',
            hintText: 'Address',
            controller: widget.addressController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),

          //license Number
          TTextField(
            titleText: '',
            hintText: 'Driving License Number',
            controller: widget.licenseController,
            keyboardType: TextInputType.number,
          ),

          // Vehichle Type
          TTextField(
            titleText: '',
            hintText: 'Vehicle Type',
            controller: widget.vehicleTypeController,
            readOnly: true,
            onTap: () {
              showSelectionBottomSheet(
                context: context,
                title: 'Select Vehicle',
                options: ['Bike', 'Car'],
                onSelected: (value) {
                  widget.vehicleTypeController.text = value;
                },
              );
            },
          ),

          //Vehicle Number
          TTextField(
            titleText: '',
            hintText: 'Vehicle Number',
            controller: widget.vehicleNumberController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
