import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/deprem_provider.dart';
import 'providers/hava_provider.dart';
import 'providers/aqi_provider.dart';
import 'providers/namaz_provider.dart';
import 'providers/doviz_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/dashboard_screen.dart';

import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  // Open boxes
  await Hive.openBox('settings');
  await Hive.openBox('cache_deprem');
  await Hive.openBox('cache_hava');
  await Hive.openBox('cache_aqi');
  await Hive.openBox('cache_namaz');
  await Hive.openBox('cache_doviz');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, DepremProvider>(
          create: (_) => DepremProvider(),
          update: (_, settings, deprem) => deprem!..update(settings),
        ),
        ChangeNotifierProvider(create: (_) => HavaProvider()),
        ChangeNotifierProvider(create: (_) => AqiProvider()),
        ChangeNotifierProvider(create: (_) => NamazProvider()),
        ChangeNotifierProvider(create: (_) => DovizProvider()),
      ],
      child: const GuvenliSehrimApp(),
    ),
  );
}

class GuvenliSehrimApp extends StatelessWidget {
  const GuvenliSehrimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    
    return MaterialApp(
      title: 'Güvenli Şehrim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.outfit().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B4D8),
          brightness: Brightness.light,
          primary: const Color(0xFF0077B6),
          secondary: const Color(0xFF00B4D8),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.outfit().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B4D8),
          brightness: Brightness.dark,
          primary: const Color(0xFF90E0EF),
          secondary: const Color(0xFF00B4D8),
          surface: const Color(0xFF023E8A).withOpacity(0.1),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: const Color(0xFF03045E).withAlpha(120),
        ),
      ),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const DashboardScreen(),
    );
  }
}
