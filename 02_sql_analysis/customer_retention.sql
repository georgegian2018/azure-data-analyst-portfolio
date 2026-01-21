/* ============================================================
   customer_retention.sql
   Purpose: Repeat customers, retention proxy metrics, cohort-like
   Target: Junior Data Analyst portfolio (SQL + BI)
   Assumes a table named: sales_orders
   ============================================================ */

-- 1) Customers: first and last purchase dates + order count
WITH customer_orders AS (
  SELECT
    customer_id,
    customer_name,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS lifetime_revenue,
    SUM(profit) AS lifetime_profit
  FROM sales_orders
  GROUP BY customer_id, customer_name
)
SELECT
  *
FROM customer_orders
ORDER BY lifetime_revenue DESC;

-- 2) Repeat customer rate (customers with 2+ orders)
WITH customer_orders AS (
  SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
  FROM sales_orders
  GROUP BY customer_id
),
agg AS (
  SELECT
    COUNT(*) AS customers_total,
    SUM(CASE WHEN total_orders >= 2 THEN 1 ELSE 0 END) AS customers_repeat
  FROM customer_orders
)
SELECT
  customers_total,
  customers_repeat,
  customers_repeat * 1.0 / NULLIF(customers_total, 0) AS repeat_customer_rate
FROM agg;

-- 3) Monthly active customers + new customers per month
WITH base AS (
  SELECT
    customer_id,
    order_date,
    DATE_TRUNC('month', order_date) AS month_start
  FROM sales_orders
),
first_month AS (
  SELECT
    customer_id,
    MIN(DATE_TRUNC('month', order_date)) AS first_month_start
  FROM base
  GROUP BY customer_id
),
monthly AS (
  SELECT
    b.month_start,
    COUNT(DISTINCT b.customer_id) AS active_customers,
    SUM(CASE WHEN f.first_month_start = b.month_start THEN 1 ELSE 0 END) AS new_customers
  FROM base b
  JOIN first_month f
    ON f.customer_id = b.customer_id
  GROUP BY b.month_start
)
SELECT
  month_start,
  active_customers,
  new_customers,
  (active_customers - new_customers) AS returning_customers
FROM monthly
ORDER BY month_start;

-- 4) Simple cohort retention table (cohort month vs activity month)
WITH base AS (
  SELECT
    customer_id,
    DATE_TRUNC('month', order_date) AS activity_month
  FROM sales_orders
),
cohorts AS (
  SELECT
    customer_id,
    MIN(activity_month) AS cohort_month
  FROM base
  GROUP BY customer_id
),
cohort_activity AS (
  SELECT
    c.cohort_month,
    b.activity_month,
    COUNT(DISTINCT b.customer_id) AS customers_active
  FROM base b
  JOIN cohorts c
    ON c.customer_id = b.customer_id
  GROUP BY c.cohort_month, b.activity_month
),
cohort_size AS (
  SELECT
    cohort_month,
    COUNT(*) AS cohort_customers
  FROM cohorts
  GROUP BY cohort_month
)
SELECT
  ca.cohort_month,
  ca.activity_month,
  cs.cohort_customers,
  ca.customers_active,
  ca.customers_active * 1.0 / NULLIF(cs.cohort_customers, 0) AS retention_rate
FROM cohort_activity ca
JOIN cohort_size cs
  ON cs.cohort_month = ca.cohort_month
WHERE ca.activity_month >= ca.cohort_month
ORDER BY ca.cohort_month, ca.activity_month;
