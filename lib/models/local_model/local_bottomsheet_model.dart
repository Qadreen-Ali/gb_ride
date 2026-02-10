import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeBottomSheetParams {
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
  final void Function(LatLng position, String displayName) onDestinationSelected;

  const HomeBottomSheetParams({
    required this.pickupController,
    required this.destinationController,
    required this.onStartPickupSelection,
    required this.onStartDestinationSelection,
    required this.onExpandSheet,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.onVehicleSelect,
    required this.selectedVehicle,
    required this.onPickupTap,
    required this.onDestinationTap,
    required this.mapController,
    required this.onPickupSelected,
    required this.onDestinationSelected,
    this.distanceKm,
    this.etaMinutes,
  });
}
