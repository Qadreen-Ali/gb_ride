import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../models/gb_location_data/gb_poi.dart';
import '../../../../../services/gb_poi_service.dart';
import '../../../../../services/location_routing_service.dart';
import '../../../../../services/location_search_service.dart';
import '../widgets/location_search_screen.dart';

class LocalHomeController extends ChangeNotifier {
  // Controllers
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  // Map
  final MapController mapController = MapController();
  Timer? _mapGestureTimer;

  // Live location
  LatLng? liveLocation;
  StreamSubscription<Position>? _liveLocationStream;

  // Routing variables
  List<List<LatLng>> routes = [];
  double? distanceKm;
  int? etaMinutes;

  // State flags
  LatLng currentLocation = const LatLng(35.911383, 74.341500);
  LatLng? pickupLocation;
  LatLng? destinationLocation;

  String selectedVehicle = 'car';

  bool isLoadingLocation = true;
  bool isSelectingPickup = false;
  bool isSelectingDestination = false;
  bool isLoadingAddress = false;
  bool showBottomSheet = true;

  // ---------- INIT / DISPOSE ----------
  Future<void> init() async {
    // ✅ Load POIs once
    GbPoiService.loadPois();

    await getCurrentLocation();
    startLiveLocation();
  }

  @override
  void dispose() {
    _liveLocationStream?.cancel();
    _mapGestureTimer?.cancel();
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  // ---------- UI HELPERS ----------
  void onMapGesture({required bool isKeyboardOpen}) {
    if (isKeyboardOpen) return;

    if (showBottomSheet) {
      showBottomSheet = false;
      notifyListeners();
    }

    _mapGestureTimer?.cancel();
    _mapGestureTimer = Timer(const Duration(milliseconds: 300), () {
      showBottomSheet = true;
      notifyListeners();
    });
  }

  // ---------- LOCATION ----------
  Future<void> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        pickupLocation = currentLocation;
        pickupController.text = 'Gilgit, Pakistan';
        isLoadingLocation = false;
        notifyListeners();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );

        currentLocation = LatLng(position.latitude, position.longitude);
        pickupLocation = currentLocation;
        pickupController.text = 'Getting address...';
        isLoadingLocation = false;
        notifyListeners();

        mapController.move(currentLocation, 15.0);
        await getAddressFromLatLng(currentLocation, isPickup: true);
      }
    } catch (e) {
      debugPrint('Error: $e');
      pickupLocation = currentLocation;
      pickupController.text = 'Gilgit, Pakistan';
      isLoadingLocation = false;
      notifyListeners();
    }
  }

  void startLiveLocation() {
    _liveLocationStream?.cancel();

    _liveLocationStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
          ),
        ).listen((position) {
          liveLocation = LatLng(position.latitude, position.longitude);
          notifyListeners();
        });
  }

  Future<void> useLiveLocationAsPickup() async {
    if (liveLocation == null) return;

    pickupLocation = liveLocation;
    pickupController.text = 'Getting address...';
    notifyListeners();

    mapController.move(liveLocation!, 16);
    await getAddressFromLatLng(liveLocation!, isPickup: true);
  }

  // ---------- POI ----------
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
    const radiusMeters = 120;

    for (final poi in GbPoiService.cachedPois) {
      final distance = _distanceInMeters(
        position.latitude,
        position.longitude,
        poi.lat,
        poi.lon,
      );

      if (distance <= radiusMeters) return poi;
    }
    return null;
  }

  Future<void> getAddressFromLatLng(
      LatLng position, {
        required bool isPickup,
      }) async {
    try {
      isLoadingAddress = true;
      notifyListeners();

      // ✅ 1) Local POI first
      final nearbyPoi = _findNearestPoi(position);
      if (nearbyPoi != null) {
        final text = '${nearbyPoi.name}, ${nearbyPoi.city}';

        if (isPickup) {
          pickupController.text = text;
          pickupLocation = position;
        } else {
          destinationController.text = text;
          destinationLocation = position;
        }

        isLoadingAddress = false;
        notifyListeners();
        return;
      }

      // ✅ 2) Fallback to LocationIQ
      final address = await LocationSearchService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final text =
          address ??
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';

      if (isPickup) {
        pickupController.text = text;
        pickupLocation = position;
      } else {
        destinationController.text = text;
        destinationLocation = position;
      }

      isLoadingAddress = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting address: $e');
      isLoadingAddress = false;
      notifyListeners();
    }
  }

  // ---------- ROUTING ----------
  Future<void> calculateRoute() async {
    if (pickupLocation == null || destinationLocation == null) return;

    final result = await LocationRoutingService.getRoutes(
      startLat: pickupLocation!.latitude,
      startLng: pickupLocation!.longitude,
      endLat: destinationLocation!.latitude,
      endLng: destinationLocation!.longitude,
    );

    if (result == null || result.routes.isEmpty) return;

    final newRoutes = result.routes.map((route) {
      final rawPoints = route.coordinates.map((e) => LatLng(e[0], e[1])).toList();
      final dense = _densify(rawPoints, 25);
      final smooth = _smoothChaikin(dense, iterations: 3);

      smooth.first = pickupLocation!;
      smooth.last = destinationLocation!;
      return smooth;
    }).toList();

    routes = newRoutes;
    distanceKm = result.routes.first.distanceMeters / 1000;
    etaMinutes = (result.routes.first.durationSeconds / 60).round();
    notifyListeners();

    fitMapToRoute(routes.first);
  }

  List<LatLng> _smoothChaikin(List<LatLng> points, {int iterations = 3}) {
    if (points.length < 3) return points;

    var result = points;
    for (int k = 0; k < iterations; k++) {
      final List<LatLng> newPoints = [];
      newPoints.add(result.first);

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

      newPoints.add(result.last);
      result = newPoints;
    }
    return result;
  }

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

  void fitMapToRoute(List<LatLng> points) {
    if (points.isEmpty) return;

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
    mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)),
    );
  }

  Future<void> openLocationSearch({
    required BuildContext context,
    required bool isPickup,
  }) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationSearchScreen(
        isPickup: isPickup,
        selectedLocationName: isPickup
            ? pickupController.text
            : destinationController.text,
      ),
    );

    if (result == null) return;

    final LatLng latLng = result['latLng'] as LatLng;
    final String name = result['name'] as String;

    if (isPickup) {
      await setPickup(latLng, name);       // clears old route + move map
    } else {
      await setDestination(latLng, name);  // calculates route if pickup exists
    }
  }


  // ---------- PICKUP / DESTINATION SELECTION ----------
  void startPickupSelection() {
    isSelectingPickup = true;
    isSelectingDestination = false;
    notifyListeners();
  }

  void startDestinationSelection() {
    if (pickupLocation == null) return;
    isSelectingDestination = true;
    isSelectingPickup = false;
    notifyListeners();
  }

  void cancelSelection() {
    isSelectingPickup = false;
    isSelectingDestination = false;
    notifyListeners();
  }

  Future<void> handleMapTap(LatLng position) async {
    if (isSelectingPickup) {
      pickupLocation = position;
      pickupController.text = 'Loading address...';
      isSelectingPickup = false;
      notifyListeners();
      await getAddressFromLatLng(position, isPickup: true);
    } else if (isSelectingDestination) {
      destinationLocation = position;
      destinationController.text = 'Loading address...';
      isSelectingDestination = false;
      notifyListeners();
      await getAddressFromLatLng(position, isPickup: false);
      // ✅ Optional: auto route
      await calculateRoute();
    }
  }

  void setVehicle(String v) {
    selectedVehicle = v;
    notifyListeners();
  }

  // For bottom sheet callbacks (same behavior)
  Future<void> setPickup(LatLng pos, String name) async {
    pickupLocation = pos;
    pickupController.text = name;

    // ✅ clear old route (same as your code)
    routes.clear();
    distanceKm = null;
    etaMinutes = null;

    notifyListeners();
    mapController.move(pos, 15);
  }

  Future<void> setDestination(LatLng pos, String name) async {
    destinationLocation = pos;
    destinationController.text = name;
    notifyListeners();
    mapController.move(pos, 15);

    if (pickupLocation != null) {
      await calculateRoute();
    }
  }
}
