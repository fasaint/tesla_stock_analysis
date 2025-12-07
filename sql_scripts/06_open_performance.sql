-- ========================================================
-- Question 6: Performance vs. Market Open
-- Why: Determines if the stock tends to perform better or worse
--      on days when it opens higher or lower than the previous day's close.
-- ========================================================

WITH daily_returns AS (
    SELECT
        date,
        open,
        close,
        LAG(close) OVER (ORDER BY date) AS prev_close,
        ((close - LAG(close) OVER (ORDER BY date)) / LAG(close) OVER (ORDER BY date)) * 100 AS daily_return_pct
    FROM ts_data_staging
)
SELECT
    ROUND(AVG(CASE WHEN open > prev_close THEN daily_return_pct END), 2) AS avg_return_on_open_up_days,
    ROUND(AVG(CASE WHEN open < prev_close THEN daily_return_pct END), 2) AS avg_return_on_open_down_days
FROM daily_returns
WHERE prev_close IS NOT NULL;