const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const errorHandler = require('./middleware/error.middleware');

const depremRoutes = require('./routes/deprem.routes');
const havaRoutes = require('./routes/hava.routes');
const kaliteRoutes = require('./routes/kalite.routes');
const namazRoutes = require('./routes/namaz.routes');
const dovizRoutes = require('./routes/doviz.routes');
const sistemRoutes = require('./routes/sistem.routes');

const app = express();

// Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Routes
app.use('/deprem', depremRoutes);
app.use('/hava', havaRoutes);
app.use('/kalite', kaliteRoutes);
app.use('/namaz', namazRoutes);
app.use('/doviz', dovizRoutes);
app.use('/sistem', sistemRoutes);

// Generic 404
app.use((req, res, next) => {
    res.status(404).json({ status: 'error', message: 'Endpoint bulunamadı' });
});

// Error Handling Middleware
app.use(errorHandler);

module.exports = app;
