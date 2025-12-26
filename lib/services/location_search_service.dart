import 'dart:convert';
import 'package:gb_ride/utils/logger.dart';
import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';


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

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      displayName: json['display_name'] ?? '',
      latitude: double.tryParse(json['lat'] ?? '0') ?? 0.0,
      longitude: double.tryParse(json['lon'] ?? '0') ?? 0.0,
      type: json['type'] ?? '',
    );
  }
}

class LocationSearchService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  // Search for locations with autocomplete
  static Future<List<LocationSuggestion>> searchLocations(String query) async {
    if (query.isEmpty || query.length < 2) {
      return [];
    }

    try {
      final url = Uri.parse(
        '$_baseUrl/search?q=$query&format=json&limit=10&countrycodes=pk&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'GBRideApp/1.0', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LocationSuggestion.fromJson(json)).toList();
      } else {
        logger.i('Search failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      logger.i('Error searching locations: $e');
      return [];
    }
  }
  // Get location from coordinates (reverse geocoding)
  static Future<String?> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/reverse?lat=$lat&lon=$lon&format=json');

      final response = await http.get(
        url,
        headers: {'User-Agent': 'GBRideApp/1.0', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'];
      }
      return null;
    } catch (e) {
      logger.i('Error getting address: $e');
      return null;
    }
  }
}
