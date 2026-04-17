import '../domain/namaz_model.dart';
import 'package:intl/intl.dart';

class NamazDto {
  final Map<String, dynamic> timings;

  NamazDto({required this.timings});

  factory NamazDto.fromJson(Map<String, dynamic> json) {
    return NamazDto(
      timings: json['timings'] ?? {},
    );
  }

  NamazModel toDomain() {
    final Map<String, String> rawTimes = {
      'İmsak': timings['Imsak'] ?? timings['Fajr'] ?? '',
      'Güneş': timings['Sunrise'] ?? '',
      'Öğle': timings['Dhuhr'] ?? '',
      'İkindi': timings['Asr'] ?? '',
      'Akşam': timings['Maghrib'] ?? '',
      'Yatsı': timings['Isha'] ?? '',
    };

    String nextVakit = 'İmsak';
    String nextVakitTime = '--:--';
    String remainingTime = '--:--';

    try {
      final now = DateTime.now();
      final format = DateFormat('HH:mm');
      
      bool found = false;
      for (var entry in rawTimes.entries) {
        if (entry.value.isEmpty) continue;
        
        final vakitTime = format.parse(entry.value);
        final vakitDateTime = DateTime(now.year, now.month, now.day, vakitTime.hour, vakitTime.minute);
        
        if (vakitDateTime.isAfter(now)) {
          nextVakit = entry.key;
          nextVakitTime = entry.value;
          final diff = vakitDateTime.difference(now);
          final hours = diff.inHours;
          final minutes = diff.inMinutes % 60;
          remainingTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
          found = true;
          break;
        }
      }

      // If no vakit found today, next one is tomorrow's Imsak
      if (!found) {
        nextVakit = 'İmsak (Yarın)';
        nextVakitTime = rawTimes['İmsak'] ?? '--:--';
        remainingTime = 'Gece';
      }
    } catch (e) {
      // Fallback
    }

    return NamazModel(
      times: rawTimes.map((k, v) => MapEntry(k, v)),
      nextVakit: nextVakit,
      nextVakitTime: nextVakitTime,
      remainingTime: remainingTime,
    );
  }
}
