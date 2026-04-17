import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_keys.dart';
import '../core/constants/app_colors.dart';
import '../providers/hava_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common/loading_view.dart';
import '../widgets/common/error_view.dart';

class HavaScreen extends StatefulWidget {
  const HavaScreen({super.key});

  @override
  State<HavaScreen> createState() => _HavaScreenState();
}

class _HavaScreenState extends State<HavaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final city = context.read<SettingsProvider>().selectedCity;
      context.read<HavaProvider>().fetchHava(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HavaProvider>();
    final city = context.read<SettingsProvider>().selectedCity;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('$city Hava Durumu', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark ? AppColors.weatherNight : AppColors.weatherDay,
          ),
        ),
        child: provider.isLoading
            ? const LoadingView()
            : provider.error != null
                ? ErrorView(message: provider.error!, onRetry: () => provider.fetchHava(city))
                : provider.hava == null
                    ? const Center(child: Text('Veri bulunamadı'))
                    : SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              _buildMainWeather(provider.hava!),
                              const SizedBox(height: 40),
                              _buildInfoGrid(provider.hava!),
                              const SizedBox(height: 40),
                              _buildForecastSection(provider.hava!.forecast),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }

  Widget _buildMainWeather(hava) {
    return Column(
      children: [
        Hero(
          tag: 'hava_icon',
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: Icon(_getWeatherIcon(hava.condition), size: 100, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${hava.temp.toInt()}°',
          key: const Key(AppKeys.havaTempText),
          style: GoogleFonts.outfit(
            fontSize: 100, 
            fontWeight: FontWeight.w200, 
            color: Colors.white,
            height: 1.0,
          ),
        ),
        Text(
          hava.condition.toUpperCase(),
          key: const Key(AppKeys.havaDurumText),
          style: GoogleFonts.outfit(
            fontSize: 22, 
            fontWeight: FontWeight.w600, 
            color: Colors.white70, 
            letterSpacing: 4
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(hava) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(Icons.water_drop_outlined, 'Nem', '${hava.humidity}%'),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildInfoItem(Icons.air_outlined, 'Rüzgar', '${hava.windSpeed} km/s'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildForecastSection(List forecast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'HAFTALIK TAHMİN',
            style: GoogleFonts.outfit(
              color: Colors.white70, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 2,
              fontSize: 12
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final item = forecast[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.date, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          Icon(_getWeatherIcon(item.condition), color: Colors.white, size: 28),
                          const SizedBox(height: 12),
                          Text('${item.high.toInt()}°', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                          Text('${item.low.toInt()}°', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('sunny') || c.contains('açık')) return Icons.wb_sunny_rounded;
    if (c.contains('cloud') || c.contains('bulutlu')) return Icons.wb_cloudy_rounded;
    if (c.contains('rain') || c.contains('yağmur')) return Icons.umbrella_rounded;
    return Icons.wb_cloudy_outlined;
  }
}
