-- ========================================================
-- 03. Top 5 Best and Worst Trading Days by % Return
-- ========================================================

-- Daily Returns CTE
WITH daily_returns AS (
    SELECT 
        date,
        close,
        LAG(close) OVER (ORDER BY date) AS prev_close
    FROM ts_data_staging
)
-- Top 5 Best Days
SELECT 
    date,
    ROUND(((close - prev_close) / prev_close) * 100, 2) AS daily_return_pct
FROM daily_returns
WHERE prev_close IS NOT NULL
ORDER BY daily_return_pct DESC
LIMIT 5;

-- Top 5 Worst Days
WITH daily_returns AS (
    SELECT 
        date,
        close,
        LAG(close) OVER (ORDER BY date) AS prev_close
    FROM ts_data_staging
)

SELECT 
    date,
    ROUND(((close - prev_close) / prev_close) * 100, 2) AS daily_return_pct
FROM daily_returns
WHERE prev_close IS NOT NULL
ORDER BY daily_return_pct ASC
LIMIT 5;