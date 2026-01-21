/* ============================================================
   sales_analysis.sql
   Purpose: Sales performance KPIs and trends for dashboards
   Target: Junior Data Analyst portfolio (Power BI + SQL)
   Assumes a table named: sales_orders
   ============================================================ */

-- 0) Quick sanity checks
SELECT
  COUNT(*) AS row_count,
  MIN(order_date) AS min_order_date,
  MAX(order_date) AS max_order_date
FROM sales_orders;

-- 1) Executive KPIs: revenue, orders, units, profit, AOV
SELECT
  SUM(sales) AS total_revenue,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(quantity) AS total_units,
  SUM(profit) AS total_profit,
  CASE
    WHEN COUNT(DISTINCT order_id) = 0 THEN 0
    ELSE SUM(sales) / COUNT(DISTINCT order_id)
  END AS avg_order_value
FROM sales_orders;

-- 2) Monthly revenue & profit trend
-- (Use DATE_TRUNC if supported; otherwise see alternate below.)
SELECT
  DATE_TRUNC('month', order_date) AS month_start,
  SUM(sales) AS revenue,
  SUM(profit) AS profit,
  COUNT(DISTINCT order_id) AS orders
FROM sales_orders
GROUP BY 1
ORDER BY 1;

-- 2b) Alternate if DATE_TRUNC is not supported (e.g., some SQL Server versions)
-- SELECT
--   DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
--   SUM(sales) AS revenue,
--   SUM(profit) AS profit,
--   COUNT(DISTINCT order_id) AS orders
-- FROM sales_orders
-- GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
-- ORDER BY month_start;

-- 3) Revenue by region
SELECT
  region,
  SUM(sales) AS revenue,
  SUM(profit) AS profit,
  COUNT(DISTINCT order_id) AS orders
FROM sales_orders
GROUP BY region
ORDER BY revenue DESC;

-- 4) Revenue by category and sub-category
SELECT
  category,
  sub_category,
  SUM(sales) AS revenue,
  SUM(profit) AS profit,
  SUM(quantity) AS units
FROM sales_orders
GROUP BY category, sub_category
ORDER BY category, revenue DESC;

-- 5) Top 10 products by revenue
SELECT
  product_name,
  SUM(sales) AS revenue,
  SUM(profit) AS profit,
  SUM(quantity) AS units
FROM sales_orders
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

-- 6) Discount impact (simple view)
SELECT
  CASE
    WHEN discount = 0 THEN '0%'
    WHEN discount > 0 AND discount <= 0.10 THEN '0–10%'
    WHEN discount > 0.10 AND discount <= 0.20 THEN '10–20%'
    WHEN discount > 0.20 AND discount <= 0.30 THEN '20–30%'
    ELSE '30%+'
  END AS discount_band,
  COUNT(*) AS line_count,
  SUM(sales) AS revenue,
  SUM(profit) AS profit,
  AVG(discount) AS avg_discount
FROM sales_orders
GROUP BY 1
ORDER BY 1;

-- 7) Shipping time distribution (days between order and ship)
SELECT
  (ship_date - order_date) AS ship_days,
  COUNT(*) AS line_count
FROM sales_orders
WHERE ship_date IS NOT NULL
GROUP BY (ship_date - order_date)
ORDER BY ship_days;

-- 8) Customer concentration: top customers share
WITH customer_rev AS (
  SELECT
    customer_id,
    customer_name,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    COUNT(DISTINCT order_id) AS orders
  FROM sales_orders
  GROUP BY customer_id, customer_name
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn,
    SUM(revenue) OVER () AS total_revenue
  FROM customer_rev
)
SELECT
  rn,
  customer_id,
  customer_name,
  revenue,
  profit,
  orders,
  revenue / NULLIF(total_revenue, 0) AS revenue_share
FROM ranked
WHERE rn <= 20
ORDER BY rn;

