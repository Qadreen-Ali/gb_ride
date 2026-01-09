import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/module/local/home/widgets/fare_bottom_sheet.dart';
import 'package:gb_ride/view/module/local/home/widgets/find_driver_bottom_sheet.dart';
import 'package:gb_ride/view/module/local/home/widgets/location_input_field.dart';
import 'package:gb_ride/view/module/local/home/widgets/vehicle_option.dart';
import 'package:latlong2/latlong.dart';

class HomeBottomSheet extends StatelessWidget {
  // final ScrollController scrollController;

  final TextEditingController pickupController;
  final TextEditingController destinationController;

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
  });

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

              /// Pickup
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LocationInputField(
                  controller: pickupController,
                  hintText: 'From',
                  // themeColor: GBColor.secondary,
                  iconColor: GBColor.black,
                  iconData: Icons.radio_button_checked,
                  onMapIconPressed: onStartPickupSelection,
                  onTap: onPickupTap,
                ),
              ),
              const SizedBox(height: 12),

              /// Destination
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LocationInputField(
                  controller: destinationController,
                  hintText: 'To',
                  iconData: Icons.location_on,
                  iconColor: GBColor.primary,
                  onTap: onDestinationTap,
                  onMapIconPressed: onStartDestinationSelection,
                ),
              ),

              const SizedBox(height: 16),

              /// Vehicles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  height: 90, // 👈 controls height
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      VehicleOptionCard(
                        type: 'car',
                        label: 'Car',
                        iconPath: 'assets/icons/car.png',
                        capacity: 4,
                        isSelected: selectedVehicle == 'car',
                        onTap: () => onVehicleSelect('car'),
                      ),
                      const SizedBox(width: 15),
                      VehicleOptionCard(
                        type: 'city',
                        label: 'City',
                        iconPath: 'assets/icons/road-trip.png',
                        capacity: 4,
                        isSelected: selectedVehicle == 'city',
                        onTap: () => onVehicleSelect('city'),
                      ),
                      const SizedBox(width: 15),
                      VehicleOptionCard(
                        type: 'bike',
                        label: 'Bike',
                        iconPath: 'assets/icons/motorbike.png',
                        capacity: 1,
                        isSelected: selectedVehicle == 'bike',
                        onTap: () => onVehicleSelect('bike'),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FareBottomSheet(),
                          ),
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
