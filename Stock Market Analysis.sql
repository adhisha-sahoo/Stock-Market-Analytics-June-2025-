create database Stock_Market;
use Stock_Market;
CREATE TABLE stock_market_data (
    trade_date DATE,
    ticker VARCHAR(10),
    open_price DECIMAL(10, 2),
    close_price DECIMAL(10, 2),
    high_price DECIMAL(10, 2),
    low_price DECIMAL(10, 2),
    volume_traded BIGINT,
    market_cap BIGINT,
    pe_ratio DECIMAL(10, 2),
    dividend_yield DECIMAL(5, 2),
    eps DECIMAL(10, 2),
    week_52_high DECIMAL(10, 2),
    week_52_low DECIMAL(10, 2),
    sector VARCHAR(50)
);
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE "secure_file_priv";
ALTER TABLE stock_market_data MODIFY trade_date VARCHAR(20);
LOAD stock_market_data DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stock_market_june2025.csv'
INTO TABLE stock_market_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW COLUMNS FROM stock_market_data;

SELECT 
  STR_TO_DATE(s.trade_date, '%d-%m-%Y') AS trade_dt,
  s.*
FROM stock_market_data s;

/*Latest Prices per ticker*/
WITH ranked_data AS (
  SELECT *,
         STR_TO_DATE(trade_date, '%d-%m-%Y') AS trade_dt,
         ROW_NUMBER() OVER (
           PARTITION BY ticker
           ORDER BY STR_TO_DATE(trade_date, '%d-%m-%Y') DESC
         ) AS rn
  FROM stock_market_data
)
SELECT
  ticker,
  trade_dt AS latest_date,
  close_price,
  volume_traded,
  market_cap
FROM ranked_data
WHERE rn = 1;

/*Daily % Change in Close Price*/
SELECT 
  ticker,
  STR_TO_DATE(trade_date, '%d-%m-%Y') AS trade_dt,
  close_price,
  LAG(close_price) OVER (PARTITION BY ticker ORDER BY STR_TO_DATE(trade_date, '%d-%m-%Y')) AS prev_close,
  ROUND(
    ((close_price - LAG(close_price) OVER (PARTITION BY ticker ORDER BY STR_TO_DATE(trade_date, '%d-%m-%Y'))) / 
     LAG(close_price) OVER (PARTITION BY ticker ORDER BY STR_TO_DATE(trade_date, '%d-%m-%Y'))) * 100,
    2
  ) AS daily_change_pct
FROM stock_market_data;

/*Volatility (High - Low) per Day*/
SELECT 
  ticker,
  STR_TO_DATE(trade_date, '%d-%m-%Y') AS trade_dt,
  ROUND((high_price - low_price), 2) AS daily_volatility
FROM stock_market_data;

/*PE Ratio & EPS by Sector*/
SELECT 
  sector,
  ROUND(AVG(pe_ratio), 2) AS avg_pe_ratio,
  ROUND(AVG(eps), 2) AS avg_eps
FROM stock_market_data
GROUP BY sector;

/*Top 5 by Market Cap (Most Recent Day)*/
WITH latest_data AS (
  SELECT *,
         STR_TO_DATE(trade_date, '%d-%m-%Y') AS trade_dt
  FROM stock_market_data
)
SELECT 
  ticker,
  trade_dt,
  market_cap
FROM latest_data
WHERE trade_dt = (SELECT MAX(STR_TO_DATE(trade_date, '%d-%m-%Y')) FROM stock_market_data)
ORDER BY market_cap DESC
LIMIT 5;

/*6. Sector-Wise Market Cap*/
SELECT 
  sector,
  ROUND(SUM(market_cap)/1e9, 2) AS total_market_cap_billion
FROM stock_market_data
WHERE STR_TO_DATE(trade_date, '%d-%m-%Y') = (
  SELECT MAX(STR_TO_DATE(trade_date, '%d-%m-%Y')) FROM stock_market_data
)
GROUP BY sector
ORDER BY total_market_cap_billion DESC;

/*52-Week Distance from Close Price*/
SELECT 
  ticker,
  close_price,
  week_52_low,
  week_52_high,
  ROUND(((close_price - week_52_low) / week_52_low) * 100, 2) AS from_low_pct,
  ROUND(((week_52_high - close_price) / week_52_high) * 100, 2) AS to_high_pct
FROM stock_market_data
WHERE STR_TO_DATE(trade_date, '%d-%m-%Y') = (
  SELECT MAX(STR_TO_DATE(trade_date, '%d-%m-%Y')) FROM stock_market_data
);

/*Top 10 Dividend Yield Stocks*/
SELECT 
  ticker,
  sector,
  dividend_yield
FROM stock_market_data
WHERE STR_TO_DATE(trade_date, '%d-%m-%Y') = (
  SELECT MAX(STR_TO_DATE(trade_date, '%d-%m-%Y')) FROM stock_market_data
)
ORDER BY dividend_yield DESC
LIMIT 10;

/*Average Volume in Last 7 Days (Per Ticker)*/
WITH recent_7 AS (
  SELECT 
    ticker,
    volume_traded,
    STR_TO_DATE(trade_date, '%d-%m-%Y') AS trade_dt,
    ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY STR_TO_DATE(trade_date, '%d-%m-%Y') DESC) AS rn
  FROM stock_market_data
)
SELECT 
  ticker,
  ROUND(AVG(volume_traded), 0) AS avg_7_day_volume
FROM recent_7
WHERE rn <= 7
GROUP BY ticker;






