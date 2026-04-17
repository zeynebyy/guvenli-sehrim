const errorHandler = (err, req, res, next) => {
    console.error(`[Error]: ${err.message}`);
    
    const statusCode = err.statusCode || 500;
    res.status(statusCode).json({
        status: 'error',
        statusCode,
        message: err.message || 'Sunucu içi hata (Internal Server Error)'
    });
};

module.exports = errorHandler;
