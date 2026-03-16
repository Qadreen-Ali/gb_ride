import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:gb_ride/utils/logger.dart';

class LocationSuggestion {
  final String displayName;
  final double latitude;
  final double longitude;
  final String type;

  LocationSuggestion({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  /// Parse a Mapbox Geocoding API feature
  factory LocationSuggestion.fromMapbox(Map<String, dynamic> feature) {
    final List coords = feature['center'] ?? [0, 0]; // [lng, lat]
    final String placeName = feature['place_name'] ?? '';
    final String type = feature['place_type']?.isNotEmpty == true
        ? feature['place_type'][0]
        : '';

    return LocationSuggestion(
      displayName: placeName,
      latitude: (coords[1] as num).toDouble(),
      longitude: (coords[0] as num).toDouble(),
      type: type,
    );
  }
}

/// Location search & reverse geocoding powered by Mapbox Geocoding API.
/// Docs: https://docs.mapbox.com/api/search/geocoding/
class LocationSearchService {
  static final String _token = dotenv.env['MAPBOX_TOKEN']!;
  static const String _baseUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

  // Gilgit-Baltistan bounding box (expanded): [minLng, minLat, maxLng, maxLat]
  static const String _gbBBox = '72.0,33.5,77.0,37.5';

  // Proximity bias — Gilgit city center so nearby results rank higher
  static const String _proximity = '74.31,35.92';

  /// 🔍 Forward geocoding — search locations
  static Future<List<LocationSuggestion>> searchLocations(String query) async {
    if (query.trim().length < 2) return [];

    try {
      final Uri url = Uri.parse(
        '$_baseUrl/${Uri.encodeComponent(query)}.json'
        '?access_token=$_token'
        '&limit=10'
        '&autocomplete=true'
        '&fuzzyMatch=true'
        '&bbox=$_gbBBox'
        '&proximity=$_proximity'
        '&types=poi,poi.landmark,place,locality,neighborhood,address'
        '&language=en',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List features = data['features'] ?? [];
        return features.map((f) => LocationSuggestion.fromMapbox(f)).toList();
      } else {
        logger.i('Mapbox search failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      logger.i('Mapbox search error: $e');
      return [];
    }
  }

  /// 📍 Reverse geocoding — coordinates → address
  static Future<String?> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/$lon,$lat.json'
        '?access_token=$_token'
        '&limit=1'
        '&language=en'
        '&types=poi,poi.landmark,place,locality,neighborhood,address',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List features = data['features'] ?? [];
        if (features.isNotEmpty) {
          return features[0]['place_name'];
        }
      }
      return null;
    } catch (e) {
      logger.i('Mapbox reverse geocode error: $e');
      return null;
    }
  }
}
