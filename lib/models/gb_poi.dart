class GbPoi {
  final String id;
  final String name;
  final String city;
  final String type;
  final double lat;
  final double lon;
  final int priority;

  GbPoi({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.lat,
    required this.lon,
    required this.priority,
  });

  factory GbPoi.fromJson(Map<String, dynamic> json) {
    return GbPoi(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      type: json['type'],
      lat: json['lat'],
      lon: json['lon'],
      priority: json['priority'],
    );
  }
}
