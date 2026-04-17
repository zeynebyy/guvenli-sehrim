import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_keys.dart';
import '../providers/settings_provider.dart';

class AyarlarScreen extends StatelessWidget {
  const AyarlarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('GENEL AYARLAR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          SwitchListTile(
            key: const Key(AppKeys.ayarlarTemaSwitch),
            title: const Text('Karanlık Mod'),
            secondary: const Icon(Icons.brightness_4),
            value: provider.isDarkMode,
            onChanged: (val) => provider.toggleTheme(),
          ),
          ListTile(
            key: const Key(AppKeys.ayarlarSehirSecimi),
            title: const Text('Şehir Seçimi'),
            subtitle: Text(provider.selectedCity),
            leading: const Icon(Icons.location_city),
            onTap: () => _showCityPicker(context, provider),
          ),
          const Divider(),
          const ListTile(
            title: Text('SİSTEM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          ListTile(
            key: const Key(AppKeys.ayarlarCacheTemizle),
            title: const Text('Önbelleği Temizle'),
            leading: const Icon(Icons.delete_sweep),
            onTap: () async {
              await provider.clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Önbellek temizlendi')));
              }
            },
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'Güvenli Şehrim',
            applicationVersion: '1.0.0',
            aboutBoxChildren: [
              Text('Bu uygulama Türkiye vatandaşları için çevresel güvenlik verileri sunar.'),
            ],
          ),
        ],
      ),
    );
  }

  void _showCityPicker(BuildContext context, SettingsProvider provider) {
    final cities = ['Istanbul', 'Ankara', 'Izmir', 'Bursa', 'Antalya', 'Adana'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(cities[index]),
              onTap: () {
                provider.setCity(cities[index]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
