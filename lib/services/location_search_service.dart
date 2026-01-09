import 'dart:convert';
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

  /// 🔍 Search locations (ENGLISH ONLY)
  static Future<List<LocationSuggestion>> searchLocations(String query) async {
    if (query.isEmpty || query.length < 2) {
      return [];
    }

    try {
      final Uri url = Uri.parse(
        '$_baseUrl/search'
        '?q=$query'
        '&format=json'
        '&limit=10'
        '&countrycodes=pk'
        '&addressdetails=1'
        '&accept-language=en',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'GBRideApp/1.0', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => LocationSuggestion.fromJson(e)).toList();
      } else {
        logger.i('Search failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      logger.i('Search error: $e');
      return [];
    }
  }

  /// 📍 Reverse geocoding (ENGLISH ONLY)
  static Future<String?> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/reverse'
        '?lat=$lat'
        '&lon=$lon'
        '&format=json'
        '&accept-language=en',
      );

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
      logger.i('Reverse geocode error: $e');
      return null;
    }
  }
}
