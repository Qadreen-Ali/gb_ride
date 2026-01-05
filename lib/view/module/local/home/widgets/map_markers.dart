import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapMarkers extends StatelessWidget {
  final LatLng currentLocation;
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;

  const MapMarkers({
    super.key,
    required this.currentLocation,
    this.pickupLocation,
    this.destinationLocation,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        // Current location marker
        Marker(
          point: currentLocation,
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
        if (pickupLocation != null)
          Marker(
            point: pickupLocation!,
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
        if (destinationLocation != null)
          Marker(
            point: destinationLocation!,
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
    );
  }
}
