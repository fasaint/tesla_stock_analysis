-- ========================================================
-- 01. Daily Trading Range
-- ========================================================

SELECT 
    date,
    high,
    low,
    high - low AS daily_trading_range
FROM ts_data_staging
ORDER BY date;