# 📊 Stock Market Analytics & Screener Dashboard (Power BI + SQL)

This project is an end-to-end analytics solution for stock market data, combining SQL for backend data transformation and Power BI for intuitive, interactive dashboards. It demonstrates skills in data wrangling, financial analytics, and business intelligence—tailored for global analytics and reporting roles.

---

## 🧠 Project Objectives

- Clean and prepare raw equity market data using SQL
- Analyze valuation metrics like PE ratio, EPS, and Market Cap
- Build a multi-page Power BI dashboard using the raw CSV file
- Enable dynamic exploration of stock performance and sector trends

---

## 🛢️ Section 1: SQL – Data Preparation & Analysis

> **Note:** SQL was used for backend data cleaning and analysis, not as a live data source for the Power BI dashboard.

### 🔸 Tools & Source
- **RDBMS:** MySQL 8.0  
- **Data Source:** `stock_market_june2025.csv`  
- **Schema:** Fields include `trade_date`, `ticker`, `close_price`, `volume_traded`, `pe_ratio`, `eps`, `sector`, etc.

### 🔸 Key SQL Operations Performed
- Created a database and table for the stock data
- Handled date conversion from `VARCHAR` to `DATE` using `STR_TO_DATE`
- Loaded the dataset via `LOAD DATA INFILE` (after adjusting secure file privileges)
- Applied analytical queries for:

  - Latest closing prices per ticker
  - Daily % change in price
  - Volatility (high - low)
  - Sector-wise average PE ratio and EPS
  - Top companies by market cap and dividend yield
  - 52-week high/low comparison
  - 7-day average trading volume

### 🔸 Purpose of SQL Layer
- Practice building reporting-ready datasets
- Apply window functions, CTEs, and financial aggregations
- Prepare for integration in future BI pipelines or live connections

---

## 📈 Section 2: Power BI – Dashboard Design & Storytelling

> **Note:** Power BI dashboards were created using the cleaned `.csv` file directly (not SQL integration).

### 🖼️ Page 1: Stock Overview

- **Interactive Table** with one row per ticker showing:
  - `Ticker`, `Sector`, `Close Price`, `Market Cap`, `PE Ratio`, `EPS`
- **KPI Cards:** 
  - Total Market Cap, Average PE, Average EPS

---

### 📈 Page 2: Price Trends

- **Line Charts:**
  - `Close Price` over time
  - `Volume Traded` over time
- **Slicers:** 
  - Ticker filter
  - Sector filter

---

### 🧭 Page 3: Sector Performance

- **Bar Charts:**
  - Average PE Ratio by Sector
  - Total Market Cap by Sector
- **KPI Cards:**
  - Top Performing Sector
  - Lowest PE Sector

---

### 📊 Page 4: Valuation Comparison

- **Scatter Plot:**
  - `EPS` vs `PE Ratio`, sized by Market Cap
- **Bar Charts:**
  - Top 10 Stocks by PE Ratio
  - Top 10 Stocks by EPS

---

### 🔍 Page 5: Stock Screener & Insights

- **Slicers:**
  - Sector
  - Market Cap (slider)
  - PE Ratio (slider)
  - EPS (slider)

- **Visuals:**
  - Matrix: Sector × Ticker with Close Price values
  - Ranking Tables: Top 10 by Market Cap, PE Ratio, and EPS
  - Custom Tooltip: EPS, Dividend Yield, Market Cap on hover

---

## ✨ Design Highlights

- Consistent color theme using financial blues and growth/loss indicators  
- Custom tooltips for depth without clutter  
- Slicers and filters for dynamic, user-driven exploration  
- Page-level organization for clarity and professional presentation  
- Responsive layout suitable for stakeholder presentations

---

## ✅ Skills Demonstrated

- **SQL**: Joins, window functions, CTEs, aggregations, volatility analysis  
- **Power BI**: KPI cards, matrix, scatter plot, ranking tables, slicers, tooltips  
- **Finance**: Understanding of PE ratios, EPS, 52-week range, market cap, and dividend yield  
- **Storytelling**: Dashboard flow from overview → trends → sector view → screening

---

