import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/on_way_widget.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/widget/waiting_widget.dart';
import 'package:gb_ride/view/module/driver/home/common/common_item_widget.dart';
import 'package:gb_ride/view/module/driver/models/ride_model.dart';
import 'package:gb_ride/view/module/driver/models/ride_status.dart';

class RideFlowScreen extends StatefulWidget {
  final RideModel rideModel;

  const RideFlowScreen({super.key, required this.rideModel});

  @override
  State<RideFlowScreen> createState() => _RideFlowScreenState();
}

class _RideFlowScreenState extends State<RideFlowScreen>
    with SingleTickerProviderStateMixin {
  /// ✅ Ride status MUST live inside State
  RideStatus _status = RideStatus.onTheWay;

  void _onArrivedPressed() {
    setState(() {
      _status = RideStatus.waiting;
    });
  }

  //animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

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
              if (_status == RideStatus.onTheWay) const OnTheWayWidget(),

              if (_status == RideStatus.waiting)
                WaitingWidget(
                  waitingTime: const Duration(minutes: 3, seconds: 0),
                  estimatedFare: widget.rideModel.fare.toInt(),
                ),

              const SizedBox(height: 20),

              /// DRIVER PROFILE CARD
              DriverCommonItemWidget(rideModel: widget.rideModel),

              const SizedBox(height: 10),

              ///  ARRIVED / WAITING BUTTON
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
                      if (_status == RideStatus.onTheWay) {
                        _onArrivedPressed();
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

class ContactWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  const ContactWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: GBColor.borderColor, width: 1),
      ),
      child: ClipOval(child: Icon(icon, color: color)),
    );
  }
}
