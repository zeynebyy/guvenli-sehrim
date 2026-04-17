import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/app_keys.dart';
import '../core/constants/app_colors.dart';
import '../providers/deprem_provider.dart';
import '../widgets/common/loading_view.dart';
import '../widgets/common/error_view.dart';

class DepremScreen extends StatefulWidget {
  const DepremScreen({super.key});

  @override
  State<DepremScreen> createState() => _DepremScreenState();
}

class _DepremScreenState extends State<DepremScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepremProvider>().fetchDepremler();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepremProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Deprem Bilgileri', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: provider.depremler.any((d) => d.magnitude >= 5.0) 
              ? AppColors.earthquakeSerious 
              : AppColors.earthquakeNormal,
          ),
        ),
        child: provider.isLoading
            ? const LoadingView()
            : provider.error != null
                ? ErrorView(message: provider.error!, onRetry: provider.fetchDepremler)
                : Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildMapSection(provider, isDark),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildListSection(provider),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildMapSection(DepremProvider provider, bool isDark) {
    return Stack(
      children: [
        FlutterMap(
          key: const Key(AppKeys.depremMap),
          options: MapOptions(
            initialCenter: provider.depremler.isNotEmpty
                ? LatLng(provider.depremler.first.lat, provider.depremler.first.lng)
                : const LatLng(39.0, 35.0),
            initialZoom: 6.0,
          ),
          children: [
            TileLayer(
              urlTemplate: isDark 
                ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              userAgentPackageName: 'com.guvenlisehrim.app',
            ),
          MarkerLayer(
            markers: provider.depremler
                .map((d) => Marker(
                      point: LatLng(d.lat, d.lng),
                      width: 60.0,
                      height: 60.0,
                      child: _buildMarker(d),
                    ))
                .toList(),
          ),
          ],
        ),
        // Gradient overlay for better transition
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarker(d) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${d.location} - Büyüklük: ${d.magnitude}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (d.magnitude >= 4.0)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Container(
                  width: 40 * value,
                  height: 40 * value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.withOpacity(1 - value), width: 2),
                  ),
                );
              },
              onEnd: () {}, // Restart if needed via explicit logic
            ),
            Icon(
              Icons.location_on,
              color: d.magnitude >= 5.0 ? Colors.red : (d.magnitude >= 4.0 ? Colors.orange : Colors.blue),
              size: (d.magnitude * 10.0).clamp(24.0, 60.0),
            ),
        ],
      ),
    );
  }

  Widget _buildListSection(DepremProvider provider) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: ListView.builder(
            key: const Key(AppKeys.depremList),
            padding: const EdgeInsets.all(24),
            itemCount: provider.depremler.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final deprem = provider.depremler[index];
              final isSerious = deprem.magnitude >= 4.5;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isSerious ? 0.1 : 0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSerious ? Colors.red.withOpacity(0.3) : Colors.white.withOpacity(0.05)
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isSerious ? [Colors.red, Colors.redAccent] : [Colors.blueGrey, Colors.grey],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSerious ? [
                              BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)
                            ] : null,
                          ),
                          child: Text(
                            '${deprem.magnitude}',
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        title: Text(deprem.location, 
                          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(deprem.date, 
                            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${deprem.depth} km', 
                              style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                            Text('DERİNLİK', 
                              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
