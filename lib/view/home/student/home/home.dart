import 'package:flutter/material.dart';
import 'package:gb_ride/view/home/student/home/widget/tap_options.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../utils/constants/color_string.dart';
import '../../../../utils/constants/image_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;

  LatLng myLocation = const LatLng(35.9176, 74.3086); // Gilgit
  final Set<Marker> _markers = {};

  // Keep track of selected tab index
  int selectedIndex = 0;

  // Custom tab data
  final List<Map<String, dynamic>> tabData = [
    {"image": GBImagePath.car, "label": "Car", "count": "1"},
    {"image": GBImagePath.schoolbus, "label": "City to City", "count": "2"},
    {"image": GBImagePath.motorcycle, "label": "Bike", "count": "5"},
  ];

  @override
  void initState() {
    super.initState();
    _setInitialMarkers();
    _determinePosition();
  }

  void _setInitialMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('myLocation'),
        position: myLocation,
        infoWindow: const InfoWindow(title: "My Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    _markers.addAll([
      Marker(
        markerId: const MarkerId('car1'),
        position: const LatLng(35.9180, 74.3090),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('car2'),
        position: const LatLng(35.9170, 74.3070),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    ]);
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      myLocation = LatLng(position.latitude, position.longitude);

      _markers.removeWhere((m) => m.markerId.value == 'myLocation');

      _markers.add(
        Marker(
          markerId: const MarkerId('myLocation'),
          position: myLocation,
          infoWindow: const InfoWindow(title: "My Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      mapController?.animateCamera(CameraUpdate.newLatLng(myLocation));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Image.asset(GBImagePath.menu, width: 27, height: 27),
                  const Spacer(),
                  Stack(
                    children: [
                      Image.asset(GBImagePath.logo, width: 27, height: 27),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.red,
                          child: const Text(
                            '3',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Google Map
            SizedBox(
              width: double.infinity,
              height: 400, // Adjust height as per your design
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: myLocation,
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  mapController = controller;
                },
                markers: _markers,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),

            const SizedBox(height: 20),

            // Bottom Card with selectable tabs
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            // Tab Options
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(tabData.length, (index) {
                                return TabOption(
                                  index: index,
                                  selectedIndex: selectedIndex,
                                  onTap: (i) {
                                    setState(() {
                                      selectedIndex = i;
                                    });
                                  },
                                  image: tabData[index]["image"],
                                  label: tabData[index]["label"],
                                  count: tabData[index]["count"],
                                );
                              }),
                            ),
                            SizedBox(height: 20),

                            // search Location
                            SizedBox(
                              width: 392,
                              height: 53,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "To",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.52),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    borderSide: BorderSide(
                                      color: GBColor.borderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: GBColor.borderColor,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 18.0, ),
                                    child: Image.asset(
                                      GBImagePath.search,
                                      width: 25,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 240),
                      child: Container(
                        width: 156,
                        height: 40,
                        decoration: BoxDecoration(color: GBColor.lightGray),
                        alignment: Alignment.center,
                        child: Text(
                          "Back to first screen",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
