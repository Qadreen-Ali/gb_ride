import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'home_bottom_sheet.dart';
import 'widgets/map_markers.dart';
import 'widgets/top_bar.dart';
import 'app_drawer/app_drawer.dart';

// Mapbox Token (add your own if expired)
final String mapboxToken = dotenv.env['MAPBOX_TOKEN']!;

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key});

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final MapController _mapController = MapController();

  LatLng _currentLocation = const LatLng(35.911383, 74.341500);
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;

  double? _distanceKm;
  int? _etaMinutes;

  String _selectedVehicle = 'car';
  bool _isLoading = true;
  bool _showBottomSheet = true;

  Timer? _gestureTimer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _pickupLocation = _currentLocation;
        _pickupController.text = 'Current Location';
        _isLoading = false;
      });

      _mapController.move(_currentLocation, 15);
    } catch (e) {
      debugPrint("Error getting location: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onMapGesture() {
    if (!_showBottomSheet) return;
    setState(() => _showBottomSheet = false);

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
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 15,
              minZoom: 3,
              maxZoom: 19,
              onPositionChanged: (_, hasGesture) {
                if (hasGesture) _onMapGesture();
              },
            ),
            children: [
              /// MAPBOX DARK THEME TILE LAYER
              TileLayer(
                urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxToken",
                userAgentPackageName: 'com.example.gb_ride',
                tileSize: 256,
                maxZoom: 19,
              ),

              /// 📍 MARKERS
              MapMarkers(
                currentLocation: _currentLocation,
                pickupLocation: _pickupLocation,
                destinationLocation: _destinationLocation,
              ),
            ],
          ),

          TopBar(
            onMenuPressed: () =>
                _scaffoldKey.currentState?.openDrawer(),
            onNotificationPressed: () =>
                Navigator.pushNamed(context, '/notification'),
          ),

          /// BOTTOM SHEET
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: _showBottomSheet ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 250),
              child: HomeBottomSheet(
                pickupController: _pickupController,
                destinationController: _destinationController,
                distanceKm: _distanceKm,
                etaMinutes: _etaMinutes,
                selectedVehicle: _selectedVehicle,
                onVehicleSelect: (v) {
                  setState(() => _selectedVehicle = v);
                },
                onPickupTap: () {},
                onDestinationTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _gestureTimer?.cancel();
    super.dispose();
  }
}