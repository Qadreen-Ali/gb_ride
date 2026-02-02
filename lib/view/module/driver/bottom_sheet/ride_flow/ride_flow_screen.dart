import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/on_way_widget.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/waiting_widget.dart';
import 'package:gb_ride/view/module/driver/home/common/common_item_widget.dart';
import 'package:gb_ride/models/ride_ui_model.dart';
import 'package:gb_ride/models/ride_status.dart';

class RideFlowScreen extends StatefulWidget {
  final RideUiModel rideModel;

  const RideFlowScreen({super.key, required this.rideModel});

  @override
  State<RideFlowScreen> createState() => _RideFlowScreenState();
}

class _RideFlowScreenState extends State<RideFlowScreen>
    with SingleTickerProviderStateMixin {
  /// ✅ Local UI workflow state using global RideStatus enum
  late RideStatus _currentStatus;

  //animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize UI workflow state based on ride data
    // Start from driverArriving (driver has accepted and is heading to pickup)
    _currentStatus = RideStatus.driverArriving;

    // Setup pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _onArrivedPressed() {
    setState(() {
      _currentStatus = RideStatus.waiting;
    });
  }

  /// Transition to next workflow state
  void _nextStatus() {
    setState(() {
      switch (_currentStatus) {
        case RideStatus.driverArriving:
          _currentStatus = RideStatus.driverArrived;
          break;
        case RideStatus.driverArrived:
          _currentStatus = RideStatus.waiting;
          break;
        case RideStatus.waiting:
          _currentStatus = RideStatus.inProgress;
          break;
        default:
          break;
      }
    });
  }

  /// Get button title based on current status
  String _getButtonTitle() {
    switch (_currentStatus) {
      case RideStatus.driverArriving:
        return 'I Arrived';
      case RideStatus.driverArrived:
        return 'Waiting';
      case RideStatus.waiting:
        return 'Start Ride';
      case RideStatus.inProgress:
        return 'End Ride';
      default:
        return 'Next';
    }
  }

  /// Get widget to display for current status
  Widget _getStatusWidget() {
    switch (_currentStatus) {
      case RideStatus.driverArriving:
        return const OnTheWayWidget();
      case RideStatus.driverArrived:
      case RideStatus.waiting:
        return WaitingWidget(
          waitingTime: const Duration(minutes: 3, seconds: 0),
          estimatedFare: widget.rideModel.currentFare.toInt(),
        );
      default:
        return const SizedBox.shrink();
    }
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

              /// 🔹 WORKFLOW STATE HEADER (DYNAMIC)
              _getStatusWidget(),

              const SizedBox(height: 20),

              /// DRIVER PROFILE CARD
              DriverCommonItemWidget(rideModel: widget.rideModel),

              const SizedBox(height: 10),

              ///  STATE-SPECIFIC BUTTON
              SizedBox(
                width: double.infinity,
                child: ScaleTransition(
                  scale: _currentStatus == RideStatus.waiting
                      ? _pulseAnimation
                      : const AlwaysStoppedAnimation(1),
                  child: PrimaryButton(
                    title: _getButtonTitle(),
                    onPressed: () {
                      if (_currentStatus == RideStatus.driverArriving ||
                          _currentStatus == RideStatus.driverArrived ||
                          _currentStatus == RideStatus.waiting) {
                        _nextStatus();
                      }
                    },
                    backgroundColor: GBColor.primary,
                    textColor: GBColor.secondary,
                    fontsize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
