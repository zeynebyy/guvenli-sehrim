const axios = require('axios');

const getHavaKalite = async (il = 'istanbul') => {
    try {
        // 1. Geocoding
        const geoUrl = `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(il)}&count=1&language=tr`;
        const geoRes = await axios.get(geoUrl);
        
        if (!geoRes.data.results || geoRes.data.results.length === 0) {
            throw new Error(`Şehir bulunamadı: ${il}`);
        }
        
        const { latitude, longitude } = geoRes.data.results[0];

        // 2. AQI: Fetch PM2.5, PM10, NO2, SO2, O3
        const aqiUrl = `https://air-quality-api.open-meteo.com/v1/air-quality?latitude=${latitude}&longitude=${longitude}&current=european_aqi,pm10,pm2_5,nitrogen_dioxide,sulphur_dioxide,ozone`;
        const aqiRes = await axios.get(aqiUrl);

        return {
            latitude,
            longitude,
            current: aqiRes.data.current,
            units: aqiRes.data.current_units
        };
    } catch (error) {
        console.error('AQI Fetch Error:', error);
        throw new Error('Hava kalite servisinden veri alınamadı');
    }
};

module.exports = { getHavaKalite };
