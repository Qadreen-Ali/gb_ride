import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gb_ride/services/gb_poi_service.dart';
import 'package:gb_ride/services/location_routing_service.dart';
import 'package:gb_ride/services/location_search_service.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/local/home/widgets/location_search_screen.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:gb_ride/view/module/local/home/app_drawer/app_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'home_bottom_sheet.dart';
import 'widgets/map_markers.dart';
import 'widgets/map_selection_overlay.dart';
import 'widgets/top_bar.dart';
import 'dart:math';
import 'package:gb_ride/models/gb_poi.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key});

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  MapController? _mapController;

  bool get _isKeyboardOpen {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  //live location functions
  LatLng? _liveLocation;
  StreamSubscription<Position>? _liveLocationStream;
  //route polyline functions
  // List<LatLng> _createCurvedRoute(List<LatLng> points) {
  //   if (points.length < 4) return points;

  //   final List<LatLng> curved = [];

  //   for (int i = 0; i < points.length - 1; i++) {
  //     final p0 = i > 0 ? points[i - 1] : points[i];
  //     final p1 = points[i];
  //     final p2 = points[i + 1];
  //     final p3 = i + 2 < points.length ? points[i + 2] : p2;

  //     for (double t = 0; t <= 1; t += 0.03) {
  //       final t2 = t * t;
  //       final t3 = t2 * t;

  //       final lat =
  //           0.5 *
  //           ((2 * p1.latitude) +
  //               (-p0.latitude + p2.latitude) * t +
  //               (2 * p0.latitude -
  //                       5 * p1.latitude +
  //                       4 * p2.latitude -
  //                       p3.latitude) *
  //                   t2 +
  //               (-p0.latitude +
  //                       3 * p1.latitude -
  //                       3 * p2.latitude +
  //                       p3.latitude) *
  //                   t3);

  //       final lng =
  //           0.5 *
  //           ((2 * p1.longitude) +
  //               (-p0.longitude + p2.longitude) * t +
  //               (2 * p0.longitude -
  //                       5 * p1.longitude +
  //                       4 * p2.longitude -
  //                       p3.longitude) *
  //                   t2 +
  //               (-p0.longitude +
  //                       3 * p1.longitude -
  //                       3 * p2.longitude +
  //                       p3.longitude) *
  //                   t3);

  //       curved.add(LatLng(lat, lng));
  //     }
  //   }

  //   return curved;
  // }
  List<LatLng> _smoothChaikin(List<LatLng> points, {int iterations = 3}) {
    if (points.length < 3) return points;

    List<LatLng> result = points;

    for (int k = 0; k < iterations; k++) {
      final List<LatLng> newPoints = [];
      newPoints.add(result.first); // preserve start

      for (int i = 0; i < result.length - 1; i++) {
        final p0 = result[i];
        final p1 = result[i + 1];

        final q = LatLng(
          0.75 * p0.latitude + 0.25 * p1.latitude,
          0.75 * p0.longitude + 0.25 * p1.longitude,
        );

        final r = LatLng(
          0.25 * p0.latitude + 0.75 * p1.latitude,
          0.25 * p0.longitude + 0.75 * p1.longitude,
        );

        newPoints.add(q);
        newPoints.add(r);
      }

      newPoints.add(result.last); // preserve end
      result = newPoints;
    }

    return result;
  }

  //smooth turns function
  List<LatLng> _densify(List<LatLng> points, double stepMeters) {
    final List<LatLng> result = [];
    const earthRadius = 6371000.0;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      result.add(p1);

      final dLat = (p2.latitude - p1.latitude) * pi / 180;
      final dLng = (p2.longitude - p1.longitude) * pi / 180;

      final a =
          sin(dLat / 2) * sin(dLat / 2) +
          cos(p1.latitude * pi / 180) *
              cos(p2.latitude * pi / 180) *
              sin(dLng / 2) *
              sin(dLng / 2);

      final c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final distance = earthRadius * c;

      final steps = (distance / stepMeters).floor();

      for (int s = 1; s < steps; s++) {
        final t = s / steps;
        result.add(
          LatLng(
            p1.latitude + (p2.latitude - p1.latitude) * t,
            p1.longitude + (p2.longitude - p1.longitude) * t,
          ),
        );
      }
    }

    result.add(points.last);
    return result;
  }

  void _fitMapToRoute(List<LatLng> points) {
    if (points.isEmpty || _mapController == null) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      minLat = min(minLat, p.latitude);
      maxLat = max(maxLat, p.latitude);
      minLng = min(minLng, p.longitude);
      maxLng = max(maxLng, p.longitude);
    }

    final bounds = LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));

    _mapController!.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)),
    );
  }

  //routing variables
  List<List<LatLng>> _routes = [];
  double? _distanceKm;
  int? _etaMinutes;

  void _openLocationSearch({required bool isPickup}) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationSearchScreen(
        isPickup: isPickup,
        selectedLocationName: isPickup
            ? _destinationController.text
            : _pickupController.text,
      ),
    );

    if (result == null) return;

    final LatLng latLng = result['latLng'];
    final String name = result['name'];

    setState(() {
      if (isPickup) {
        _pickupLocation = latLng;
        _pickupController.text = name;

        // 🔴 CLEAR OLD ROUTE
        _routes.clear();
        _distanceKm = null;
        _etaMinutes = null;
      } else {
        _destinationLocation = latLng;
        _destinationController.text = name;
      }
    });

    _mapController?.move(latLng, 15);

    // ✅ ADD THIS (CRITICAL)
    if (!isPickup && _pickupLocation != null) {
      await _calculateRoute();
      debugPrint('ROUTE CALCULATED: $_distanceKm km, $_etaMinutes mins');
    }
  }

  LatLng _currentLocation = const LatLng(35.911383, 74.341500);
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  String _selectedVehicle = 'car';
  bool _isLoadingLocation = true;
  bool _isSelectingPickup = false;
  bool _isSelectingDestination = false;
  bool _isLoadingAddress = false;
  bool _showBottomSheet = true;
  Timer? _mapGestureTimer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // 🔥 LOAD LOCAL GB POIs ONCE
    GbPoiService.loadPois();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
      _startLiveLocation(); //for live location
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _pickupLocation = _currentLocation;
            _pickupController.text = 'Gilgit, Pakistan';
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
            _pickupController.text = 'Getting address...';
            _isLoadingLocation = false;
          });

          _mapController?.move(_currentLocation, 15.0);
          await _getAddressFromLatLng(_currentLocation, isPickup: true);
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        setState(() {
          _pickupLocation = _currentLocation;
          _pickupController.text = 'Gilgit, Pakistan';
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

  //poi params
  double _distanceInMeters(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  GbPoi? _findNearestPoi(LatLng position) {
    const radiusMeters = 120; // adjust 80–150

    for (final poi in GbPoiService.cachedPois) {
      final distance = _distanceInMeters(
        position.latitude,
        position.longitude,
        poi.lat,
        poi.lon,
      );

      if (distance <= radiusMeters) {
        return poi;
      }
    }
    return null;
  }

  Future<void> _getAddressFromLatLng(
    LatLng position, {
    required bool isPickup,
  }) async {
    try {
      if (mounted) setState(() => _isLoadingAddress = true);

      // 🔥 1. CHECK LOCAL GB POIs FIRST
      final nearbyPoi = _findNearestPoi(position);

      if (nearbyPoi != null && mounted) {
        setState(() {
          final text = '${nearbyPoi.name}, ${nearbyPoi.city}';
          if (isPickup) {
            _pickupController.text = text;
            _pickupLocation = position;
          } else {
            _destinationController.text = text;
            _destinationLocation = position;
          }
          _isLoadingAddress = false;
        });
        return; // 🔥 STOP (InDrive behavior)
      }

      // 🔁 2. FALLBACK TO LOCATIONIQ
      final address = await LocationSearchService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (mounted) {
        setState(() {
          final text =
              address ??
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';

          if (isPickup) {
            _pickupController.text = text;
            _pickupLocation = position;
          } else {
            _destinationController.text = text;
            _destinationLocation = position;
          }
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  //route calculation functions
  Future<void> _calculateRoute() async {
    if (_pickupLocation == null || _destinationLocation == null) return;

    final result = await LocationRoutingService.getRoutes(
      startLat: _pickupLocation!.latitude,
      startLng: _pickupLocation!.longitude,
      endLat: _destinationLocation!.latitude,
      endLng: _destinationLocation!.longitude,
    );

    if (result == null || result.routes.isEmpty) return;

    final routes = result.routes.map((route) {
      final rawPoints = route.coordinates
          .map((e) => LatLng(e[0], e[1]))
          .toList();

      final dense = _densify(rawPoints, 25);
      final smooth = _smoothChaikin(dense, iterations: 3);

      smooth.first = _pickupLocation!;
      smooth.last = _destinationLocation!;

      return smooth;
    }).toList();

    setState(() {
      _routes = routes;
      _distanceKm = result.routes.first.distanceMeters / 1000;
      _etaMinutes = (result.routes.first.durationSeconds / 60).round();
    });

    _fitMapToRoute(_routes.first);
  }

  void _startPickupSelection() {
    setState(() {
      _isSelectingPickup = true;
      _isSelectingDestination = false;
    });
  }

  void _startDestinationSelection() {
    if (_pickupLocation == null) return;
    setState(() {
      _isSelectingDestination = true;
      _isSelectingPickup = false;
    });
    // _collapseSheet();
  }

  void _handleMapTap(TapPosition tapPosition, LatLng position) {
    if (_isSelectingPickup) {
      setState(() {
        _pickupLocation = position;
        _pickupController.text = 'Loading address...';
        _isSelectingPickup = false;
      });
      _getAddressFromLatLng(position, isPickup: true);
    } else if (_isSelectingDestination) {
      setState(() {
        _destinationLocation = position;
        _destinationController.text = 'Loading address...';
        _isSelectingDestination = false;
      });
      _getAddressFromLatLng(position, isPickup: false);
    }
  }

  void _cancelSelection() {
    setState(() {
      _isSelectingPickup = false;
      _isSelectingDestination = false;
    });
    // _expandSheet();
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
  // void _collapseSheet() {
  //   _sheetController.animateTo(
  //     0.15,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  // void _expandSheet() {
  //   _sheetController.animateTo(
  //     0.7,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),

      resizeToAvoidBottomInset: true,

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
                    MapMarkers(
                      currentLocation: _currentLocation,
                      pickupLocation: _pickupLocation,
                      destinationLocation: _destinationLocation,
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
                            strokeCap: StrokeCap.round, // ✅
                            strokeJoin: StrokeJoin.round,
                          );
                        }).toList(),
                      ),
                  ],
                ),

          if (_isLoadingAddress)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Loading address...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (_isSelectingPickup || _isSelectingDestination)
            MapSelectionOverlay(
              isSelectingPickup: _isSelectingPickup,
              onCancel: _cancelSelection,
            ),

          if (!_isSelectingPickup && !_isSelectingDestination)
            TopBar(
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onNotificationPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
          if (!_isSelectingPickup && !_isSelectingDestination)
            Positioned(
              right: 12,
              bottom: 420, // 👈 ABOVE bottom sheet
              child: FloatingActionButton.small(
                backgroundColor: GBColor.secondary,
                elevation: 4,
                onPressed: () async {
                  if (_liveLocation == null) return;

                  setState(() {
                    _pickupLocation = _liveLocation;
                    _pickupController.text = 'Getting address...';
                  });

                  _mapController?.move(_liveLocation!, 16);

                  await _getAddressFromLatLng(_liveLocation!, isPickup: true);
                },
                child: const Icon(Icons.my_location, color: GBColor.primary),
              ),
            ),
          // Draggable bottom sheet
          if (!_isSelectingPickup && !_isSelectingDestination)
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
                  distanceKm: _distanceKm,
                  etaMinutes: _etaMinutes,

                  // 🔥 STEP 4 (THIS IS WHAT YOU ASKED)
                  onPickupTap: () {
                    _openLocationSearch(isPickup: true);
                  },
                  onDestinationTap: () {
                    _openLocationSearch(isPickup: false);
                  },

                  onStartPickupSelection: _startPickupSelection,
                  onStartDestinationSelection: _startDestinationSelection,
                  onExpandSheet: () {},
                  pickupLocation: _pickupLocation,
                  destinationLocation: _destinationLocation,
                  selectedVehicle: _selectedVehicle,
                  onVehicleSelect: (v) => setState(() => _selectedVehicle = v),
                  mapController: _mapController,
                  onPickupSelected: (pos, name) {
                    setState(() {
                      _pickupLocation = pos;
                      _pickupController.text = name;
                    });
                  },
                  onDestinationSelected: (pos, name) async {
                    setState(() {
                      _destinationLocation = pos;
                      _destinationController.text = name;
                    });

                    await _calculateRoute();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _liveLocationStream?.cancel();
    _pickupController.dispose();
    _destinationController.dispose();
    _mapController?.dispose();
    // _sheetController.dispose();
    super.dispose();
  }
}
