import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RouteResult {
  final double distanceMeters;
  final double durationSeconds;
  final List<List<double>> coordinates;

  RouteResult({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.coordinates,
  });
}

//new model for alternative routing service
class RoutePath {
  final double distanceMeters;
  final double durationSeconds;
  final List<List<double>> coordinates;

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

// Service to get routing information from LocationIQ API
class LocationRoutingService {
  static const String _apiKey = 'pk.25e1a7ca81d6256515a0311e26fb2ec3';

  static Future<RoutesResult?> getRoutes({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String profile = 'driving',
  }) async {
    final url = Uri.parse(
      'https://us1.locationiq.com/v1/directions/$profile/'
      '$startLng,$startLat;$endLng,$endLat'
      '?key=$_apiKey'
      '&overview=full'
      '&geometries=geojson'
      '&steps=false'
      '&alternatives=true',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      debugPrint('ROUTING ERROR: ${response.body}');
      return null;
    }

    final data = json.decode(response.body);
    final routes = data['routes'] as List?;

    if (routes == null || routes.isEmpty) {
      debugPrint('NO ROUTES FOUND');
      return null;
    }

    return RoutesResult(
      routes: routes.map<RoutePath>((route) {
        final coords = route['geometry']['coordinates'] as List;

        return RoutePath(
          distanceMeters: (route['distance'] as num).toDouble(),
          durationSeconds: (route['duration'] as num).toDouble(),
          coordinates: coords
              .map<List<double>>(
                (e) => [e[1].toDouble(), e[0].toDouble()], // lat, lng
              )
              .toList(),
        );
      }).toList(),
    );
  }
}
