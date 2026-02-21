import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/app_snackbar_string.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:logger/logger.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import '../../../../../utils/constants/custom_app_bar.dart';
import '../../../../../utils/constants/image_string.dart';

class DriverRatingScreen extends StatefulWidget {
  final String driverName;
  final String driverImage;

  const DriverRatingScreen({
    super.key,
    required this.driverName,
    required this.driverImage,
  });

  @override
  State<DriverRatingScreen> createState() => _DriverRatingScreenState();
}

class _DriverRatingScreenState extends State<DriverRatingScreen> {
  int _rating = 0;
  final List<String> _selectedTags = [];
  int? _selectedTip;
  final TextEditingController _commentController = TextEditingController();
  final Logger _logger = Logger();

  final List<Map<String, dynamic>> _tagOptions = [
    {'icon': SolarLinearIcons.userCheck, 'label': 'Polite Driver'},
    {'icon': Icons.car_crash_outlined, 'label': 'Clean car'},
    {'icon': SolarLinearIcons.musicNote, 'label': 'Great music'},
    {'icon': SolarLinearIcons.chatRound, 'label': 'clear Conversation'},
    {'icon': Icons.add_road_sharp, 'label': 'Smooth Ride'},
  ];

  final List<int> _tipAmounts = [20, 30, 40];

  @override
  void initState() {
    super.initState();
    _selectedTip = _tipAmounts.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: GBColor.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none, color: GBColor.secondary),
          ),
        ),
        title: 'Rating',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Driver Profile
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(widget.driverImage),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Driver Name
            Text(
              widget.driverName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 4),

            // Tap to rate text
            const Text(
              'Tap to rate your Driver',
              style: TextStyle(
                fontSize: 16,
                color: GBColor.black,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      size: 36,
                      color: index < _rating
                          ? GBColor.primary
                          : GBColor.containerTextColor,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // What went well section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What went well?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: GBColor.black,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tag buttons
            Wrap(
              spacing: 7,
              runSpacing: 8,
              children: _tagOptions.map((tag) {
                final String label = tag['label'];
                final bool isSelected = _selectedTags.contains(label);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(label);
                      } else {
                        _selectedTags.add(label);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? GBColor.selectedContainerColor
                          : GBColor.containerColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? GBColor.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tag['icon'], size: 18, color: GBColor.black),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: GBColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            // Add a tip section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add a tip for ${widget.driverName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: GBColor.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tip buttons
            Row(
              children: [
                ..._tipAmounts.map((amount) {
                  final isSelected = _selectedTip == amount;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTip = isSelected ? null : amount;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? GBColor.selectedContainerColor
                                : GBColor.containerColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? GBColor.primary
                                  : GBColor.borderColor,
                            ),
                          ),
                          child: Text(
                            amount.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? GBColor.black : GBColor.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Show custom tip input dialog
                      _showCustomTipDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: GBColor.containerColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: GBColor.borderColor),
                      ),
                      child: const Text(
                        'Custom',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: GBColor.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Leave a comment section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Leave a comment (optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: GBColor.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Comment text field
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add a comment here',
                hintStyle: TextStyle(
                  color: GBColor.containerTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: GBColor.containerColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit button
            PrimaryButton(
              title: "Submit Rating",
              onPressed: () {},
              backgroundColor: GBColor.primary,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomTipDialog() {
    final TextEditingController customTipController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GBColor.secondary,
        title: const Text(
          'Enter Custom Tip',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: customTipController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter amount',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: GBColor.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(customTipController.text);
              if (amount != null && amount > 0) {
                setState(() {
                  _selectedTip = amount;
                });
              }
              Navigator.pop(context);
            },
            child: Text(
              'Add',
              style: TextStyle(
                color: GBColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitRating() {
    // Handle rating submission
    _logger.i('Rating: $_rating');
    _logger.i('Tags: $_selectedTags');
    _logger.i('Tip: $_selectedTip');
    _logger.i('Comment: ${_commentController.text}');

    // Show success message
    Get.snackbar(
      AppSnackBarString.feedbackTitle,
      AppSnackBarString.feedbackMessage,
    );

    // Navigate back
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
