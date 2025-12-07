-- ========================================================
-- Question 4: Market Trend Analysis
-- Why: Closing above the 50-day SMA suggests short-term momentum,
--      while closing below the 200-day SMA may indicate a long-term bearish trend.
-- ========================================================

WITH moving_averages AS (
    SELECT
        date,
        close,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS sma_50,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS sma_200
    FROM ts_data_staging
)
-- count day closing above 50 SMA
SELECT
    COUNT(*) AS days_above_50_sma,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM moving_averages WHERE sma_50 IS NOT NULL), 2) AS pct_time_above_50_sma
FROM moving_averages
WHERE close > sma_50 AND sma_50 IS NOT NULL;

WITH moving_averages AS (
    SELECT
        date,
        close,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS sma_50,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS sma_200
    FROM ts_data_staging
)
-- Last date the stock closed below 200-day SMA
SELECT 
    date, 
    close, 
    ROUND(sma_200, 2) AS sma_200
FROM moving_averages
WHERE close < sma_200
ORDER BY date DESC
LIMIT 1;
