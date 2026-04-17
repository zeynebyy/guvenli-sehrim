import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_keys.dart';
import '../providers/deprem_provider.dart';
import '../providers/hava_provider.dart';
import '../providers/aqi_provider.dart';
import '../providers/namaz_provider.dart';
import '../providers/doviz_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/cards/dashboard_card.dart';
import 'deprem_screen.dart';
import 'hava_screen.dart';
import 'aqi_screen.dart';
import 'namaz_screen.dart';
import 'doviz_screen.dart';
import 'ayarlar_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  Future<void> _refreshData() async {
    final city = context.read<SettingsProvider>().selectedCity;
    await Future.wait([
      context.read<DepremProvider>().fetchDepremler(),
      context.read<HavaProvider>().fetchHava(city),
      context.read<AqiProvider>().fetchAqi(city),
      context.read<NamazProvider>().fetchNamaz(city),
      context.read<DovizProvider>().fetchDoviz(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'GÜVENLİ ŞEHRİM',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              key: const Key(AppKeys.navAyarlar),
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AyarlarScreen())),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
              ? [const Color(0xFF03045E), const Color(0xFF000814)]
              : [const Color(0xFFCAF0F8), Colors.white],
          ),
        ),
        child: RefreshIndicator(
          key: const Key(AppKeys.dashboardRefresh),
          onRefresh: _refreshData,
          backgroundColor: Colors.white,
          color: const Color(0xFF0077B6),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: _buildLocationHeader(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: _buildGrid(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    final city = context.watch<SettingsProvider>().selectedCity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hoş Geldiniz',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue, size: 24),
            const SizedBox(width: 8),
            Text(
              city,
              key: const Key(AppKeys.dashboardKonumText),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return SliverGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildDepremCard(),
        _buildHavaCard(),
        _buildAqiCard(),
        _buildNamazCard(),
        _buildDovizCard(),
      ],
    );
  }

  Widget _buildDepremCard() {
    final provider = context.watch<DepremProvider>();
    final last = provider.depremler.isNotEmpty ? provider.depremler.first : null;
    return DashboardCard(
      widgetKey: AppKeys.dashboardDepremCard,
      title: 'Son Deprem',
      value: last != null ? '${last.magnitude}' : '...',
      subValue: last?.location ?? 'Veri bekleniyor',
      icon: Icons.waves,
      color: Colors.orange.shade700,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DepremScreen())),
    );
  }

  Widget _buildHavaCard() {
    final provider = context.watch<HavaProvider>();
    return DashboardCard(
      widgetKey: AppKeys.dashboardHavaCard,
      title: 'Hava Durumu',
      value: provider.hava != null ? '${provider.hava!.temp.toInt()}°C' : '...',
      subValue: provider.hava?.condition ?? 'Yükleniyor',
      icon: Icons.wb_cloudy_outlined,
      color: Colors.blue.shade600,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HavaScreen())),
    );
  }

  Widget _buildAqiCard() {
    final provider = context.watch<AqiProvider>();
    return DashboardCard(
      widgetKey: AppKeys.dashboardAqiCard,
      title: 'AQI Endeksi',
      value: provider.aqi != null ? '${provider.aqi!.value}' : '...',
      subValue: provider.aqi?.status ?? 'Ölçülüyor',
      icon: Icons.air_rounded,
      color: Colors.teal.shade600,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AqiScreen())),
    );
  }

  Widget _buildNamazCard() {
    final provider = context.watch<NamazProvider>();
    return DashboardCard(
      widgetKey: AppKeys.dashboardNamazCard,
      title: 'Ezan Saati',
      value: provider.namaz?.nextVakitTime ?? '...',
      subValue: provider.namaz != null 
        ? '${provider.namaz!.nextVakit} (${provider.namaz!.remainingTime})'
        : 'Hesaplanıyor',
      icon: Icons.mosque_rounded,
      color: Colors.indigo.shade600,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NamazScreen())),
    );
  }

  Widget _buildDovizCard() {
    final provider = context.watch<DovizProvider>();
    final usd = provider.dovizList.isNotEmpty 
      ? provider.dovizList.firstWhere((e) => e.code == 'USD', orElse: () => provider.dovizList.first)
      : null;
    final eur = provider.dovizList.length > 1
      ? provider.dovizList.firstWhere((e) => e.code == 'EUR', orElse: () => provider.dovizList[1])
      : null;

    String kurSummary = 'Yükleniyor...';
    if (usd != null && eur != null) {
      kurSummary = 'USD: ${usd.buying} | EUR: ${eur.buying}';
    } else if (usd != null) {
      kurSummary = 'USD: ${usd.buying} TL';
    }

    return DashboardCard(
      widgetKey: AppKeys.dashboardDovizCard,
      title: 'Piyasa Kurları',
      value: usd != null ? '${usd.buying} TL' : '...',
      subValue: kurSummary,
      icon: Icons.currency_exchange_rounded,
      color: Colors.teal.shade600,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DovizScreen())),
    );
  }
}
