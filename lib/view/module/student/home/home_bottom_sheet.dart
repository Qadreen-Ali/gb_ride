import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/module/student/home/widgets/fare_bottom_sheet.dart';
import 'package:gb_ride/view/module/student/home/widgets/find_driver_bottom_sheet.dart';
import 'package:gb_ride/view/module/student/home/widgets/location_input_field.dart';
import 'package:gb_ride/view/module/student/home/widgets/vehicle_option.dart';
import 'package:latlong2/latlong.dart';

class HomeBottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  final TextEditingController pickupController;
  final TextEditingController destinationController;

  final VoidCallback onStartPickupSelection;
  final VoidCallback onStartDestinationSelection;
  final VoidCallback onExpandSheet;

  final LatLng? pickupLocation;
  final LatLng? destinationLocation;

  final ValueChanged<String> onVehicleSelect;
  final String selectedVehicle;

  final MapController? mapController;
  final void Function(LatLng position, String displayName) onPickupSelected;
  final void Function(LatLng position, String displayName) onDestinationSelected;

  const HomeBottomSheet({
    super.key,
    required this.scrollController,
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
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: Colors.white,
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: ListView(
              controller: scrollController, // ✅ MUST
              padding: const EdgeInsets.only(top: 10, bottom: 0), // ✅ no extra bottom
              physics: const ClampingScrollPhysics(),
              children: [
                /// Drag Handle
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Pickup
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LocationInputField(
                    controller: pickupController,
                    hintText: 'From',
                    themeColor: GBColor.secondary,
                    borderColor: GBColor.borderColor,
                    iconData: Icons.radio_button_checked,
                    iconColor: Colors.black,
                    onMapIconPressed: onStartPickupSelection,
                    onExpandSheet: onExpandSheet,
                    onLocationSelected: (position, displayName) {
                      onPickupSelected(position, displayName);
                      mapController?.move(position, 15);
                    },
                  ),
                ),
                const SizedBox(height: 12),

                /// Destination
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LocationInputField(
                    controller: destinationController,
                    hintText: 'To',
                    themeColor: GBColor.secondary,
                    borderColor: GBColor.borderColor,
                    iconData: Icons.location_on,
                    iconColor: GBColor.primary,
                    onMapIconPressed: onStartDestinationSelection,
                    onExpandSheet: onExpandSheet,
                    onLocationSelected: (position, displayName) {
                      onDestinationSelected(position, displayName);
                      mapController?.move(position, 15);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// Vehicles
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VehicleOptionCard(
                        type: "car",
                        label: "car",
                        image: AssetImage(GBImagePath.car),
                        isSelected: selectedVehicle == 'car',
                        onTap: () => onVehicleSelect('car'),
                      ),
                      const SizedBox(width: 10),
                      VehicleOptionCard(
                        type: GBText.cityTocity,
                        label: GBText.cityTocity,
                        image: AssetImage(GBImagePath.schoolbus),
                        capacity: 4,
                        isSelected: selectedVehicle == GBImagePath.schoolbus,
                        onTap: () => onVehicleSelect(GBImagePath.schoolbus),
                      ),
                      const SizedBox(width: 10),
                      VehicleOptionCard(
                        type: GBText.bike,
                        label: GBText.bike,
                        image: AssetImage(GBImagePath.motorcycle),
                        capacity: 4,
                        isSelected: selectedVehicle == GBText.bike,
                        onTap: () => onVehicleSelect(GBText.bike),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Fare Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

                const SizedBox(height: 14),

                /// Find Driver Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Image.asset(GBImagePath.chat, width: 44),
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
                              builder: (_) => const FindDriverBottomSheet(),
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
                              color: Colors.orange.withOpacity(0.3),
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
      ),
    );
  }
}
