const express = require('express');
const router = express.Router();
const namazService = require('../services/namaz.service');
const checkCache = require('../middleware/cache.middleware');

// Cache for 12 hours (43200 sec)
const keyGen = (req) => `namaz_${req.query.city || 'istanbul'}`;

router.get('/', checkCache(keyGen, 43200), async (req, res, next) => {
    try {
        const city = req.query.city || 'istanbul';
        const data = await namazService.getNamazVakitleri(city);
        res.json(data);
    } catch (err) {
        next(err);
    }
});

module.exports = router;
