// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/ride_flow_screen.dart';

class OfferFareScreen extends StatefulWidget {
  final String? pickupLocation;
  final String? destinationLocation;
  final double? distanceKm;
  final int? etaMinutes;

  const OfferFareScreen({
    super.key,
    this.pickupLocation,
    this.destinationLocation,
    this.distanceKm,
    this.etaMinutes,
  });

  @override
  State<OfferFareScreen> createState() => _OfferFareScreenState();
}

class _OfferFareScreenState extends State<OfferFareScreen> {
  late TextEditingController _fareController;

  @override
  void initState() {
    super.initState();
    _fareController = TextEditingController();
  }

  void _moveCursorToEnd() {
    _fareController.selection = TextSelection.fromPosition(
      TextPosition(offset: _fareController.text.length),
    );
  }

  @override
  void dispose() {
    _fareController.dispose();
    super.dispose();
  }

  void _sendOffer() {
    if (_fareController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a fare amount')),
      );
      return;
    }

    final fare = int.tryParse(_fareController.text);
    if (fare == null || fare <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid fare amount')),
      );
      return;
    }

    // Close OfferFareScreen
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
              // Drag handle
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
              // Title
              const Text(
                'Customize your fare',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: GBColor.black,
                ),
              ),
              const SizedBox(height: 12),
              // Fare Input Field - Large Display
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final hasValue = _fareController.text.isNotEmpty;
                      final displayText = hasValue ? _fareController.text : '0';

                      final painter = TextPainter(
                        text: TextSpan(
                          text: 'PKR $displayText',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout();

                      final leftOffset =
                          (constraints.maxWidth - painter.width) / 2;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          /// Background
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: GBColor.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: GBColor.borderColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ),

                          /// Real input (logic only)
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '', // we handle hint visually
                            ),
                            onChanged: (_) => setState(() {}),
                          ),

                          /// Visual centered PKR + value / hint
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
                                    color: hasValue
                                        ? GBColor.black
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Destination Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: GBColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
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
                          // Pickup
                          Text(
                            widget.pickupLocation ?? 'Pickup',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: GBColor.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8),

                          const SizedBox(height: 6),
                          // Destination
                          Text(
                            widget.destinationLocation ?? 'Destination',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: GBColor.gray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${widget.distanceKm?.toStringAsFixed(1) ?? '0'} km',
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
              // Send Offer Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: 'Send Offer',
                  onPressed: () {
                    _sendOffer();
                    Navigator.pop(context, {
                      // 'fare': fare,
                      'distance': widget.distanceKm,
                      'eta': widget.etaMinutes,
                    });

                    // Open RideFlowScreen
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const RideFlowScreen(),
                    );
                  },
                  backgroundColor: GBColor.primary,
                  textColor: GBColor.secondary,
                  fontsize: 18,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
