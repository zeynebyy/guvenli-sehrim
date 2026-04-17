const express = require('express');
const router = express.Router();
const mgmService = require('../services/mgm.service');
const checkCache = require('../middleware/cache.middleware');

// Cache for 30 minutes (1800 sec)
const keyGen = (req) => `hava_${req.query.il || 'istanbul'}`;

router.get('/', checkCache(keyGen, 1800), async (req, res, next) => {
    try {
        const il = req.query.il || 'istanbul';
        const data = await mgmService.getHavaDurumu(il);
        res.json(data);
    } catch (err) {
        next(err);
    }
});

module.exports = router;
