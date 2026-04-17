const cron = require('node-cron');
const tcmbService = require('../services/tcmb.service');
const logger = require('../utils/logger');
const cache = require('../utils/cache');

// 1 saat
const schedule = () => {
    cron.schedule('0 * * * *', async () => {
        try {
            logger.info('[Job] Fetching TCMB data...');
            const data = await tcmbService.getDovizKurlari();
            cache.set('doviz', data, 3600);
        } catch (error) {
            logger.error('[Job] TCMB error:', error);
        }
    });
};

module.exports = { schedule };
