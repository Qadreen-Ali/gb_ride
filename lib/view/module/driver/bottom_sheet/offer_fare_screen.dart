// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/ride_flow_screen.dart';
import 'package:gb_ride/models/ride_ui_model.dart';
import 'package:gb_ride/services/supabase_service.dart';

class OfferFareScreen extends StatefulWidget {
  final RideUiModel rideModel;
  final SupabaseService? supabaseService;

  const OfferFareScreen({
    super.key,
    required this.rideModel,
    this.supabaseService,
  });

  @override
  State<OfferFareScreen> createState() => _OfferFareScreenState();
}

class _OfferFareScreenState extends State<OfferFareScreen> {
  late TextEditingController _fareController;
  late SupabaseService _supabaseService;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fareController = TextEditingController(
      text: widget.rideModel.currentFare.toStringAsFixed(0),
    );
    _supabaseService = widget.supabaseService ?? SupabaseService();
  }

  @override
  void dispose() {
    _fareController.dispose();
    super.dispose();
  }

  void _sendOffer() async {
    if (_fareController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a fare amount')),
      );
      return;
    }

    final fare = double.tryParse(_fareController.text);
    if (fare == null || fare <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid fare amount')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final driverId = _supabaseService.getCurrentUserId();
      if (driverId == null) {
        throw Exception('Driver not authenticated');
      }

      await _supabaseService.acceptRideAsDriver(
        widget.rideModel.rideId,
        driverId,
        acceptedFare: fare,
      );

      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RideFlowScreen(rideModel: widget.rideModel),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
                child: PrimaryButton(
                  title: _isSubmitting ? 'Sending...' : 'Send Offer',
                  onPressed: _isSubmitting ? null : _sendOffer,
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
