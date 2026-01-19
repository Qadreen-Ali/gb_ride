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
  static const String _baseUrl = 'https://api.locationiq.com/v1';
  static const String _apiKey = 'pk.25e1a7ca81d6256515a0311e26fb2ec3'; //

  /// 🔍 Search locations
  static Future<List<LocationSuggestion>> searchLocations(String query) async {
    if (query.trim().length < 2) return [];

    try {
      final Uri url = Uri.parse(
        '$_baseUrl/search'
        '?key=$_apiKey'
        '&q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&limit=20'
        '&addressdetails=1'
        '&namedetails=1'
        '&extratags=1'
        '&dedupe=0'
        // 🔥 GILGIT-BALTISTAN BIAS
        '&viewbox=72.5,37.0,76.0,34.0'
        '&bounded=1',
      );

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
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

  /// 📍 Reverse geocoding
  static Future<String?> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/reverse'
        '?key=$_apiKey'
        '&lat=$lat'
        '&lon=$lon'
        '&format=json',
      );

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
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
