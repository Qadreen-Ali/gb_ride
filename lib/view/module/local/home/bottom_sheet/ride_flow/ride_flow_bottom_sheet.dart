import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../utils/constants/color_string.dart';
import '../../../../../../utils/constants/image_string.dart';
import '../../../../../../utils/constants/primary_button.dart';
import '../../../../../../utils/constants/text_string.dart';
import '../../../controller/ride_controller.dart';
import '../../../../../../models/ride_model.dart';
import 'widgets/bottom_sheet_title.dart';
import 'widgets/common_item_widget.dart';

class RideFlowBottomSheet extends StatefulWidget {
  const RideFlowBottomSheet({super.key});

  @override
  State<RideFlowBottomSheet> createState() => _RideFlowBottomSheetState();
}

class _RideFlowBottomSheetState extends State<RideFlowBottomSheet> {
  final PanelController _panelController = PanelController();
  final RideController _rideController = Get.find<RideController>();

  void _closeSheet() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _closeSheet,
      child: GestureDetector(
        onTap: () {},
        child: SlidingUpPanel(
          controller: _panelController,
          minHeight: h * 0.45,
          maxHeight: h * 0.82,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(GBSizes.cardRadiusLg),
          ),
          color: Colors.white,
          panelSnapping: true,
          backdropEnabled: false,
          body: const SizedBox.expand(),

          panelBuilder: (sc) {
            return Obx(() {
              final ride = _rideController.currentRide.value;
              final status = ride?.status ?? RideStatus.accepted;
              final config = _configForStatus(status);

              return SafeArea(
                top: false,
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GBSizes.lg,
                    vertical: GBSizes.sm,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: GBSizes.dividerHeight * 2,
                          decoration: BoxDecoration(
                            color: GBColor.black,
                            borderRadius: BorderRadius.circular(
                              GBSizes.borderRadiusLg,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: GBSizes.spaceBtwItems),

                      // Title
                      BottomSheetTopTitle(
                        tiltetext: config.title,
                        image: Image.asset(
                          config.titleIcon,
                          width: GBSizes.iconLg,
                        ),
                      ),

                      const SizedBox(height: GBSizes.xs),

                      // Common UI (ride info)
                      const CommonItemWidget(),

                      const SizedBox(height: GBSizes.xs),

                      // Primary Button
                      PrimaryButton(
                        title: config.primaryButtonText,
                        backgroundColor: GBColor.primary,
                        textColor: GBColor.secondary,
                        onPressed: config.primaryAction,
                      ),

                      // Optional secondary button
                      if (config.secondaryButtonText != null) ...[
                        const SizedBox(height: GBSizes.xs),
                        PrimaryButton(
                          title: config.secondaryButtonText!,
                          backgroundColor: GBColor.primary,
                          textColor: GBColor.secondary,
                          onPressed: config.secondaryAction ?? () {},
                        ),
                      ],
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  _RideStepConfig _configForStatus(RideStatus status) {
    switch (status) {
      case RideStatus.accepted:
      case RideStatus.onWay:
        return _RideStepConfig(
          title: GBText.driverArriveIn2Min,
          titleIcon: GBImagePath.car,
          primaryButtonText: GBText.cancelRequest,
          primaryAction: () {
            _rideController.cancelRide();
            _closeSheet();
          },
        );

      case RideStatus.waiting:
        return _RideStepConfig(
          title: GBText.driverArrived,
          titleIcon: GBImagePath.car,
          primaryButtonText: GBText.cancelRequest,
          primaryAction: () {
            _rideController.cancelRide();
            _closeSheet();
          },
        );

      case RideStatus.ongoing:
        return _RideStepConfig(
          title: GBText.startJourney,
          titleIcon: GBImagePath.car,
          primaryButtonText: GBText.accepeted,
          primaryAction: () {},
        );

      case RideStatus.completed:
        return _RideStepConfig(
          title: GBText.yourDestination,
          titleIcon: GBImagePath.car,
          primaryButtonText: GBText.endRide,
          primaryAction: _closeSheet,
        );

      default:
        return _RideStepConfig(
          title: 'Ride',
          titleIcon: GBImagePath.car,
          primaryButtonText: 'Close',
          primaryAction: _closeSheet,
        );
    }
  }
}

class _RideStepConfig {
  final String title;
  final String titleIcon;

  final String primaryButtonText;
  final VoidCallback primaryAction;

  final String? secondaryButtonText;
  final VoidCallback? secondaryAction;

  _RideStepConfig({
    required this.title,
    required this.titleIcon,
    required this.primaryButtonText,
    required this.primaryAction,
    this.secondaryButtonText,
    this.secondaryAction,
  });
}
