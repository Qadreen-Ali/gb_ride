// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/app_snackbar_string.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/controller/driver_controller.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:get/get.dart';

class OfferFareScreen extends StatefulWidget {
  final RideModel rideModel;

  const OfferFareScreen({super.key, required this.rideModel});

  @override
  State<OfferFareScreen> createState() => _OfferFareScreenState();
}

class _OfferFareScreenState extends State<OfferFareScreen> {
  late TextEditingController _fareController;
  final DriverController _driverController = Get.find<DriverController>();

  @override
  void initState() {
    super.initState();
    _fareController = TextEditingController(
      text: widget.rideModel.fare.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _fareController.dispose();
    super.dispose();
  }

  void _sendOffer() async {
    if (_fareController.text.isEmpty) {
      Get.snackbar(
        AppSnackBarString.fareRequiredTitle,
        AppSnackBarString.fareRequiredMessage,
      );
      return;
    }

    final fare = double.tryParse(_fareController.text);
    if (fare == null || fare <= 0) {
      Get.snackbar(
        AppSnackBarString.invalidFareTitle,
        AppSnackBarString.invalidFareMessage,
      );
      return;
    }

    // Send the offer to Supabase via controller
    await _driverController.sendOffer(
      rideId: widget.rideModel.rideId,
      offeredFare: fare,
      etaMinutes: widget.rideModel.etaMinutes,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 1,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Customize your fare',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: GBColor.black,
                ),
              ),

              const SizedBox(height: 12),

              /// FARE INPUT UI (UNCHANGED)
              _buildFareInput(),

              const SizedBox(height: 16),

              /// LOCATION CARD (NOW FROM RideModel)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: GBColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: GBColor.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: GBColor.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.rideModel.pickupLocation,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: GBColor.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.rideModel.destinationLocation,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: GBColor.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.rideModel.formattedDistance,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: GBColor.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => PrimaryButton(
                    title: _driverController.isSendingOffer.value
                        ? 'Sending...'
                        : 'Send Offer',
                    onPressed: _driverController.isSendingOffer.value
                        ? () {}
                        : _sendOffer,
                    backgroundColor: GBColor.primary,
                    textColor: GBColor.secondary,
                    fontsize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// ---- helper ----
  Widget _buildFareInput() {
    final hasValue = _fareController.text.isNotEmpty;
    final displayText = hasValue ? _fareController.text : '0';

    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: GBColor.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: GBColor.borderColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          TextFormField(
            controller: _fareController,
            keyboardType: TextInputType.number,
            showCursor: false,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.transparent,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: (_) => setState(() {}),
          ),
          IgnorePointer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PKR ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: hasValue ? GBColor.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
