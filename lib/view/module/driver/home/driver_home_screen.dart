import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:gb_ride/view/module/driver/home/widgets/top_bar.dart';
import 'package:gb_ride/view/module/driver/home/app_drawer/app_drawer.dart';
import 'package:gb_ride/view/module/driver/home/driver_bottom_sheet.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/ride_flow/ride_flow_screen.dart';
import 'package:gb_ride/view/module/driver/controller/driver_controller.dart';
import 'package:gb_ride/services/map_services/location_routing_service.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MapboxMap? _mapboxMap;

  bool _isLoadingLocation = true;
  final Position _defaultCenter = Position(74.341500, 35.911383);

  bool _showBottomSheet = true;
  Timer? _mapGestureTimer;
  Timer? _pulseTimer;
  double _pulseRadius = 14.0;
  double _pulseOpacity = 0.4;
  bool _pulseGrowing = true;

  // Track whether native style layers are ready
  bool _styleReady = false;

  bool get _isKeyboardOpen {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<DriverController>()) {
      Get.put(DriverController());
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

    // Enable native location puck (replaces manual live-location circle)
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        puckBearingEnabled: true,
      ),
    );

    // Get current location for initial camera position
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

    // ── Route line source + layers ──
    await style.addSource(
      GeoJsonSource(
        id: 'route-source',
        data: jsonEncode({'type': 'FeatureCollection', 'features': []}),
      ),
    );

    // Route casing (darker outline)
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

    // Pulse ring layer (animated blink)
    await style.addLayer(
      CircleLayer(
        id: 'markers-pulse-layer',
        sourceId: 'markers-source',
        circleRadius: 14.0,
        circleOpacity: 0.4,
        circleStrokeWidth: 0.0,
      ),
    );

    await style.setStyleLayerProperty(
      'markers-pulse-layer',
      'circle-color',
      '["get", "color"]',
    );

    // Data-driven circle color from feature property "color"
    await style.setStyleLayerProperty(
      'markers-circle-layer',
      'circle-color',
      '["get", "color"]',
    );

    _styleReady = true;
    _startPulseAnimation();
  }

  // ═══════════════════════════════════════════════════════════
  // PULSE ANIMATION
  // ═══════════════════════════════════════════════════════════

  void _startPulseAnimation() {
    _pulseTimer?.cancel();
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (!_styleReady || _mapboxMap == null) return;

      if (_pulseGrowing) {
        _pulseRadius += 0.4;
        _pulseOpacity -= 0.012;
        if (_pulseRadius >= 22.0) _pulseGrowing = false;
      } else {
        _pulseRadius -= 0.6;
        _pulseOpacity += 0.018;
        if (_pulseRadius <= 14.0) _pulseGrowing = true;
      }

      _pulseOpacity = _pulseOpacity.clamp(0.0, 0.4);
      _pulseRadius = _pulseRadius.clamp(14.0, 22.0);

      _mapboxMap!.style.setStyleLayerProperty(
        'markers-pulse-layer',
        'circle-radius',
        _pulseRadius,
      );
      _mapboxMap!.style.setStyleLayerProperty(
        'markers-pulse-layer',
        'circle-opacity',
        _pulseOpacity,
      );
    });
  }

  // ═══════════════════════════════════════════════════════════
  // LOCATION
  // ═══════════════════════════════════════════════════════════

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() => _isLoadingLocation = false);
        }
        return;
      }

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }

      if (permission == geo.LocationPermission.whileInUse ||
          permission == geo.LocationPermission.always) {
        geo.Position position = await geo.Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: geo.LocationAccuracy.high,
        );

        if (mounted) {
          setState(() => _isLoadingLocation = false);
          _flyTo(position.latitude, position.longitude, 15);
        }
      } else {
        if (mounted) setState(() => _isLoadingLocation = false);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) setState(() => _isLoadingLocation = false);
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

  Future<void> _fitBounds({
    required double pickupLat,
    required double pickupLng,
    required double destLat,
    required double destLng,
    List<List<double>> routeCoords = const [],
  }) async {
    final allPoints = <Position>[
      Position(pickupLng, pickupLat),
      Position(destLng, destLat),
      ...(routeCoords.map((c) => Position(c[0], c[1]))),
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
      MbxEdgeInsets(top: 100, left: 80, bottom: 350, right: 80),
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
  // SHOW RIDE ON MAP (when driver taps a ride card)
  // ═══════════════════════════════════════════════════════════

  /// Shows the local's pickup (green) and destination (red) on the map
  /// with a route line between them.
  Future<void> showRideOnMap({
    required double pickupLat,
    required double pickupLng,
    required double destLat,
    required double destLng,
  }) async {
    await _updateMarkers(
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      destLat: destLat,
      destLng: destLng,
    );

    try {
      final result = await LocationRoutingService.getRoutes(
        startLat: pickupLat,
        startLng: pickupLng,
        endLat: destLat,
        endLng: destLng,
      );

      if (result != null && result.routes.isNotEmpty) {
        final route = result.routes.first;
        final rawCoords = route.coordinates
            .map<List<double>>((c) => [c[1], c[0]])
            .toList();

        await _updateRouteLine(rawCoords);
        await _fitBounds(
          pickupLat: pickupLat,
          pickupLng: pickupLng,
          destLat: destLat,
          destLng: destLng,
          routeCoords: rawCoords,
        );
      }
    } catch (e) {
      debugPrint('Route error: $e');
      await _fitBounds(
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        destLat: destLat,
        destLng: destLng,
      );
    }
  }

  /// Clear markers and route from map
  Future<void> clearMapOverlays() async {
    await _updateMarkers();
    await _updateRouteLine([]);
  }

  // ═══════════════════════════════════════════════════════════
  // UPDATE MARKERS (GeoJSON Source)
  // ═══════════════════════════════════════════════════════════

  Future<void> _updateMarkers({
    double? pickupLat,
    double? pickupLng,
    double? destLat,
    double? destLng,
  }) async {
    if (!_styleReady || _mapboxMap == null) return;

    final features = <Map<String, dynamic>>[];

    // Pickup marker - green
    if (pickupLat != null && pickupLng != null) {
      features.add({
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [pickupLng, pickupLat],
        },
        'properties': {'color': '#4CAF50', 'type': 'pickup'},
      });
    }

    // Destination marker - red
    if (destLat != null && destLng != null) {
      features.add({
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [destLng, destLat],
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

  Future<void> _updateRouteLine(List<List<double>> coords) async {
    if (!_styleReady || _mapboxMap == null) return;

    String geojson;
    if (coords.isEmpty) {
      geojson = jsonEncode({'type': 'FeatureCollection', 'features': []});
    } else {
      geojson = jsonEncode({
        'type': 'Feature',
        'geometry': {'type': 'LineString', 'coordinates': coords},
      });
    }

    await _mapboxMap!.style.setStyleSourceProperty(
      'route-source',
      'data',
      geojson,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // MAP GESTURE
  // ═══════════════════════════════════════════════════════════

  void _onMapGesture() {
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

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      body: Stack(
        children: [
          // Mapbox Map — native location puck, GeoJSON layers
          MapWidget(
            key: const ValueKey('driverHomeMap'),
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
            onScrollListener: (_) => _onMapGesture(),
          ),

          // Loading overlay
          if (_isLoadingLocation)
            const Center(child: CircularProgressIndicator()),

          TopBar(
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            onNotificationPressed: () {
              Navigator.pushNamed(context, '/notification(driver)');
            },
          ),

          // Bottom sheet
          AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: _showBottomSheet ? 0 : -500,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: Obx(() {
              final driverCtrl = Get.find<DriverController>();
              final activeRide = driverCtrl.activeRide.value;

              // Active ride — show ride flow
              if (activeRide != null) {
                return RideFlowScreen(rideModel: activeRide);
              }

              // Normal — show ride request cards
              return DriverBottomSheet(
                onOfferTap: () {
                  setState(() {
                    _showBottomSheet = false;
                  });
                },
                onOfferClose: () {
                  clearMapOverlays();
                  setState(() {
                    _showBottomSheet = true;
                  });
                },
                onShowRide: (pickupLat, pickupLng, destLat, destLng) {
                  showRideOnMap(
                    pickupLat: pickupLat,
                    pickupLng: pickupLng,
                    destLat: destLat,
                    destLng: destLng,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapGestureTimer?.cancel();
    _pulseTimer?.cancel();
    super.dispose();
  }
}
