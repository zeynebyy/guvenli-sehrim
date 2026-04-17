const cache = require('../utils/cache');
const logger = require('../utils/logger');

const cacheMiddleware = (keyGenerator, ttl) => {
    return (req, res, next) => {
        const cacheKey = typeof keyGenerator === 'function' ? keyGenerator(req) : keyGenerator;
        const cachedData = cache.get(cacheKey);

        if (cachedData) {
            logger.info(`Cache hit for key: ${cacheKey}`);
            return res.status(200).json({ source: 'cache', data: cachedData });
        }

        const originalJson = res.json;
        res.json = function (body) {
            // Only cache if successful and not already from cache (to avoid double wrapping)
            if (res.statusCode >= 200 && res.statusCode < 300) {
                // We assume body is the raw data when it comes from the API route handler
                // Routes will now send raw data to res.json, and we wrap it here or in the route
                // Wait, if the route does res.json({ source: 'api', data }), cache.set stores that.
                // Let's decide: Routes always return raw data, middleware wraps it.
                cache.set(cacheKey, body, ttl);
            }
            return originalJson.call(this, { source: 'api', data: body });
        };

        next();
    };
};

module.exports = cacheMiddleware;
