-- ========================================================
-- 02. Overall Summary Statistics
-- ========================================================

SELECT
    MIN(open) AS overall_min_open,
    MAX(open) AS overall_max_open,
    ROUND(AVG(open), 2) AS overall_avg_open,
    MIN(close) AS overall_min_close,
    MAX(close) AS overall_max_close,
    ROUND(AVG(close), 2) AS overall_avg_close,
    MIN(volume) AS overall_min_volume,
    MAX(volume) AS overall_max_volume,
    ROUND(AVG(volume), 2) AS overall_avg_volume,
    SUM(volume) AS total_volume_traded
FROM ts_data_staging;