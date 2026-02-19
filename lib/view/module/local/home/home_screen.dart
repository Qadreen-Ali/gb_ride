import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gb_ride/view/module/local/home/app_drawer/app_drawer.dart';
import 'package:latlong2/latlong.dart';

import 'home_bottom_sheet.dart';
import 'widgets/top_bar.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key});

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  // Mapbox token (your token)
  static const String _mapboxAccessToken =
      'pk.eyJ1IjoiZ2JyaWRlIiwiYSI6ImNtbHFoc2FuNzAwd3AzY3NiamttM2U0Ym8ifQ.ubwGJwlG8fv7q1y2R4stbg';

  // Pick any default center (Gilgit example)
  static const LatLng _initialCenter = LatLng(35.911383, 74.341500);

  final MapController _mapController = MapController();

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  String _selectedVehicle = 'car';

  bool _showBottomSheet = true;
  Timer? _gestureTimer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isKeyboardOpen => MediaQuery.of(context).viewInsets.bottom > 0;

  void _onMapGesture() {
    if (_isKeyboardOpen) return;

    if (_showBottomSheet) {
      setState(() => _showBottomSheet = false);
    }

    _gestureTimer?.cancel();
    _gestureTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showBottomSheet = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ✅ Mapbox map background
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 14,
              onPositionChanged: (pos, hasGesture) {
                if (hasGesture) _onMapGesture();
              },
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                // Mapbox raster tiles (style: streets)
                urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=$_mapboxAccessToken',
                userAgentPackageName: 'com.example.gb_ride',
              ),
            ],
          ),

          // ✅ Top bar (same)
          TopBar(
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            onNotificationPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),

          // ✅ Bottom sheet (same)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: _showBottomSheet ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: HomeBottomSheet(
                pickupController: _pickupController,
                destinationController: _destinationController,
                distanceKm: null,
                etaMinutes: null,
                onPickupTap: () {},
                onDestinationTap: () {},
                selectedVehicle: _selectedVehicle,
                onVehicleSelect: (v) => setState(() => _selectedVehicle = v),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gestureTimer?.cancel();
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}
