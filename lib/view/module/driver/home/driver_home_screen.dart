import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gb_ride/view/module/driver/home/widgets/top_bar.dart';
import 'package:gb_ride/view/module/driver/home/app_drawer/app_drawer.dart';
import 'package:gb_ride/view/module/driver/home/driver_bottom_sheet.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/offer_fare_screen.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/ride_flow_screen.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MapController? _mapController;

  bool _isLoadingLocation = true;
  LatLng _currentLocation = const LatLng(35.911383, 74.341500);
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  //routing variables
  List<List<LatLng>> _routes = [];
  // double? _distanceKm;
  // int? _etaMinutes;
  bool _showBottomSheet = true;
  Timer? _mapGestureTimer;

  // Live location
  LatLng? _liveLocation;
  StreamSubscription<Position>? _liveLocationStream;

  bool get _isKeyboardOpen {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
      _startLiveLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _pickupLocation = _currentLocation;
            _isLoadingLocation = false;
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );

        if (mounted) {
          setState(() {
            _currentLocation = LatLng(position.latitude, position.longitude);
            _pickupLocation = _currentLocation;
            _isLoadingLocation = false;
          });

          _mapController?.move(_currentLocation, 15.0);
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        setState(() {
          _pickupLocation = _currentLocation;
          _isLoadingLocation = false;
        });
      }
    }
  }

  //live location functions
  void _startLiveLocation() {
    _liveLocationStream?.cancel();

    _liveLocationStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
          ),
        ).listen((position) {
          setState(() {
            _liveLocation = LatLng(position.latitude, position.longitude);
          });
        });
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      if (_pickupLocation == null) {
        _pickupLocation = latlng;
      } else if (_destinationLocation == null) {
        _destinationLocation = latlng;
      } else {
        _pickupLocation = latlng;
        _destinationLocation = null;
      }
    });
  }

  void _onMapGesture() {
    // If keyboard is open, DO NOTHING
    if (_isKeyboardOpen) return;
    if (_showBottomSheet) {
      setState(() => _showBottomSheet = false);
    }

    _mapGestureTimer?.cancel();
    _mapGestureTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _showBottomSheet = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      body: Stack(
        children: [
          _isLoadingLocation
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation,
                    initialZoom: 15.0,
                    onTap: _handleMapTap,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        _onMapGesture();
                      }
                    },
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tiles.locationiq.com/v3/streets/r/{z}/{x}/{y}.png?key=pk.25e1a7ca81d6256515a0311e26fb2ec3',
                      userAgentPackageName: 'com.example.gb_ride',
                    ),
                    if (_routes.isNotEmpty)
                      PolylineLayer(
                        polylines: _routes.asMap().entries.map((entry) {
                          final index = entry.key;
                          final points = entry.value;

                          return Polyline(
                            points: points,
                            strokeWidth: index == 0 ? 6 : 4,
                            color: index == 0
                                ? Colors.blue
                                : Colors.blue.withValues(alpha: 0.4),
                            strokeCap: StrokeCap.round,
                            strokeJoin: StrokeJoin.round,
                          );
                        }).toList(),
                      ),
                  ],
                ),
          TopBar(
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            onNotificationPressed: () {
              // Navigator.pushNamed(context, '/notification');
            },
          ),

          // Bottom sheet
          AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: _showBottomSheet ? 0 : -500,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: DriverBottomSheet(
              onOfferTap: () {
                setState(() {
                  _showBottomSheet = false;
                });
              },
              onOfferClose: () {
                setState(() {
                  _showBottomSheet = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _liveLocationStream?.cancel();
    _mapController?.dispose();
    _mapGestureTimer?.cancel();
    super.dispose();
  }
}
