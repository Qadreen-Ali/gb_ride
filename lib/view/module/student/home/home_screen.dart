import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../common/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  MapController? _mapController;  // Make it nullable

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
    _mapController = MapController();  // Initialize here
    // Delay location getting until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location services are disabled. Please enable them.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
          setState(() {
            _pickupLocation = _currentLocation;
            _pickupController.text = 'Gilgit, Pakistan (Default)';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('Current permission status: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('Requested permission status: $permission');
        
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permissions are denied'),
                backgroundColor: Colors.orange,
              ),
            );
            setState(() {
              _pickupLocation = _currentLocation;
              _pickupController.text = 'Gilgit, Pakistan (Default)';
              _isLoadingLocation = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Location permissions are permanently denied. Enable them in settings.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Settings',
                textColor: Colors.white,
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                },
              ),
              duration: const Duration(seconds: 5),
            ),
          );
          setState(() {
            _pickupLocation = _currentLocation;
            _pickupController.text = 'Gilgit, Pakistan (Default)';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        debugPrint('Getting current position...');
        
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        
        debugPrint('Got position: ${position.latitude}, ${position.longitude}');

        if (mounted) {
          setState(() {
            _currentLocation = LatLng(position.latitude, position.longitude);
            _pickupLocation = _currentLocation;
            _pickupController.text = 'Getting address...';
            _isLoadingLocation = false;
          });
          
          // Move map to current location - only if map controller is ready
          if (_mapController != null) {
            try {
              _mapController!.move(_currentLocation, 15.0);
            } catch (e) {
              debugPrint('Map controller not ready yet: $e');
            }
          }
          
          // Get address
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
      debugPrint('Error getting location: $e');
      if (mounted) {
        setState(() {
          _pickupLocation = _currentLocation;
          _pickupController.text = 'Gilgit, Pakistan (Default)';
          _isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using default location'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
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
          address = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
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
            _pickupController.text = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
          } else {
            _destinationController.text = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
          }
          _isLoadingAddress = false;
        });
      }
    }
  }

  Future<void> _searchLocation(String query, {required bool isPickup}) async {
    if (query.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a location'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      if (mounted) {
        setState(() {
          _isLoadingAddress = true;
        });
      }

      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty && mounted) {
        Location location = locations[0];
        LatLng position = LatLng(location.latitude, location.longitude);

        setState(() {
          if (isPickup) {
            _pickupLocation = position;
            _pickupController.text = query;
          } else {
            _destinationLocation = position;
            _destinationController.text = query;
          }
          _isLoadingAddress = false;
        });

        _mapController?.move(position, 15.0);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isPickup ? '✓ Pickup location set' : '✓ Destination set'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingAddress = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location not found. Please try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error searching location: $e');
      if (mounted) {
        setState(() {
          _isLoadingAddress = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error finding location. Please try a different search.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startPickupSelection() {
    setState(() {
      _isSelectingPickup = true;
      _isSelectingDestination = false;
    });
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
      
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _mapController?.move(position, 15.0);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Pickup location selected'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } else if (_isSelectingDestination) {
      setState(() {
        _destinationLocation = position;
        _destinationController.text = 'Loading address...';
        _isSelectingDestination = false;
      });

      _getAddressFromLatLng(position, isPickup: false);

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _pickupLocation != null) {
          double centerLat = (_pickupLocation!.latitude + position.latitude) / 2;
          double centerLng = (_pickupLocation!.longitude + position.longitude) / 2;
          _mapController?.move(LatLng(centerLat, centerLng), 13.0);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Destination selected'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _cancelSelection() {
    setState(() {
      _isSelectingPickup = false;
      _isSelectingDestination = false;
    });
  }

  void _showLocationInputDialog({required bool isPickup}) {
    final TextEditingController dialogController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(
          isPickup ? 'Enter Pickup Location' : 'Enter Destination',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dialogController,
              decoration: InputDecoration(
                hintText: 'e.g., Gilgit, Pakistan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              autofocus: true,
              onSubmitted: (value) {
                Navigator.pop(dialogContext);
                _searchLocation(value, isPickup: isPickup);
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Examples: "Karachi", "Lahore, Pakistan", "Islamabad"',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _searchLocation(dialogController.text, isPickup: isPickup);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
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
                    MarkerLayer(
                      markers: [
                        // Current location marker
                        Marker(
                          point: _currentLocation,
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),

                        // Pickup location marker
                        if (_pickupLocation != null)
                          Marker(
                            point: _pickupLocation!,
                            width: 50,
                            height: 60,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 10,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),

                        // Destination location marker
                        if (_destinationLocation != null)
                          Marker(
                            point: _destinationLocation!,
                            width: 50,
                            height: 60,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 10,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                      ],
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
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _isSelectingPickup ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _isSelectingPickup
                                  ? Icons.touch_app
                                  : Icons.location_searching,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isSelectingPickup
                                  ? 'Tap on the map to select\nPICKUP LOCATION'
                                  : 'Tap on the map to select\nDESTINATION',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _cancelSelection,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Top Bar
          if (!_isSelectingPickup && !_isSelectingDestination)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 16,
                  right: 16,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.school, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Student Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
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

          // Bottom Card  
          if (!_isSelectingPickup && !_isSelectingDestination)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pickup Location
                    GestureDetector(
                      onTap: () => _showLocationInputDialog(isPickup: true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_pin_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _pickupController.text.isEmpty
                                    ? 'Tap to enter pickup location'
                                    : _pickupController.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _pickupController.text.isEmpty
                                      ? Colors.grey[600]
                                      : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  onPressed: () => _showLocationInputDialog(isPickup: true),
                                  tooltip: 'Type location',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.map,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                  onPressed: _startPickupSelection,
                                  tooltip: 'Select on map',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Destination
                    GestureDetector(
                      onTap: () => _showLocationInputDialog(isPickup: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(
                            color: Colors.red.shade200,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _destinationController.text.isEmpty
                                    ? 'Tap to enter destination'
                                    : _destinationController.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _destinationController.text.isEmpty
                                      ? Colors.grey[600]
                                      : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () => _showLocationInputDialog(isPickup: false),
                                  tooltip: 'Type location',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.map,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  onPressed: _startDestinationSelection,
                                  tooltip: 'Select on map',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Vehicle Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildVehicleOption('car', '🚗', 'Car'),
                        _buildVehicleOption('city', '🏙️', 'City to city'),
                        _buildVehicleOption('bike', '🏍️', 'Bike'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Fare Input
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'PKR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Offer your fare',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_pickupLocation == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a pickup location'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              if (_destinationLocation == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a destination'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Searching for $_selectedVehicle drivers...',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Find a Driver',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.navigation,
                              color: Colors.white,
                            ),
                            onPressed: () {
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleOption(String type, String emoji, String label) {
    bool isSelected = _selectedVehicle == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVehicle = type;
        });
      },
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade50 : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.orange : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}