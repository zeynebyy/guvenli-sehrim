const cron = require('node-cron');
const ibbService = require('../services/ibb.service');
const logger = require('../utils/logger');
const cache = require('../utils/cache');

// 10 dakika
const schedule = () => {
    cron.schedule('*/10 * * * *', async () => {
        try {
            logger.info('[Job] Fetching IBB AQI data...');
            const data = await ibbService.getHavaKalite();
            cache.set('kalite', data, 900);
        } catch (error) {
            logger.error('[Job] IBB error:', error);
        }
    });
};

module.exports = { schedule };
