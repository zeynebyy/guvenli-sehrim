const axios = require('axios');

const getNamazVakitleri = async (city = 'Istanbul') => {
    try {
        const url = `https://api.aladhan.com/v1/timingsByCity?city=${encodeURIComponent(city)}&country=Turkey&method=13`;
        const response = await axios.get(url);
        
        // Aladhan returns { code: 200, status: 'OK', data: { timings: {...}, date: {...}, meta: {...} } }
        return response.data.data;
    } catch (error) {
        console.error('Namaz Fetch Error:', error);
        throw new Error('Namaz vakitleri servisine ulaşılamadı');
    }
};

module.exports = { getNamazVakitleri };
