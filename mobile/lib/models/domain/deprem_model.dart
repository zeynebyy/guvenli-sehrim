class DepremModel {
  final String id;
  final double magnitude;
  final String location;
  final String time;
  final String date;
  final double lat;
  final double lng;
  final double depth;

  DepremModel({
    required this.id,
    required this.magnitude,
    required this.location,
    required this.time,
    required this.date,
    required this.lat,
    required this.lng,
    required this.depth,
  });
}
