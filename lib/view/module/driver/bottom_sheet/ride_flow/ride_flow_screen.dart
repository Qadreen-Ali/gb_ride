import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/on_way_widget.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/ongoing_widget.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/waiting_widget.dart';
import 'package:gb_ride/view/module/driver/home/common/common_item_widget.dart';
import 'package:gb_ride/view/module/driver/home/common/widgets/driver_card.dart';
import 'package:gb_ride/models/ride_model.dart';

class RideFlowScreen extends StatefulWidget {
  final RideModel rideModel;

  const RideFlowScreen({super.key, required this.rideModel});

  @override
  State<RideFlowScreen> createState() => _RideFlowScreenState();
}

class _RideFlowScreenState extends State<RideFlowScreen>
    with SingleTickerProviderStateMixin {
  /// ✅ Use RideStatus from RideModel (not from enum folder)
  late RideStatus _status;
  //animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  void _onArrivedPressed() {
    setState(() {
      _status = RideStatus.waiting;
    });
  }

  @override
  void initState() {
    super.initState();
    _status = RideStatus.onWay; // ✅ Initialize here once

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

              /// 🔹 ON THE WAY / WAITING HEADER (DYNAMIC)
              if (_status == RideStatus.onWay) ...[
                const OnTheWayWidget(),
                const SizedBox(height: 12),

                DriverCard(
                  rideModel: widget.rideModel,
                  showContacts: true,
                  showFare: false,
                ),

                const SizedBox(height: 12),
                DriverCommonItemWidget(rideModel: widget.rideModel),
              ],

              // =====================
              // WAITING
              // =====================
              if (_status == RideStatus.waiting) ...[
                WaitingWidget(
                  waitingTime: const Duration(minutes: 3),
                  estimatedFare: widget.rideModel.fare.toInt(),
                ),
                const SizedBox(height: 12),

                DriverCard(
                  rideModel: widget.rideModel,
                  showContacts: true,
                  showFare: false,
                ),

                const SizedBox(height: 12),
                DriverCommonItemWidget(rideModel: widget.rideModel),
              ],

              // =====================
              // ONGOING
              // =====================
              if (_status == RideStatus.ongoing) ...[
                DriverCard(
                  rideModel: widget.rideModel,
                  showContacts: false,
                  showFare: true,
                ),

                const SizedBox(height: 12),
                OngoingTripWidget(
                  timeLeft: const Duration(minutes: 12),
                  distanceLeftKm: 5.4,
                  onEndTrip: () {
                    setState(() {
                      _status = RideStatus.completed;
                    });
                  },
                  onSOS: () {},
                ),
              ],

              const SizedBox(height: 10),

              ///  ARRIVED / WAITING BUTTON
              if (_status == RideStatus.onWay ||
                  _status == RideStatus.waiting) ...[
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ScaleTransition(
                    scale: _status == RideStatus.waiting
                        ? _pulseAnimation
                        : const AlwaysStoppedAnimation(1),
                    child: PrimaryButton(
                      title: _status == RideStatus.waiting
                          ? 'Waiting'
                          : 'Arrived',
                      onPressed: () {
                        if (_status == RideStatus.onWay) {
                          _onArrivedPressed();
                        }
                      },
                      backgroundColor: GBColor.primary,
                      textColor: GBColor.secondary,
                      fontsize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                PrimaryButton(
                  title: 'Cancel Ride',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: GBColor.black.withValues(alpha: 0.3),
                  textColor: GBColor.secondary,
                  fontsize: 16,
                ),

                // TEMP — remove later
                if (_status == RideStatus.waiting)
                  PrimaryButton(
                    title: 'START TRIP',
                    onPressed: () {
                      setState(() {
                        _status = RideStatus.ongoing;
                      });
                    },
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontsize: 16,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
