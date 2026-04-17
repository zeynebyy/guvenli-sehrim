import '../domain/doviz_model.dart';

class DovizDto {
  final String code;
  final String name;
  final double buying;
  final double selling;

  DovizDto({
    required this.code,
    required this.name,
    required this.buying,
    required this.selling,
  });

  factory DovizDto.fromJson(Map<String, dynamic> json) {
    return DovizDto(
      code: json['Kod'] ?? '',
      name: json['Isim'] ?? '',
      buying: double.tryParse(json['ForexBuying'] ?? '0') ?? 0.0,
      selling: double.tryParse(json['ForexSelling'] ?? '0') ?? 0.0,
    );
  }

  DovizModel toDomain() => DovizModel(
    code: code,
    name: name,
    buying: buying,
    selling: selling,
  );
}
