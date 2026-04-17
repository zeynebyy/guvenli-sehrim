class AppKeys {
  static const String dashboardDepremCard = 'dashboard_deprem_card';
  static const String dashboardHavaCard = 'dashboard_hava_card';
  static const String dashboardAqiCard = 'dashboard_aqi_card';
  static const String dashboardNamazCard = 'dashboard_namaz_card';
  static const String dashboardDovizCard = 'dashboard_doviz_card';
  static const String dashboardKonumText = 'dashboard_konum_text';
  static const String dashboardRefresh = 'dashboard_refresh';
  static const String dashboardOfflineBanner = 'dashboard_offline_banner';

  static const String navDashboard = 'nav_dashboard';
  static const String navDeprem = 'nav_deprem';
  static const String navHava = 'nav_hava';
  static const String navAqi = 'nav_aqi';
  static const String navNamaz = 'nav_namaz';
  static const String navDoviz = 'nav_doviz';
  static const String navAyarlar = 'nav_ayarlar';

  static const String depremMap = 'deprem_map';
  static const String depremList = 'deprem_list';
  static const String havaTempText = 'hava_temp_text';
  static const String havaDurumText = 'hava_durum_text';
  static const String aqiValueText = 'aqi_value_text';
  static const String aqiDurumText = 'aqi_durum_text';
  static const String namazVakitText = 'namaz_vakit_text';
  static const String namazKalanText = 'namaz_kalan_text';
  static const String dovizList = 'doviz_list';
  static const String dovizKurPrefix = 'doviz_kur_';
  static const String ayarlarTemaSwitch = 'ayarlar_tema_switch';
  static const String ayarlarSehirSecimi = 'ayarlar_sehir_secimi';
  static const String ayarlarCacheTemizle = 'ayarlar_cache_temizle';
  
  // Dynamic keys for list items
  static String depremItem(String id) => 'deprem_item_$id';
}
