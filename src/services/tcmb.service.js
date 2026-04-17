const axios = require('axios');
const xml2js = require('xml2js');

const getDovizKurlari = async () => {
    try {
        const response = await axios.get(process.env.TCMB_API_URL);
        const parser = new xml2js.Parser({ explicitArray: false });
        const result = await parser.parseStringPromise(response.data);
        return result.Tarih_Date.Currency; // Return clean currency list
    } catch (error) {
        throw new Error('TCMB servisinden döviz verisi alınamadı');
    }
};

module.exports = { getDovizKurlari };
