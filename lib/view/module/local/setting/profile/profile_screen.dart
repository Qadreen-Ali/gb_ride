import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';
import 'package:gb_ride/view/module/local/setting/profile/widget/profile_picker.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../utils/constants/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String _localId = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
      if (authId.isEmpty) return;

      final res = await Supabase.instance.client
          .from('locals')
          .select()
          .eq('auth_id', authId)
          .maybeSingle();

      if (res != null && mounted) {
        _localId = res['id']?.toString() ?? '';
        _nameController.text = res['full_name'] ?? '';
        _phoneController.text = res['phone_number'] ?? '';
        _addressController.text = res['address'] ?? '';
        _genderController.text = res['gender'] ?? '';
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _updateProfile() async {
    if (_localId.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      await Supabase.instance.client
          .from('locals')
          .update({
            'full_name': _nameController.text.trim(),
            'address': _addressController.text.trim(),
            'gender': _genderController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _localId);

      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    }
    if (mounted) setState(() => _isSaving = false);
  }

  void _openGenderSheet() {
    FocusScope.of(context).unfocus();
    showSelectionBottomSheet(
      context: context,
      title: 'Select Gender',
      options: ['Male', 'Female', 'Other'],
      onSelected: (value) {
        setState(() {
          _genderController.text = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomKeyboard = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: GBColor.secondary,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        showLeading: false,
        title: 'Profile',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GBColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: GBColor.secondary),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomKeyboard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                const SizedBox(height: 20),
                const Center(child: ProfileImagePicker()),
                const SizedBox(height: 30),

                TTextField(
                  titleText: 'Name',
                  hintText: 'Enter your full name',
                  controller: _nameController,
                ),
                const SizedBox(height: 20),

                TTextField(
                  titleText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                TTextField(
                  titleText: 'Address',
                  hintText: 'Enter your address',
                  controller: _addressController,
                ),
                const SizedBox(height: 20),

                TTextField(
                  titleText: 'Gender',
                  hintText: 'Gender',
                  controller: _genderController,
                  readOnly: true,
                  onTap: _openGenderSheet,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    onPressed: _openGenderSheet,
                  ),
                ),

                const SizedBox(height: 30),
                SecondaryButton(
                  title: _isSaving ? 'Saving...' : 'Update',
                  onPressed: _isSaving ? () {} : _updateProfile,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
