import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'home_bottom_sheet.dart';
import 'bottom_sheet/find_driver_bottom_sheet.dart';
import 'widgets/map_selection_overlay.dart';
import 'widgets/top_bar.dart';
import 'widgets/location_search_screen.dart';
import 'widgets/driver_offer_overlay.dart';
import 'app_drawer/app_drawer.dart';
import '../controller/ride_controller.dart';
import 'bottom_sheet/ride_flow/ride_flow_bottom_sheet.dart';
import 'package:gb_ride/services/map_services/location_search_service.dart';
import 'package:gb_ride/services/map_services/location_routing_service.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key});

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();

  // Mapbox native map controller
  MapboxMap? _mapboxMap;

  // Gilgit-Baltistan center
  final Position _defaultCenter = Position(74.341500, 35.911383);

  double? _currentLat;
  double? _currentLng;
  double? _pickupLat;
  double? _pickupLng;
  double? _destLat;
  double? _destLng;

  double? _distanceKm;
  int? _etaMinutes;

  String _selectedVehicle = 'car';
  bool _isLoading = true;
  bool _showBottomSheet = true;

  // Map selection mode ("Choose on map")
  bool _isSelectingOnMap = false;
  bool _isSelectingPickup = true;

  // Route coordinates for fit bounds (raw [lng, lat] pairs)
  List<List<double>> _rawRouteCoords = [];

  Timer? _gestureTimer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Track whether style sources/layers have been added
  bool _styleReady = false;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<RideController>()) {
      Get.put(RideController());
    }
  }

  // ═══════════════════════════════════════════════════════════
  // MAP CREATED
  // ═══════════════════════════════════════════════════════════

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    // Clean UI
    await mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    // Enable native location puck (blue dot)
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        puckBearingEnabled: true,
      ),
    );

    // Get current location
    _getCurrentLocation();
  }

  /// Called when the map style has fully loaded — safe to add sources/layers
  void _onStyleLoaded(StyleLoadedEventData data) async {
    await _initStyleLayers();
  }

  // ═══════════════════════════════════════════════════════════
  // NATIVE STYLE LAYERS SETUP
  // ═══════════════════════════════════════════════════════════

  Future<void> _initStyleLayers() async {
    if (_mapboxMap == null) return;
    final style = _mapboxMap!.style;

    // ── Route line source + layer ──
    await style.addSource(
      GeoJsonSource(
        id: 'route-source',
        data: jsonEncode({'type': 'FeatureCollection', 'features': []}),
      ),
    );

    // Route casing (darker outline behind the main line)
    await style.addLayer(
      LineLayer(
        id: 'route-casing-layer',
        sourceId: 'route-source',
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: const Color(0xFF1565C0).value,
        lineWidth: 8.0,
        lineOpacity: 0.4,
      ),
    );

    // Route main line
    await style.addLayer(
      LineLayer(
        id: 'route-layer',
        sourceId: 'route-source',
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.blue.value,
        lineWidth: 5.0,
        lineOpacity: 0.85,
      ),
    );

    // ── Markers source + circle layer ──
    await style.addSource(
      GeoJsonSource(
        id: 'markers-source',
        data: jsonEncode({'type': 'FeatureCollection', 'features': []}),
      ),
    );

    await style.addLayer(
      CircleLayer(
        id: 'markers-circle-layer',
        sourceId: 'markers-source',
        circleRadius: 10.0,
        circleStrokeWidth: 3.0,
        circleStrokeColor: Colors.white.value,
      ),
    );

    // Data-driven circle color from feature property
    await style.setStyleLayerProperty(
      'markers-circle-layer',
      'circle-color',
      '["get", "color"]',
    );

    _styleReady = true;
  }

  // ═══════════════════════════════════════════════════════════
  // LOCATION
  // ═══════════════════════════════════════════════════════════

  Future<void> _getCurrentLocation() async {
    try {
      final position = await geo.Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
        _pickupLat = position.latitude;
        _pickupLng = position.longitude;
        _pickupController.text = 'Current Location';
        _isLoading = false;
      });

      _flyTo(position.latitude, position.longitude, 15);
    } catch (e) {
      debugPrint("Error getting location: $e");
      setState(() => _isLoading = false);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CAMERA
  // ═══════════════════════════════════════════════════════════

  Future<void> _flyTo(double lat, double lng, double zoom) async {
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  Future<void> _fitBounds() async {
    if (_pickupLat == null || _destLat == null) return;

    final allPoints = <Position>[
      Position(_pickupLng!, _pickupLat!),
      Position(_destLng!, _destLat!),
      ...(_rawRouteCoords.map((c) => Position(c[0], c[1]))),
    ];

    double minLng = allPoints.first.lng.toDouble();
    double maxLng = allPoints.first.lng.toDouble();
    double minLat = allPoints.first.lat.toDouble();
    double maxLat = allPoints.first.lat.toDouble();

    for (final p in allPoints) {
      if (p.lng < minLng) minLng = p.lng.toDouble();
      if (p.lng > maxLng) maxLng = p.lng.toDouble();
      if (p.lat < minLat) minLat = p.lat.toDouble();
      if (p.lat > maxLat) maxLat = p.lat.toDouble();
    }

    final camera = await _mapboxMap?.cameraForCoordinateBounds(
      CoordinateBounds(
        southwest: Point(coordinates: Position(minLng, minLat)),
        northeast: Point(coordinates: Position(maxLng, maxLat)),
        infiniteBounds: false,
      ),
      MbxEdgeInsets(top: 100, left: 80, bottom: 250, right: 80),
      null,
      null,
      null,
      null,
    );

    if (camera != null) {
      await _mapboxMap?.flyTo(camera, MapAnimationOptions(duration: 600));
    }
  }

  // ═══════════════════════════════════════════════════════════
  // UPDATE MARKERS (GeoJSON Source)
  // ═══════════════════════════════════════════════════════════

  Future<void> _updateMarkers() async {
    if (!_styleReady || _mapboxMap == null) return;

    final features = <Map<String, dynamic>>[];

    // Pickup marker - green
    if (_pickupLat != null && _pickupLng != null) {
      features.add({
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [_pickupLng!, _pickupLat!],
        },
        'properties': {'color': '#4CAF50', 'type': 'pickup'},
      });
    }

    // Destination marker - red
    if (_destLat != null && _destLng != null) {
      features.add({
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [_destLng!, _destLat!],
        },
        'properties': {'color': '#F44336', 'type': 'destination'},
      });
    }

    final geojson = jsonEncode({
      'type': 'FeatureCollection',
      'features': features,
    });

    await _mapboxMap!.style.setStyleSourceProperty(
      'markers-source',
      'data',
      geojson,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // UPDATE ROUTE LINE (GeoJSON Source)
  // ═══════════════════════════════════════════════════════════

  Future<void> _updateRouteLine() async {
    if (!_styleReady || _mapboxMap == null) return;

    String geojson;
    if (_rawRouteCoords.isEmpty) {
      geojson = jsonEncode({'type': 'FeatureCollection', 'features': []});
    } else {
      geojson = jsonEncode({
        'type': 'Feature',
        'geometry': {'type': 'LineString', 'coordinates': _rawRouteCoords},
      });
    }

    await _mapboxMap!.style.setStyleSourceProperty(
      'route-source',
      'data',
      geojson,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // LOCATION SEARCH
  // ═══════════════════════════════════════════════════════════

  Future<void> _openLocationSearch({required bool isPickup}) async {
    final result = await showModalBottomSheet(
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

    if (result == 'map') {
      setState(() {
        _isSelectingOnMap = true;
        _isSelectingPickup = isPickup;
        _showBottomSheet = false;
      });
      return;
    }

    if (result is Map) {
      final double lat = (result['lat'] as num).toDouble();
      final double lng = (result['lng'] as num).toDouble();
      final String name = result['name'];
      _setLocation(isPickup: isPickup, lat: lat, lng: lng, name: name);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // MAP TAP ("Choose on Map")
  // ═══════════════════════════════════════════════════════════

  void _onMapTap(MapContentGestureContext context) async {
    if (!_isSelectingOnMap) return;

    final point = context.point;
    final lat = point.coordinates.lat.toDouble();
    final lng = point.coordinates.lng.toDouble();

    String name = 'Selected Location';
    try {
      final address = await LocationSearchService.getAddressFromCoordinates(
        lat,
        lng,
      );
      if (address != null) {
        name = address.split(',').first;
      }
    } catch (_) {}

    _setLocation(isPickup: _isSelectingPickup, lat: lat, lng: lng, name: name);

    setState(() {
      _isSelectingOnMap = false;
      _showBottomSheet = true;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // SET LOCATION
  // ═══════════════════════════════════════════════════════════

  void _setLocation({
    required bool isPickup,
    required double lat,
    required double lng,
    required String name,
  }) {
    setState(() {
      if (isPickup) {
        _pickupLat = lat;
        _pickupLng = lng;
        _pickupController.text = name;
      } else {
        _destLat = lat;
        _destLng = lng;
        _destinationController.text = name;
      }
    });

    _flyTo(lat, lng, 15);
    _updateMarkers();
    _calculateRouteIfReady();
  }

  // ═══════════════════════════════════════════════════════════
  // ROUTE CALCULATION
  // ═══════════════════════════════════════════════════════════

  Future<void> _calculateRouteIfReady() async {
    if (_pickupLat == null || _destLat == null) return;

    try {
      final result = await LocationRoutingService.getRoutes(
        startLat: _pickupLat!,
        startLng: _pickupLng!,
        endLat: _destLat!,
        endLng: _destLng!,
      );

      if (result != null && result.routes.isNotEmpty) {
        final route = result.routes.first;
        setState(() {
          _distanceKm = route.distanceMeters / 1000;
          _etaMinutes = (route.durationSeconds / 60).ceil();
          // Store raw coords as [lng, lat] for GeoJSON
          _rawRouteCoords = route.coordinates
              .map<List<double>>((c) => [c[1], c[0]])
              .toList();
        });

        await _updateRouteLine();
        await _updateMarkers();
        await _fitBounds();
      }
    } catch (e) {
      debugPrint('Route calculation error: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // MAP GESTURE
  // ═══════════════════════════════════════════════════════════

  void _onMapGesture() {
    if (!_showBottomSheet) return;
    setState(() => _showBottomSheet = false);

    _gestureTimer?.cancel();
    _gestureTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showBottomSheet = true);
    });
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      body: Stack(
        children: [
          // Mapbox Map
          MapWidget(
            key: const ValueKey('localHomeMap'),
            mapOptions: MapOptions(
              pixelRatio: MediaQuery.of(context).devicePixelRatio,
            ),
            styleUri: MapboxStyles.STANDARD,
            cameraOptions: CameraOptions(
              center: Point(coordinates: _defaultCenter),
              zoom: 15,
            ),
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
            onTapListener: _onMapTap,
            onScrollListener: (_) => _onMapGesture(),
          ),

          // Loading overlay
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // Top bar
          TopBar(
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            onNotificationPressed: () =>
                Navigator.pushNamed(context, '/notification'),
          ),

          // Driver offer cards overlay (top of screen)
          DriverOfferOverlay(
            onAccepted: () {
              // Close any open bottom sheet and show ride flow
              Navigator.of(context).popUntil((route) => route.isFirst);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const RideFlowBottomSheet(),
              );
            },
          ),

          // Map selection overlay
          if (_isSelectingOnMap)
            MapSelectionOverlay(
              isSelectingPickup: _isSelectingPickup,
              onCancel: () {
                setState(() {
                  _isSelectingOnMap = false;
                  _showBottomSheet = true;
                });
              },
            ),

          // Bottom sheet — swaps between HomeBottomSheet and FindDriverBottomSheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: _showBottomSheet ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 250),
              child: Obx(() {
                final rideCtrl = Get.find<RideController>();

                if (rideCtrl.isSearching.value) {
                  return FindDriverBottomSheet(
                    onCancelled: () {
                      // Ride cancelled — switch back to home sheet
                    },
                  );
                }

                return HomeBottomSheet(
                  pickupController: _pickupController,
                  destinationController: _destinationController,
                  distanceKm: _distanceKm,
                  etaMinutes: _etaMinutes,
                  selectedVehicle: _selectedVehicle,
                  pickupLat: _pickupLat,
                  pickupLng: _pickupLng,
                  destLat: _destLat,
                  destLng: _destLng,
                  onVehicleSelect: (v) {
                    setState(() => _selectedVehicle = v);
                  },
                  onPickupTap: () => _openLocationSearch(isPickup: true),
                  onDestinationTap: () => _openLocationSearch(isPickup: false),
                );
              }),
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
