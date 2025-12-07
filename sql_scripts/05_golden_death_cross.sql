-- ========================================================
-- Question 5: Strategy Signal Generation (Golden / Death Cross)
-- Why: Golden Cross (50-day SMA crosses above 200-day SMA) signals potential bullish trend,
--      Death Cross (50-day SMA crosses below 200-day SMA) signals potential bearish trend.
-- ========================================================

WITH moving_averages AS (
    SELECT
        date,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS sma_50,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS sma_200
    FROM ts_data_staging
),
cross_check AS (
    SELECT
        date,
        sma_50,
        sma_200,
        LAG(CASE WHEN sma_50 > sma_200 THEN 1 ELSE 0 END) OVER (ORDER BY date) AS was_bullish_yesterday,
        CASE WHEN sma_50 > sma_200 THEN 1 ELSE 0 END AS is_bullish_today
    FROM moving_averages
    WHERE sma_200 IS NOT NULL
)
SELECT
    date,
    CASE
        WHEN is_bullish_today = 1 AND was_bullish_yesterday = 0 THEN 'Golden Cross'
        WHEN is_bullish_today = 0 AND was_bullish_yesterday = 1 THEN 'Death Cross'
        ELSE NULL
    END AS cross_signal
FROM cross_check
WHERE (is_bullish_today = 1 AND was_bullish_yesterday = 0)
   OR (is_bullish_today = 0 AND was_bullish_yesterday = 1)
ORDER BY date;
