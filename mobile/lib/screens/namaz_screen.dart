import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_keys.dart';
import '../core/constants/app_colors.dart';
import '../providers/namaz_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common/loading_view.dart';
import '../widgets/common/error_view.dart';

class NamazScreen extends StatefulWidget {
  const NamazScreen({super.key});

  @override
  State<NamazScreen> createState() => _NamazScreenState();
}

class _NamazScreenState extends State<NamazScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final city = context.read<SettingsProvider>().selectedCity;
      context.read<NamazProvider>().fetchNamaz(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NamazProvider>();
    final city = context.read<SettingsProvider>().selectedCity;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('$city Namaz Vakitleri', 
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
            colors: AppColors.namazGreen,
          ),
        ),
        child: provider.isLoading
            ? const LoadingView()
            : provider.error != null
                ? ErrorView(message: provider.error!, onRetry: () => provider.fetchNamaz(city))
                : provider.namaz == null
                    ? const Center(child: Text('Veri bulunamadı'))
                    : SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildNextVakitHeader(provider.namaz!),
                            Expanded(child: _buildVakitList(provider.namaz!)),
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget _buildNextVakitHeader(namaz) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        children: [
          Text(
            'SIRADAKİ VAKİT',
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.6), 
              fontSize: 12, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 4
            ),
          ),
          const SizedBox(height: 8),
          Text(
            namaz.nextVakit,
            style: GoogleFonts.outfit(
              fontSize: 54, 
              fontWeight: FontWeight.w200, 
              color: Colors.white
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white70, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      namaz.remainingTime,
                      style: GoogleFonts.outfit(
                        color: Colors.white, 
                        fontSize: 20, 
                        fontWeight: FontWeight.w600
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

  Widget _buildVakitList(namaz) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      physics: const BouncingScrollPhysics(),
      children: namaz.times.entries.map<Widget>((e) {
        final isNext = e.key == namaz.nextVakit;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: isNext ? 20 : 10, sigmaY: isNext ? 20 : 10),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isNext ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isNext ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.1)
                  ),
                  boxShadow: isNext ? [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                    )
                  ] : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (isNext) 
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.star_rounded, color: Colors.tealAccent, size: 20),
                          ),
                        Text(
                          e.key,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: isNext ? FontWeight.w800 : FontWeight.w500,
                            color: isNext ? Colors.white : Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      e.value,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
