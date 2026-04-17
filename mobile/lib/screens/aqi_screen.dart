import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_keys.dart';
import '../core/constants/app_colors.dart';
import '../providers/aqi_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common/loading_view.dart';
import '../widgets/common/error_view.dart';

class AqiScreen extends StatefulWidget {
  const AqiScreen({super.key});

  @override
  State<AqiScreen> createState() => _AqiScreenState();
}

class _AqiScreenState extends State<AqiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final city = context.read<SettingsProvider>().selectedCity;
      context.read<AqiProvider>().fetchAqi(city);
    });
  }

  List<Color> _getAqiGradient(int value) {
    if (value <= 50) return AppColors.aqiGood;
    if (value <= 100) return AppColors.aqiModerate;
    if (value <= 150) return AppColors.aqiPoor;
    return AppColors.aqiHazardous;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AqiProvider>();
    final city = context.read<SettingsProvider>().selectedCity;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentGradient = provider.aqi != null 
        ? _getAqiGradient(provider.aqi!.value) 
        : (isDark ? AppColors.aqiHazardous : AppColors.aqiGood);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Hava Kalitesi', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: currentGradient,
          ),
        ),
        child: provider.isLoading
            ? const LoadingView()
            : provider.error != null
                ? ErrorView(message: provider.error!, onRetry: () => provider.fetchAqi(city))
                : provider.aqi == null
                    ? const Center(child: Text('Veri bulunamadı'))
                    : SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              _buildAqiGauge(provider.aqi!),
                              const SizedBox(height: 60),
                              _buildHealthSection(provider.aqi!.status, provider.aqi!.advice),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }

  Widget _buildAqiGauge(aqi) {
    return Container(
      height: 280,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ring
          Container(
            height: 280,
            width: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.05), width: 20),
            ),
          ),
          // Inner Glass
          ClipRRect(
            borderRadius: BorderRadius.circular(140),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: 240,
                width: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${aqi.value}',
                      style: GoogleFonts.outfit(
                        fontSize: 80, 
                        fontWeight: FontWeight.w200, 
                        color: Colors.white
                      ),
                    ),
                    Text(
                      aqi.status.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 18, 
                        fontWeight: FontWeight.w700, 
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 2
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSection(String status, String advice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'SAĞLIK TAVSİYESİ',
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.7), 
              fontWeight: FontWeight.bold, 
              letterSpacing: 2,
              fontSize: 12
            ),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_moon_outlined, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      advice,
                      style: GoogleFonts.outfit(
                        color: Colors.white, 
                        fontSize: 16, 
                        height: 1.6,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
