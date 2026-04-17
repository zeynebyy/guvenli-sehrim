import '../domain/deprem_model.dart';

class DepremDto {
  final String date;
  final double depth;
  final double magnitude;
  final String location;
  final double latitude;
  final double longitude;

  DepremDto({
    required this.date,
    required this.depth,
    required this.magnitude,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  factory DepremDto.fromJson(Map<String, dynamic> json) {
    final geojson = json['geojson'] as Map<String, dynamic>?;
    final coordinates = geojson?['coordinates'] as List? ?? [0.0, 0.0];
    
    return DepremDto(
      date: json['date'] ?? '',
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
      magnitude: (json['mag'] as num?)?.toDouble() ?? 0.0,
      location: json['title'] ?? '',
      latitude: (coordinates.length > 1 ? coordinates[1] : 0.0).toDouble(),
      longitude: (coordinates.isNotEmpty ? coordinates[0] : 0.0).toDouble(),
    );
  }

  DepremModel toDomain() {
    return DepremModel(
      id: date, // Using date+location as unique for now if no ID
      magnitude: magnitude,
      location: location,
      time: date,
      date: date.split(' ').first,
      lat: latitude,
      lng: longitude,
      depth: depth,
    );
  }
}
