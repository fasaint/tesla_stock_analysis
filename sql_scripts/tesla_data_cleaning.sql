-- ========================================================
-- Tesla Stock Data Cleaning & Standardization
-- Author: Oghenefejiro Godwin
-- Purpose: Clean and prepare Tesla stock data for analysis
-- Table: ts_data_staging
-- ========================================================

-- ========================================================
-- 1. Preview Original Data
-- ========================================================
SELECT *
FROM tesla_stock_data
LIMIT 10;

-- ========================================================
-- 2. Create Staging Table
-- This table will store the cleaned version of the dataset
-- ========================================================
CREATE TABLE IF NOT EXISTS ts_data_staging AS
SELECT *
FROM tesla_stock_data;

-- Preview staging table
SELECT *
FROM ts_data_staging
LIMIT 10;

-- ========================================================
-- 3. Standardize Data Types
-- Ensure proper types for analysis
-- ========================================================
ALTER TABLE ts_data_staging
    ALTER COLUMN "date" TYPE DATE USING CASE WHEN trim("date") = '' THEN NULL ELSE TO_DATE(trim("date"), 'YYYY-MM-DD') END,
    ALTER COLUMN "close" TYPE NUMERIC(12,2) USING NULLIF(REGEXP_REPLACE(trim(COALESCE("close"::text, '')), '[^0-9.-]', '', 'g'), '')::NUMERIC(12,2),
    ALTER COLUMN "high" TYPE NUMERIC(12,2) USING NULLIF(REGEXP_REPLACE(trim(COALESCE("high"::text, '')), '[^0-9.-]', '', 'g'), '')::NUMERIC(12,2),
    ALTER COLUMN "low" TYPE NUMERIC(12,2) USING NULLIF(REGEXP_REPLACE(trim(COALESCE("low"::text, '')), '[^0-9.-]', '', 'g'), '')::NUMERIC(12,2),
    ALTER COLUMN "open" TYPE NUMERIC(12,2) USING NULLIF(REGEXP_REPLACE(trim(COALESCE("open"::text, '')), '[^0-9.-]', '', 'g'), '')::NUMERIC(12,2),
    ALTER COLUMN "volume" TYPE BIGINT USING NULLIF(REGEXP_REPLACE(trim(COALESCE("volume"::text, '')), '[^0-9]', '', 'g'), '')::BIGINT;

-- ========================================================
-- 4. Check for Missing Values
-- ========================================================
SELECT
    SUM(CASE WHEN "date" IS NULL THEN 1 END) AS missing_date,
    SUM(CASE WHEN "close" IS NULL THEN 1 END) AS missing_close,
    SUM(CASE WHEN "high" IS NULL THEN 1 END) AS missing_high,
    SUM(CASE WHEN "low" IS NULL THEN 1 END) AS missing_low,
    SUM(CASE WHEN "open" IS NULL THEN 1 END) AS missing_open,
    SUM(CASE WHEN "volume" IS NULL THEN 1 END) AS missing_volume
FROM ts_data_staging;

-- ========================================================
-- 5. Identify Duplicate Rows
-- ========================================================
WITH duplicates AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY "date", "close", "high", "low", "open", "volume") AS row_num
    FROM ts_data_staging
)
SELECT *
FROM duplicates
WHERE row_num > 1;

-- ========================================================
-- 6. Consistency Checks
-- Check for zero prices which may indicate bad data
-- ========================================================
SELECT *
FROM ts_data_staging
WHERE "close" = 0 OR "high" = 0 OR "low" = 0 OR "open" = 0;

-- ========================================================
-- 7. Detect Outliers
-- Get min and max for numeric columns
-- ========================================================
SELECT
    MIN("close") AS min_close, MAX("close") AS max_close,
    MIN("high") AS min_high, MAX("high") AS max_high,
    MIN("low") AS min_low, MAX("low") AS max_low,
    MIN("open") AS min_open, MAX("open") AS max_open
FROM ts_data_staging;

-- ========================================================
-- 8. Integrity Checks
-- Ensure high >= open/close and low <= open/close
-- ========================================================
SELECT *
FROM ts_data_staging
WHERE "high" < GREATEST("open", "close")
   OR "low" > LEAST("open", "close");

-- ========================================================
-- 9. Preview Cleaned Data
-- ========================================================
SELECT *
FROM ts_data_staging
LIMIT 10;
