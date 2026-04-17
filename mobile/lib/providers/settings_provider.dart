import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  final Box _box = Hive.box('settings');
  
  bool get isDarkMode => _box.get('darkMode', defaultValue: false);
  String get selectedCity => _box.get('city', defaultValue: 'Istanbul');
  
  void toggleTheme() {
    _box.put('darkMode', !isDarkMode);
    notifyListeners();
  }
  
  void setCity(String city) {
    _box.put('city', city);
    notifyListeners();
  }
  
  Future<void> clearCache() async {
    await Hive.box('cache_deprem').clear();
    await Hive.box('cache_hava').clear();
    await Hive.box('cache_aqi').clear();
    await Hive.box('cache_namaz').clear();
    await Hive.box('cache_doviz').clear();
  }
}
