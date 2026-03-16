import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/on_way_widget.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/ongoing_widget.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/waiting_widget.dart';
import 'package:gb_ride/view/module/driver/home/common/common_item_widget.dart';
import 'package:gb_ride/view/module/driver/home/common/widgets/driver_card.dart';
import 'package:gb_ride/view/module/driver/controller/driver_controller.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:get/get.dart';

class RideFlowScreen extends StatefulWidget {
  final RideModel rideModel;

  const RideFlowScreen({super.key, required this.rideModel});

  @override
  State<RideFlowScreen> createState() => _RideFlowScreenState();
}

class _RideFlowScreenState extends State<RideFlowScreen>
    with SingleTickerProviderStateMixin {
  final DriverController _driverController = Get.find<DriverController>();

  late RideStatus _status;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _status = widget.rideModel.status;

    // Only transition to onWay if ride was just accepted
    if (_status == RideStatus.accepted) {
      _status = RideStatus.onWay;
      _driverController.updateRideStatus(RideStatus.onWay);
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(RideFlowScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rideModel.status != oldWidget.rideModel.status) {
      setState(() {
        _status = widget.rideModel.status;
      });
    }
  }

  void _onArrivedPressed() {
    _driverController.updateRideStatus(RideStatus.waiting);
    setState(() {
      _status = RideStatus.waiting;
    });
  }

  void _onStartTrip() {
    _driverController.updateRideStatus(RideStatus.ongoing);
    setState(() {
      _status = RideStatus.ongoing;
    });
  }

  void _onEndTrip() {
    _driverController.completeRide();
    // activeRide is set to null by completeRide() → Obx swaps back
  }

  void _onCancelRide() {
    _driverController.updateRideStatus(RideStatus.cancelled);
    // activeRide is set to null by stream → Obx swaps back
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

              /// ON THE WAY
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

              /// WAITING (Driver arrived at pickup)
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

              /// ONGOING (Trip in progress)
              if (_status == RideStatus.ongoing) ...[
                DriverCard(
                  rideModel: widget.rideModel,
                  showContacts: false,
                  showFare: true,
                ),

                const SizedBox(height: 12),
                OngoingTripWidget(
                  timeLeft: Duration(minutes: widget.rideModel.etaMinutes),
                  distanceLeftKm: widget.rideModel.distanceKm,
                  onEndTrip: _onEndTrip,
                  onSOS: () {},
                ),
              ],

              const SizedBox(height: 10),

              /// ARRIVED / WAITING / START TRIP BUTTONS
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
                  onPressed: _onCancelRide,
                  backgroundColor: GBColor.black.withValues(alpha: 0.3),
                  textColor: GBColor.secondary,
                  fontsize: 16,
                ),

                if (_status == RideStatus.waiting)
                  PrimaryButton(
                    title: 'START TRIP',
                    onPressed: _onStartTrip,
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
