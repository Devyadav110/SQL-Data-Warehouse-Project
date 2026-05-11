/*
===============================================================================
Customer Report
===============================================================================
Purpose:
- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
==================================================================================
*/
-- Drop and recreate gold.vw_customer_report
IF OBJECT_ID('gold.vw_customer_report', 'V') IS NOT NULL
    DROP VIEW gold.vw_customer_report;
GO

CREATE VIEW gold.vw_customer_report AS
WITH CTE AS (
    SELECT
        f.customer_id,
        c.first_name,
        c.last_name,
        MAX(order_date) AS last_order,
        MIN(order_date) AS first_order,
        SUM(sales) AS total_sales,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS month_history,
        DATEDIFF(MONTH, MAX(order_date), GETDATE()) AS recency_months,
        COUNT(DISTINCT f.order_number) AS total_order,
        AVG(sales) AS average_order_value,
        SUM(f.quantity) AS total_quantity,
        COUNT(DISTINCT p.product_name) AS total_product,
        MIN(c.birth_date) AS birthday
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_customers AS c ON f.customer_id = c.customer_id
    LEFT JOIN gold.dim_products AS p ON f.product_number = p.product_number
    GROUP BY f.customer_id, c.first_name, c.last_name
),
CTE2 AS (
    SELECT
        customer_id,
        first_name + ' ' + last_name AS customer_name,
        DATEDIFF(YEAR, birthday, GETDATE()) AS age,
        birthday,
        CASE
            WHEN DATEDIFF(YEAR, birthday, GETDATE()) < 30 THEN 'Young'
            WHEN DATEDIFF(YEAR, birthday, GETDATE()) > 30 AND DATEDIFF(YEAR, birthday, GETDATE()) < 55 THEN 'Middle age'
            ELSE 'Old'
        END AS age_group,
        CASE
            WHEN total_sales > 5000 AND month_history >= 12 THEN 'VIP'
            WHEN total_sales < 5000 AND month_history >= 12 THEN 'Regular'
            ELSE 'New'
        END AS customer_type,
        month_history AS customer_history_months,
        recency_months,
        total_order,
        total_sales,
        total_quantity,
        total_product,
        average_order_value,
        COALESCE(total_sales/NULLIF(month_history, 0), total_sales) AS average_monthly_spend
    FROM CTE
)

SELECT
    customer_id,
    customer_name,
    age,
    birthday,
    age_group,
    customer_type,
    customer_history_months,
    recency_months,
    total_order,
    total_sales,
    total_quantity,
    total_product,
    average_order_value,
    average_monthly_spend
FROM CTE2;
GO
	/*
================================================================================
Product Report
================================================================================
Purpose:
- This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segment products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months) 
	Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
==============================================================================
*/
IF OBJECT_ID('gold.vw_product_report', 'V') IS NOT NULL
    DROP VIEW gold.vw_product_report;
GO

CREATE VIEW gold.vw_product_report AS
WITH CTE AS (
    SELECT
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        SUM(f.sales) AS total_sales,
        COUNT(DISTINCT f.order_number) AS total_order,
        SUM(f.quantity) AS total_quantity,
        COUNT(DISTINCT f.customer_id) AS total_customer,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS month_history,
        DATEDIFF(MONTH, MAX(f.order_date), GETDATE()) AS recency_months,
        AVG(f.sales) AS average_order_revenue,
        SUM(f.sales) / NULLIF(DATEDIFF(MONTH, MIN(f.order_date), GETDATE()), 0) AS average_monthly_revenue
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p ON f.product_number = p.product_number
    GROUP BY p.product_name, p.category, p.subcategory, p.cost
)
SELECT
    product_name,
    category,
    subcategory,
    cost,
    total_sales,
    total_order,
    total_quantity,
    total_customer,
    month_history,
    recency_months,
    average_order_revenue,
    average_monthly_revenue,
    CASE
        WHEN total_sales > 10000 THEN 'High-Performer'
        WHEN total_sales BETWEEN 5000 AND 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_type
FROM CTE;
