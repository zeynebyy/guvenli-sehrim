const axios = require('axios');

const getDepremler = async () => {
    try {
        const response = await axios.get('https://api.orhanaydogdu.com.tr/deprem/kandilli/live');
        // The API returns { status: true, httpStatus: 200, serverload: ..., result: [...] }
        return response.data.result; 
    } catch (error) {
        console.error('Deprem Fetch Error:', error);
        throw new Error('Deprem servisinden veri alınamadı');
    }
};

module.exports = { getDepremler };
