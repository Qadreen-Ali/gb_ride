import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RoutePath {
  final double distanceMeters;
  final double durationSeconds;
  final List<List<double>> coordinates; // [[lat, lng], ...]

  RoutePath({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.coordinates,
  });
}

class RoutesResult {
  final List<RoutePath> routes;
  RoutesResult({required this.routes});
}

/// Routing service powered by Mapbox Directions API.
/// Docs: https://docs.mapbox.com/api/navigation/directions/
class LocationRoutingService {
  static final String _token = dotenv.env['MAPBOX_TOKEN']!;
  static const String _baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  /// Fetch driving routes between two points.
  /// Returns distance, duration, and decoded polyline coordinates.
  static Future<RoutesResult?> getRoutes({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String profile = 'driving',
  }) async {
    // Mapbox Directions format: /profile/lng1,lat1;lng2,lat2
    final url = Uri.parse(
      '$_baseUrl/$profile/'
      '$startLng,$startLat;$endLng,$endLat'
      '?access_token=$_token'
      '&overview=full'
      '&geometries=geojson'
      '&steps=false'
      '&alternatives=true',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        debugPrint('Mapbox Directions error: ${response.body}');
        return null;
      }

      final data = json.decode(response.body);
      final routes = data['routes'] as List?;

      if (routes == null || routes.isEmpty) {
        debugPrint('Mapbox: no routes found');
        return null;
      }

      return RoutesResult(
        routes: routes.map<RoutePath>((route) {
          final coords = route['geometry']['coordinates'] as List;

          return RoutePath(
            distanceMeters: (route['distance'] as num).toDouble(),
            durationSeconds: (route['duration'] as num).toDouble(),
            // Mapbox returns [lng, lat] — flip to [lat, lng] for LatLng
            coordinates: coords
                .map<List<double>>(
                  (e) => [
                    (e[1] as num).toDouble(), // lat
                    (e[0] as num).toDouble(), // lng
                  ],
                )
                .toList(),
          );
        }).toList(),
      );
    } catch (e) {
      debugPrint('Mapbox Directions exception: $e');
      return null;
    }
  }
}
