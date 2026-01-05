import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gb_ride/view/module/local/home/app_drawer/app_drawer.dart';
import 'package:gb_ride/view/module/student/home/widgets/fare_bottom_sheet.dart';
import 'package:gb_ride/view/module/student/home/widgets/find_driver_bottom_sheet.dart';
import 'package:gb_ride/view/module/student/home/widgets/vehicle_option.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:gb_ride/common/app_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'home_bottom_sheet.dart';
import 'widgets/map_markers.dart';
import 'widgets/map_selection_overlay.dart';
import 'widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  MapController? _mapController;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  LatLng _currentLocation = const LatLng(35.911383, 74.341500);
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  String _selectedVehicle = 'car';
  bool _isLoadingLocation = true;
  bool _isSelectingPickup = false;
  bool _isSelectingDestination = false;
  bool _isLoadingAddress = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
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

  Future<void> _getAddressFromLatLng(
    LatLng position, {
    required bool isPickup,
  }) async {
    try {
      if (mounted) setState(() => _isLoadingAddress = true);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks[0];
        String address = '';

        if (place.name != null &&
            place.name!.isNotEmpty &&
            place.name != position.latitude.toStringAsFixed(4)) {
          address += place.name!;
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.locality!;
        }
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          if (address.isNotEmpty &&
              !address.contains(place.subAdministrativeArea!)) {
            address += ', ${place.subAdministrativeArea!}';
          }
        }
        if (place.country != null && place.country!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.country!;
        }

        if (address.isEmpty) {
          address =
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        }

        if (mounted) {
          setState(() {
            if (isPickup) {
              _pickupController.text = address;
            } else {
              _destinationController.text = address;
            }
            _isLoadingAddress = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      if (mounted) {
        setState(() => _isLoadingAddress = false);
      }
    }
  }

  void _startPickupSelection() {
    setState(() {
      _isSelectingPickup = true;
      _isSelectingDestination = false;
    });
    _collapseSheet();
  }

  void _startDestinationSelection() {
    if (_pickupLocation == null) return;
    setState(() {
      _isSelectingDestination = true;
      _isSelectingPickup = false;
    });
    _collapseSheet();
  }

  void _handleMapTap(TapPosition tapPosition, LatLng position) {
    if (_isSelectingPickup) {
      setState(() {
        _pickupLocation = position;
        _pickupController.text = 'Loading address...';
        _isSelectingPickup = false;
      });
      _getAddressFromLatLng(position, isPickup: true);
      _mapController?.move(position, 15.0);
      _expandSheet();
    } else if (_isSelectingDestination) {
      setState(() {
        _destinationLocation = position;
        _destinationController.text = 'Loading address...';
        _isSelectingDestination = false;
      });
      _getAddressFromLatLng(position, isPickup: false);
      _expandSheet();
    } else {
      _collapseSheet();
    }
  }

  void _cancelSelection() {
    setState(() {
      _isSelectingPickup = false;
      _isSelectingDestination = false;
    });
    _expandSheet();
  }

  void _collapseSheet() {
    _sheetController.animateTo(
      0.15,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _expandSheet() {
    _sheetController.animateTo(
      0.7,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),

      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          _isLoadingLocation
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation,
                    initialZoom: 15.0,
                    minZoom: 10.0,
                    maxZoom: 18.0,
                    onTap: _handleMapTap,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.gb_ride',
                    ),
                    MapMarkers(
                      currentLocation: _currentLocation,
                      pickupLocation: _pickupLocation,
                      destinationLocation: _destinationLocation,
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
              onNotificationPressed: () {},
            ),

          // Draggable bottom sheet
          if (!_isSelectingPickup && !_isSelectingDestination)
            DraggableScrollableSheet(
              controller: _sheetController,
              expand: true,
              initialChildSize: 0.52,
              minChildSize: 0.15,
              maxChildSize: 1.0,
              snap: true,
              snapSizes: const [0.15, 0.52, 1.0],
              builder: (context, scrollController) {
                return HomeBottomSheet(
                  scrollController: scrollController,
                  pickupController: _pickupController,
                  destinationController: _destinationController,
                  onStartPickupSelection: _startPickupSelection,
                  onStartDestinationSelection: _startDestinationSelection,
                  onExpandSheet: _expandSheet,
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
                  onDestinationSelected: (pos, name) {
                    setState(() {
                      _destinationLocation = pos;
                      _destinationController.text = name;
                    });
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _mapController?.dispose();
    _sheetController.dispose();
    super.dispose();
  }
}
