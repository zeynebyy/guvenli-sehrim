const express = require('express');
const router = express.Router();
const tcmbService = require('../services/tcmb.service');
const checkCache = require('../middleware/cache.middleware');

// Cache for 1 hour (3600 sec)
router.get('/', checkCache('doviz', 3600), async (req, res, next) => {
    try {
        const data = await tcmbService.getDovizKurlari();
        res.json(data);
    } catch (err) {
        next(err);
    }
});

module.exports = router;
