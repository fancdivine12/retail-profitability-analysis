-- Retail Profitability Analysis
-- Tool: BigQuery SQL
-- Purpose:
-- Validate the dataset and analyze sales, profit, profit margin,
-- regions, categories, sub-categories, customer segments, and discount impact.

-- Project: profitability-analysis-495801
-- Dataset: retail_analysis
-- Main clean view/table: orders_clean


-- =========================================================
-- 1. CREATE CLEAN VIEW
-- Purpose: Rename columns into SQL-friendly snake_case names
-- =========================================================

CREATE OR REPLACE VIEW `profitability-analysis-495801.retail_analysis.orders_clean` AS
SELECT
  `Order Date` AS order_date,
  `Ship Date` AS ship_date,
  `Ship Mode` AS ship_mode,
  `Customer ID` AS customer_id,
  `Customer Name` AS customer_name,
  Segment AS segment,
  Country_Region AS country_region,
  City AS city,
  State_Province AS state_province,
  `Postal Code` AS postal_code,
  Region AS region,
  `Product ID` AS product_id,
  Category AS category,
  `Sub-Category` AS sub_category,
  `Product Name` AS product_name,
  Sales AS sales,
  Quantity AS quantity,
  Discount AS discount,
  Profit AS profit
FROM `profitability-analysis-495801.retail_analysis.orders`;


-- =========================================================
-- 2. PREVIEW CLEAN DATA
-- Purpose: Confirm the clean view displays the data correctly
-- =========================================================

SELECT
  *
FROM `profitability-analysis-495801.retail_analysis.orders_clean`
LIMIT 10;


-- =========================================================
-- 3. ROW COUNT CHECK
-- Purpose: Confirm total number of records
-- =========================================================

SELECT
  COUNT(*) AS total_rows
FROM `profitability-analysis-495801.retail_analysis.orders_clean`;


-- =========================================================
-- 4. DATA QUALITY CHECK
-- Purpose: Check for missing values in key analysis fields
-- =========================================================

SELECT
  COUNT(*) AS total_rows,
  COUNTIF(region IS NULL) AS missing_region,
  COUNTIF(category IS NULL) AS missing_category,
  COUNTIF(sub_category IS NULL) AS missing_sub_category,
  COUNTIF(segment IS NULL) AS missing_segment,
  COUNTIF(sales IS NULL) AS missing_sales,
  COUNTIF(profit IS NULL) AS missing_profit
FROM `profitability-analysis-495801.retail_analysis.orders_clean`;


-- =========================================================
-- 5. PROFITABILITY BY CATEGORY
-- Purpose: Identify which product categories drive sales and profit
-- =========================================================

SELECT
  category,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100, 2) AS profit_margin_pct
FROM `profitability-analysis-495801.retail_analysis.orders_clean`
GROUP BY category
ORDER BY total_profit DESC;


-- =========================================================
-- 6. PROFITABILITY BY SUB-CATEGORY
-- Purpose: Identify sub-categories with the strongest and weakest profit
-- =========================================================

SELECT
  sub_category,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100, 2) AS profit_margin_pct
FROM `profitability-analysis-495801.retail_analysis.orders_clean`
GROUP BY sub_category
ORDER BY total_profit ASC;


-- =========================================================
-- 7. LOSS-DRIVING SUB-CATEGORIES
-- Purpose: Show only sub-categories with negative total profit
-- =========================================================

SELECT
  sub_category,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100, 2) AS profit_margin_pct
FROM `profitability-analysis-495801.retail_analysis.orders_clean`
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


-- =========================================================
-- 8. PROFITABILITY BY REGION
-- Purpose: Compare sales, profit, and margin across regions
-- =========================================================

SELECT
  region,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100, 2) AS profit_margin_pct
FROM `profitability-analysis-495801.retail_analysis.orders_clean`
GROUP BY region
ORDER BY total_profit DESC;


-- =========================================================
-- 9. PROFITABILITY BY CUSTOMER SEGMENT
-- Purpose: Compare sales, profit, and margin by customer segment
-- =========================================================

SELECT
  segment,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100, 2) AS profit_margin_pct
FROM `profitability-analysis-495801.retail_analysis.orders_clean`
GROUP BY segment
ORDER BY total_profit DESC;


-- =========================================================
-- 10. DISCOUNT IMPACT BY SUB-CATEGORY
-- Purpose: Review whether higher discounts are connected to weaker profit
-- Note: This shows a relationship, not proven causation.
-- =========================================================

SELECT
  sub_category,
  ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100, 2) AS profit_margin_pct
FROM `profitability-analysis-495801.retail_analysis.orders_clean`
GROUP BY sub_category
ORDER BY avg_discount_pct DESC;


-- =========================================================
-- 11. HIGH SALES BUT WEAK PROFIT
-- Purpose: Identify sub-categories with above-average sales but weaker margins
-- =========================================================

WITH subcategory_summary AS (
  SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100 AS profit_margin_pct
  FROM `profitability-analysis-495801.retail_analysis.orders_clean`
  GROUP BY sub_category
)

SELECT
  sub_category,
  ROUND(total_sales, 2) AS total_sales,
  ROUND(total_profit, 2) AS total_profit,
  ROUND(profit_margin_pct, 2) AS profit_margin_pct
FROM subcategory_summary
WHERE total_sales > (
  SELECT AVG(total_sales)
  FROM subcategory_summary
)
ORDER BY profit_margin_pct ASC;


-- =========================================================
-- 12. OVERALL BUSINESS PERFORMANCE
-- Purpose: Summarize total sales, total profit, and overall profit margin
-- =========================================================

SELECT
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(sales)) * 100, 2) AS overall_profit_margin_pct
FROM `profitability-analysis-495801.retail_analysis.orders_clean`;
