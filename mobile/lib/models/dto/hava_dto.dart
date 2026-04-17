import '../domain/hava_model.dart';

class HavaDto {
  final String city;
  final Map<String, dynamic> current;
  final Map<String, dynamic> daily;

  HavaDto({
    required this.city,
    required this.current,
    required this.daily,
  });

  factory HavaDto.fromJson(Map<String, dynamic> json) {
    return HavaDto(
      city: json['city'] ?? '',
      current: json['current'] ?? {},
      daily: json['daily'] ?? {},
    );
  }

  HavaModel toDomain() {
    // Basic mapping for now, expanding forecast from daily lists
    final times = daily['time'] as List? ?? [];
    final maxTemps = daily['temperature_2m_max'] as List? ?? [];
    final minTemps = daily['temperature_2m_min'] as List? ?? [];
    final weatherCodes = daily['weathercode'] as List? ?? [];

    List<ForecastModel> forecast = [];
    for (int i = 0; i < times.length; i++) {
      forecast.add(ForecastModel(
        date: times[i].toString(),
        high: (maxTemps[i] as num).toDouble(),
        low: (minTemps[i] as num).toDouble(),
        condition: i < weatherCodes.length 
            ? _mapWeatherCode(weatherCodes[i] as int? ?? 0) 
            : 'Belirsiz',
      ));
    }

    return HavaModel(
      city: city,
      temp: (current['temperature'] as num?)?.toDouble() ?? 0.0,
      condition: _mapWeatherCode((current['weathercode'] as num?)?.toInt() ?? 0),
      humidity: 0, // Open-Meteo current endpoint doesn't include humidity without extra params
      windSpeed: (current['windspeed'] as num?)?.toDouble() ?? 0.0,
      forecast: forecast,
    );
  }

  String _mapWeatherCode(int code) {
    if (code == 0) return 'Açık';
    if (code <= 3) return 'Parçalı Bulutlu';
    if (code <= 48) return 'Sisli';
    if (code <= 67) return 'Yağmurlu';
    if (code <= 77) return 'Karlı';
    if (code <= 82) return 'Sağanak Yağışlı';
    return 'Fırtına';
  }
}
