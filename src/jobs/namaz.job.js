const cron = require('node-cron');
const namazService = require('../services/namaz.service');
const logger = require('../utils/logger');
const cache = require('../utils/cache');

// Günde 1 (her gece 00:00'da)
const schedule = () => {
    cron.schedule('0 0 * * *', async () => {
        try {
            logger.info('[Job] Fetching Namaz data...');
            const country = 'Turkey';
            const region = 'Istanbul';
            const city = 'Istanbul';
            const data = await namazService.getNamazVakitleri(country, region, city);
            cache.set(`namaz_${country}_${region}_${city}`, data, 43200);
        } catch (error) {
            logger.error('[Job] Namaz error:', error);
        }
    });
};

module.exports = { schedule };
