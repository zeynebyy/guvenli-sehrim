const cron = require('node-cron');
const afadService = require('../services/afad.service');
const logger = require('../utils/logger');
const cache = require('../utils/cache');

// 2 dakika
const schedule = () => {
    cron.schedule('*/2 * * * *', async () => {
        try {
            logger.info('[Job] Fetching AFAD data...');
            const data = await afadService.getDepremler();
            cache.set('deprem', data, 300);
        } catch (error) {
            logger.error('[Job] AFAD error:', error);
        }
    });
};

module.exports = { schedule };
