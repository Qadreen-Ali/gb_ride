import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/gb_location_data/gb_poi.dart';

class GbPoiService {
  static List<GbPoi> _cachedPois = [];

    static List<GbPoi> get cachedPois => _cachedPois;

  static Future<void> loadPois() async {
    if (_cachedPois.isNotEmpty) return;

    final String data =
        await rootBundle.loadString('assets/data/gb_pois.json');
    final List list = json.decode(data);

    _cachedPois = list.map((e) => GbPoi.fromJson(e)).toList();
  }

  static List<GbPoi> search(String query) {
    if (query.trim().length < 2) return [];

    final q = query.toLowerCase();

    return _cachedPois
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.city.toLowerCase().contains(q))
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }
}
