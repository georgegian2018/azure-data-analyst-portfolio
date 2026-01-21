# SQL Queries Overview

This document provides an overview of the SQL queries included in this folder
and the business questions they address. The queries are designed to support
dashboarding and reporting use cases, particularly in Power BI.

---

## Included Queries

### `sales_analysis.sql`

Focuses on sales performance and operational KPIs, including:

- Total revenue, profit, order volume, and units sold
- Monthly revenue and profit trends
- Sales performance by region, category, and sub-category
- Average order value and executive-level KPIs
- Discount impact on profitability
- Shipping time distribution

These queries are suitable for executive dashboards and trend analysis.

---

### `customer_retention.sql`

Focuses on customer contribution and concentration metrics, including:

- Top customers by revenue
- Customer contribution to total revenue
- Order frequency per customer

These queries support customer segmentation and revenue concentration analysis.

---

## SQL + Python EDA Alignment

This SQL analysis mirrors the insights produced in the Python EDA notebook:

- **Monthly revenue trend** → `sales_analysis.sql` (Section 2)
- **Category & region performance** → Sections 3 & 4
- **Discount vs profit relationship** → Section 6
- **Customer revenue concentration** → Section 8
- **Operational KPIs** → Sections 0 & 1

All queries are written to be directly consumable by Power BI for reporting and dashboard creation.

---

## Notes

- Queries use standard SQL where possible
- Minor adaptations may be required depending on the database engine
  (Azure SQL, PostgreSQL, SQL Server)
- Queries are written to be readable, maintainable, and reusable
