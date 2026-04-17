# Güvenli Şehrim Backend 🛡️

Türkiye vatandaşları için tasarlanan "Güvenli Şehrim" mobil uygulamasına veri sağlayan, yüksek performanslı ve güvenilir API Gateway.

## 🚀 Özellikler

- **Multi-Service Integration:** 5 farklı kamu API'sini (AFAD, MGM, İBB, TCMB, Namaz Vakitleri) tek bir noktada birleştirir.
- **Smart Caching:** `node-cache` ile her servis için optimize edilmiş TTL süreleri.
- **Scheduled Jobs:** `node-cron` ile verilerin arka planda otomatik güncellenmesi.
- **Professional Logging:** `winston` ile hata ve aktivite takibi.
- **Security:** `helmet` ve `cors` ile güvenli başlıklar.
- **Production Ready:** Docker desteği ve modüler yapı.

## 🛠️ Teknoloji Yığını

- Node.js 20
- Express.js
- Axios
- Winston (Logging)
- Node-Cache
- Node-Cron
- XML2JS (TCMB XML Parsing)

## 📦 Kurulum

1. Bağımlılıkları yükleyin:
   ```bash
   npm install
   ```

2. `.env` dosyasını kontrol edin ve port/URL ayarlarını yapın.

3. Uygulamayı başlatın:
   ```bash
   npm start
   ```

## 📍 API Endpoint'leri

- `GET /deprem`: AFAD güncel deprem verileri.
- `GET /hava`: Meteoroloji Genel Müdürlüğü hava durumu.
- `GET /kalite`: İBB Hava Kalite (AQI) verileri.
- `GET /namaz`: Namaz vakitleri.
- `GET /doviz`: TCMB güncel döviz kurları.
- `GET /sistem`: Sistem durumu, uptime ve zaman bilgisi.

## 🐳 Docker

```bash
docker build -t guvenli-sehrim-backend .
docker run -p 5001:5001 guvenli-sehrim-backend
```

## 🎯 Gelişmiş Özellikler

- **Middleware Cache:** Hem API çağrılarında hem de cron job'larda tutarlı cache yönetimi.
- **Error Handling:** Global error middleware ile standart hata formatı.
- **Uptime Monitoring:** `/sistem` endpoint'i ile servis sağlığı takibi.
