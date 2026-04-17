const cron = require('node-cron');
const mgmService = require('../services/mgm.service');
const logger = require('../utils/logger');
const cache = require('../utils/cache');

// 15 dakika
const schedule = () => {
    cron.schedule('*/15 * * * *', async () => {
        try {
            logger.info('[Job] Fetching MGM data...');
            const defaultCity = 'istanbul';
            const data = await mgmService.getHavaDurumu(defaultCity);
            cache.set(`hava_${defaultCity}`, data, 1800);
        } catch (error) {
            logger.error('[Job] MGM error:', error);
        }
    });
};

module.exports = { schedule };
