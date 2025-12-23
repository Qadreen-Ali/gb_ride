import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gb_ride/common/app_drawer.dart';
//import 'package:gb_ride/services/location_search_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/location_input_field.dart';
import 'widgets/map_markers.dart';
import 'widgets/map_selection_overlay.dart';
import 'widgets/top_bar.dart';
import 'widgets/vehicle_selector.dart';
import 'widgets/fare_input.dart';
import 'widgets/action_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  MapController? _mapController;

  final DraggableScrollableController _sheetController = DraggableScrollableController();

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

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Current location detected'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
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

  Future<void> _getAddressFromLatLng(LatLng position, {required bool isPickup}) async {
    try {
      if (mounted) {
        setState(() {
          _isLoadingAddress = true;
        });
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        String address = '';

        if (place.name != null && place.name!.isNotEmpty && place.name != position.latitude.toStringAsFixed(4)) {
          address += place.name!;
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.locality!;
        }
        if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
          if (address.isNotEmpty && !address.contains(place.subAdministrativeArea!)) {
            address += ', ${place.subAdministrativeArea!}';
          }
        }
        if (place.country != null && place.country!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.country!;
        }

        if (address.isEmpty) {
          address = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
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
        setState(() {
          if (isPickup) {
            _pickupController.text = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          } else {
            _destinationController.text = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          }
          _isLoadingAddress = false;
        });
      }
    }
  }

  void _startPickupSelection() {
    setState(() {
      _isSelectingPickup = true;
      _isSelectingDestination = false;
    });

    _collapseSheet();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('👆 Tap anywhere on the map to select pickup location'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startDestinationSelection() {
    if (_pickupLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select pickup location first'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSelectingDestination = true;
      _isSelectingPickup = false;
    });

    _collapseSheet();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('👆 Tap anywhere on the map to select destination'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
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

      if (_pickupLocation != null) {
        double centerLat = (_pickupLocation!.latitude + position.latitude) / 2;
        double centerLng = (_pickupLocation!.longitude + position.longitude) / 2;
        _mapController?.move(LatLng(centerLat, centerLng), 13.0);
      }

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

  void _refreshCurrentLocation() {
    setState(() {
      _isLoadingLocation = true;
    });
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      body: Stack(
        children: [
          // Map Layer
          _isLoadingLocation
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(color: Colors.orange),
                      SizedBox(height: 16),
                      Text(
                        'Getting your location...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
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
                     urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                     userAgentPackageName: 'com.example.gb_ride',
                   ),
                    MapMarkers(
                      currentLocation: _currentLocation,
                      pickupLocation: _pickupLocation,
                      destinationLocation: _destinationLocation,
                    ),
                  ],
                ),

          // Loading indicator
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

          // Selection indicator
          if (_isSelectingPickup || _isSelectingDestination)
            MapSelectionOverlay(
              isSelectingPickup: _isSelectingPickup,
              onCancel: _cancelSelection,
            ),

          // Top Bar
          if (!_isSelectingPickup && !_isSelectingDestination)
            TopBar(
              onMenuPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              onNotificationPressed: () {},
            ),

          // Refresh Location Button
          if (!_isSelectingPickup && !_isSelectingDestination && !_isLoadingLocation)
            Positioned(
              right: 16,
              top: 120,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: _refreshCurrentLocation,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.orange,
                ),
              ),
            ),

          // Draggable Bottom Sheet
          if (!_isSelectingPickup && !_isSelectingDestination)
            DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.7,
              minChildSize: 0.15,
              maxChildSize: 0.9,
              snap: true,
              snapSizes: const [0.15, 0.7, 0.9],
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Pickup Location with Autocomplete
                      LocationInputField(
                        controller: _pickupController,
                        hintText: 'Enter pickup location',
                        themeColor: Colors.green,
                        iconData: Icons.person_pin_circle,
                        onMapIconPressed: _startPickupSelection,
                        onExpandSheet: _expandSheet,
                        onLocationSelected: (position, displayName) {
                          setState(() {
                            _pickupLocation = position;
                            _pickupController.text = displayName;
                          });
                          _mapController?.move(position, 15.0);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Pickup location set'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Destination with Autocomplete
                      LocationInputField(
                        controller: _destinationController,
                        hintText: 'Where to?',
                        themeColor: Colors.red,
                        iconData: Icons.location_on,
                        onMapIconPressed: _startDestinationSelection,
                        onExpandSheet: _expandSheet,
                        onLocationSelected: (position, displayName) {
                          setState(() {
                            _destinationLocation = position;
                            _destinationController.text = displayName;
                          });
                          _mapController?.move(position, 15.0);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Destination set'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Vehicle Selection
                      VehicleSelector(
                        selectedVehicle: _selectedVehicle,
                        onVehicleSelected: (type) {
                          setState(() {
                            _selectedVehicle = type;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Fare Input
                      const FareInput(),
                      const SizedBox(height: 16),

                      // Action Buttons
                      ActionButtons(
                        pickupLocation: _pickupLocation,
                        destinationLocation: _destinationLocation,
                        selectedVehicle: _selectedVehicle,
                        onChatPressed: () {},
                        onNavigationPressed: () {
                          if (_destinationLocation != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Starting navigation...'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a destination first'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
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
