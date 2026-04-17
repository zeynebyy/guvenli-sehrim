require('dotenv').config();
const app = require('./app');
const initJobs = require('./jobs');
const logger = require('./utils/logger');

const PORT = process.env.PORT || 5000;

try {
    initJobs();
    app.listen(PORT, () => {
        logger.info(`Server is running on port ${PORT}`);
    });
} catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
}
