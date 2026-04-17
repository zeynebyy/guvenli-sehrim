const express = require('express');
const router = express.Router();
const afadService = require('../services/afad.service');
const checkCache = require('../middleware/cache.middleware');

// Cache for 5 minutes (300 sec)
router.get('/', checkCache('deprem', 300), async (req, res, next) => {
    try {
        const data = await afadService.getDepremler();
        res.json(data);
    } catch (err) {
        next(err);
    }
});

module.exports = router;
