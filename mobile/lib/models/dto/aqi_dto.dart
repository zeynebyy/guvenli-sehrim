import '../domain/aqi_model.dart';

class AqiDto {
  final Map<String, dynamic> current;

  AqiDto({required this.current});

  factory AqiDto.fromJson(Map<String, dynamic> json) {
    return AqiDto(
      current: json['current'] ?? {},
    );
  }

  AqiModel toDomain() {
    final aqi = current['european_aqi'] as int? ?? 0;
    String status = 'İyi';
    String advice = 'Hava kalitesi tatmin edici ve hava kirliliği çok az risk teşkil ediyor.';

    if (aqi > 100) {
      status = 'Kötü';
      advice = 'Hava kirliliği herkes için sağlık sorunları yaratabilir.';
    } else if (aqi > 50) {
      status = 'Orta';
      advice = 'Bazı kirleticiler için hassas kişiler için orta dereceli bir sağlık sorunu olabilir.';
    }

    return AqiModel(
      value: aqi,
      status: status,
      advice: advice,
    );
  }
}
