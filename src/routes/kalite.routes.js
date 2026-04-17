const express = require('express');
const router = express.Router();
const ibbService = require('../services/ibb.service');
const checkCache = require('../middleware/cache.middleware');

// Cache for 15 minutes (900 sec)
const keyGen = (req) => `kalite_${req.query.il || 'istanbul'}`;

router.get('/', checkCache(keyGen, 900), async (req, res, next) => {
    try {
        const il = req.query.il || 'istanbul';
        const data = await ibbService.getHavaKalite(il);
        res.json(data);
    } catch (err) {
        next(err);
    }
});

module.exports = router;
