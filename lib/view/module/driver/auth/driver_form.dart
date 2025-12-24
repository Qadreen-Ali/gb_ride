import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class DriverForm extends StatefulWidget {
  const DriverForm({super.key});

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // // Name
        TTextField(titleText: '', hintText: 'Full Name (as per CNIC)'),
        // CNIC / B-Form
        TTextField(
          titleText: '',
          hintText: 'CNIC / B-Form',
          keyboardType: TextInputType.number,
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),

        // Gender
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
        // Number
        TTextField(
          titleText: '',
          hintText: 'Age',
          keyboardType: TextInputType.number,
        ),
        // Address
        TTextField(titleText: '', hintText: 'Address'),
        // Institution (Optional)
        TTextField(titleText: '', hintText: 'Number'),

        // Vehichle Type
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

        //Vehicle Number
        TTextField(
          titleText: '',
          hintText: 'Number',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
