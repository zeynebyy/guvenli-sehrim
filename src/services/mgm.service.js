const axios = require('axios');

const getHavaDurumu = async (il = 'istanbul') => {
    try {
        // 1. Geocoding: Get coordinates from city name
        const geoUrl = `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(il)}&count=1&language=tr`;
        const geoRes = await axios.get(geoUrl);
        
        if (!geoRes.data.results || geoRes.data.results.length === 0) {
            throw new Error(`Şehir bulunamadı: ${il}`);
        }
        
        const { latitude, longitude, name } = geoRes.data.results[0];

        // 2. Weather: Get forecast and current weather
        // Using Open-Meteo Forecast API
        const weatherUrl = `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto`;
        const weatherRes = await axios.get(weatherUrl);

        return {
            city: name,
            latitude,
            longitude,
            current: weatherRes.data.current_weather,
            daily: weatherRes.data.daily,
            units: weatherRes.data.daily_units
        };
    } catch (error) {
        console.error('Weather Fetch Error:', error);
        throw new Error('Hava durumu servisinden veri alınamadı');
    }
};

module.exports = { getHavaDurumu };
