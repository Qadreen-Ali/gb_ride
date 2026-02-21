import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/module/local/home/widgets/fare_bottom_sheet.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/find_driver_bottom_sheet.dart';
import 'package:gb_ride/view/module/local/home/widgets/location_input_field.dart';
import 'package:gb_ride/view/module/local/home/widgets/vehicle_option.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBottomSheet extends StatefulWidget {
  // final ScrollController scrollController;

  final TextEditingController pickupController;
  final TextEditingController destinationController;
  final double? distanceKm;
  final int? etaMinutes;

  final VoidCallback onStartPickupSelection;
  final VoidCallback onStartDestinationSelection;
  final VoidCallback onExpandSheet;

  final LatLng? pickupLocation;
  final LatLng? destinationLocation;

  final ValueChanged<String> onVehicleSelect;
  final String selectedVehicle;
  final VoidCallback onPickupTap;
  final VoidCallback onDestinationTap;

  final MapController? mapController;
  final void Function(LatLng position, String displayName) onPickupSelected;
  final void Function(LatLng position, String displayName)
  onDestinationSelected;

  const HomeBottomSheet({
    super.key,
    // required this.scrollController,
    required this.pickupController,
    required this.destinationController,
    required this.onStartPickupSelection,
    required this.onStartDestinationSelection,
    required this.onExpandSheet,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.onVehicleSelect,
    required this.selectedVehicle,
    required this.mapController,
    required this.onPickupSelected,
    required this.onDestinationSelected,
    required this.onPickupTap,
    required this.onDestinationTap,
    this.distanceKm,
    this.etaMinutes,
  });

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  Future<void> openWhatsAppChat({
    required String phoneNumber,
    String message = '',
  }) async {
    final Uri uri = Uri.parse(
      'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}',
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('WhatsApp not installed');
      Get.snackbar('Error', 'WhatsApp is not installed on this device.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          color: Colors.white,
          // padding: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Handle
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
              const SizedBox(height: 10),

              //routing code
              if (widget.distanceKm != null && widget.etaMinutes != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: GBColor.secondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: GBColor.borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.route, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.distanceKm!.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.timer, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.etaMinutes} mins',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              /// Pickup
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LocationInputField(
                  controller: widget.pickupController,
                  hintText: 'From',
                  // themeColor: GBColor.secondary,
                  iconColor: GBColor.black,
                  iconData: Icons.radio_button_checked,
                  onMapIconPressed: widget.onStartPickupSelection,
                  onTap: widget.onPickupTap,
                ),
              ),
              const SizedBox(height: 12),

              /// Destination
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LocationInputField(
                  controller: widget.destinationController,
                  hintText: 'To',
                  iconData: Icons.location_on,
                  iconColor: GBColor.primary,
                  onTap: widget.onDestinationTap,
                  onMapIconPressed: widget.onStartDestinationSelection,
                ),
              ),

              const SizedBox(height: 16),

              /// Vehicles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  height: 70, // 👈 controls height
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      VehicleOptionCard(
                        type: 'car',
                        label: 'Car',
                        iconPath: 'assets/icons/car1.png',
                        capacity: 4,
                        isSelected: widget.selectedVehicle == 'car',
                        onTap: () => widget.onVehicleSelect('car'),
                      ),
                      const SizedBox(width: 15),
                      VehicleOptionCard(
                        type: 'city',
                        label: 'City',
                        iconPath: 'assets/icons/hiace.png',
                        capacity: 4,
                        isSelected: widget.selectedVehicle == 'city',
                        onTap: () => widget.onVehicleSelect('city'),
                      ),
                      const SizedBox(width: 15),
                      VehicleOptionCard(
                        type: 'bike',
                        label: 'Bike',
                        iconPath: 'assets/icons/bike1.png',
                        capacity: 1,
                        isSelected: widget.selectedVehicle == 'bike',
                        onTap: () => widget.onVehicleSelect('bike'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Fare Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: GBColor.secondary,
                    border: Border.all(color: GBColor.borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        GBText.pkr,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const FareBottomSheet(),
                            );
                          },
                          child: const AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: GBText.offerYourFare,
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Find Driver Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        openWhatsAppChat(
                          phoneNumber: '923554445863',
                          message: 'Hello! I need help with my ride.',
                        );
                      },
                      child: Image.asset(GBImagePath.chat, width: 44),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        title: GBText.findADriver,
                        backgroundColor: GBColor.primary,
                        textColor: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => FindDriverBottomSheet(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: GBColor.primary,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(GBImagePath.brush),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
