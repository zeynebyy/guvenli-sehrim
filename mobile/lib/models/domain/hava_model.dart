class HavaModel {
  final String city;
  final double temp;
  final String condition;
  final int humidity;
  final double windSpeed;
  final List<ForecastModel> forecast;

   HavaModel({
    required this.city,
    required this.temp,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
  });
}

class ForecastModel {
  final String date;
  final double high;
  final double low;
  final String condition;

  ForecastModel({
    required this.date, 
    required this.high, 
    required this.low, 
    required this.condition
  });
}
