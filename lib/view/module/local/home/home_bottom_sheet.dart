import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/local/home/widgets/fare_bottom_sheet.dart';
import 'package:gb_ride/view/module/local/home/widgets/location_input_field.dart';
import 'package:gb_ride/view/module/local/home/widgets/vehicle_option.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/local_model/local_bottomsheet_model.dart';
import '../../../../models/local_model/local_model.dart';
import '../../../../utils/constants/color_string.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/constants/primary_button.dart';
import '../../../../utils/constants/text_string.dart';
import 'bottom_sheet/find_driver_bottom_sheet.dart'; // ✅ your profile model

class HomeBottomSheet extends StatefulWidget {
  final LocalModel user; // ✅ LocalModel (profile)
  final HomeBottomSheetParams params; // ✅ UI params

  const HomeBottomSheet({
    super.key,
    required this.user,
    required this.params,
  });

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  // Future<void> openWhatsAppChat({
  //   required String phoneNumber,
  //   String message = '',
  // }) async {
  //   final Uri uri = Uri.parse(
  //     'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}',
  //   );
  //
  //   try {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } catch (e) {
  //     debugPrint('WhatsApp not installed');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('WhatsApp not installed')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final p = widget.params;
    final u = widget.user; // ✅ available if you want to show name/phone later

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          color: Colors.white,
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
              if (p.distanceKm != null && p.etaMinutes != null)
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
                              '${p.distanceKm!.toStringAsFixed(1)} km',
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
                              '${p.etaMinutes} mins',
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
                  controller: p.pickupController,
                  hintText: 'From',
                  iconColor: GBColor.black,
                  iconData: Icons.radio_button_checked,
                  onMapIconPressed: p.onStartPickupSelection,
                  onTap: p.onPickupTap,
                ),
              ),
              const SizedBox(height: 12),

              /// Destination
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LocationInputField(
                  controller: p.destinationController,
                  hintText: 'To',
                  iconData: Icons.location_on,
                  iconColor: GBColor.primary,
                  onTap: p.onDestinationTap,
                  onMapIconPressed: p.onStartDestinationSelection,
                ),
              ),

              const SizedBox(height: 16),

              /// Vehicles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      VehicleOptionCard(
                        type: 'car',
                        label: 'Car',
                        iconPath: 'assets/icons/car1.png',
                        capacity: 4,
                        isSelected: p.selectedVehicle == 'car',
                        onTap: () => p.onVehicleSelect('car'),
                      ),
                      const SizedBox(width: 15),
                      VehicleOptionCard(
                        type: 'city',
                        label: 'City',
                        iconPath: 'assets/icons/hiace.png',
                        capacity: 4,
                        isSelected: p.selectedVehicle == 'city',
                        onTap: () => p.onVehicleSelect('city'),
                      ),
                      const SizedBox(width: 15),
                      VehicleOptionCard(
                        type: 'bike',
                        label: 'Bike',
                        iconPath: 'assets/icons/bike1.png',
                        capacity: 1,
                        isSelected: p.selectedVehicle == 'bike',
                        onTap: () => p.onVehicleSelect('bike'),
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
                        // openWhatsAppChat(
                        //   phoneNumber: '923554445863',
                        //   message: 'Hello! I need help with my ride.',
                        // );
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
