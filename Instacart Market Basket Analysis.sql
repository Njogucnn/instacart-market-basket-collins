-- 📊 Instacart Market Basket Analysis
-- ✅ Final SQL Summary Queries for Excel Dashboard
# 🛍️ Instacart Market Basket Analysis

## Overview
-- Analyzed over 2,000 grocery orders using MySQL to uncover key business insights like reorder patterns, most popular departments, and customer shopping behavior.

## Tools Used
-- MySQL (Workbench)
-- Excel (dashboard & charts)

## Key Insights
-- 🕒 Most orders placed at 11am
-- 🔁 60.7% of products were reorders
-- 🛒 Top reordered product: Soda
-- 🧾 Department with most orders: Dairy & Eggs

## Files
-- `/SQL/`: All queries used, grouped by topic
-- `Instacart_Dashboard.xlsx`: Final Excel dashboard

## Next Steps
-- Build interactive version in Tableau/Power BI

-- Author: [COLLINS NJEHYA]
-- Date: [07/07/2025]


## Are there any NULLs in critical columns like product_name, aisle, department, user_id, order_id, or product_id?
SELECT COUNT(*) FROM products
WHERE product_id IS NULL;

SELECT COUNT(*) FROM departments
WHERE department IS NULL;

SELECT COUNT(*) FROM aisles
WHERE aisle IS NULL;

SELECT COUNT(*) FROM orders
WHERE user_id IS NULL;

SELECT COUNT(*) FROM orders
WHERE order_id IS NULL;

## Are there any duplicate rows in these key tables?
SELECT order_id, product_id, COUNT(*) AS cnt
FROM order_products__train
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

SELECT order_id, product_id, COUNT(*) AS cnt
FROM order_products__prior
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

SELECT COUNT(DISTINCT order_id)
FROM orders;

SELECT order_id, COUNT(*) AS count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT COUNT(DISTINCT product_id)
FROM products;

SELECT product_id, COUNT(*) AS count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

## How many distinct products are there?
SELECT COUNT(DISTINCT product_id)
FROM products;

## How many departments are there, and what are their names?
SELECT DISTINCT department
FROM departments;

## How many products are in each department?
SELECT COUNT(products.product_name),
		departments.department
FROM products JOIN departments
	ON products.department_id = departments.department_id
GROUP BY department;

## Count how many unique users appear in the orders table.
SELECT COUNT(DISTINCT user_id)
FROM orders;

## How many orders has each user placed?
SELECT COUNT(order_id),
		user_id
FROM orders
GROUP BY user_id;

## Minimum Maximum and Average number of orders placed by a user?
SELECT 
    MIN(order_count) AS min_orders,
    MAX(order_count) AS max_orders,
    AVG(order_count) AS avg_orders
FROM (
    SELECT user_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY user_id
) AS user_orders;

## What is the average number of items per order
SELECT AVG(product_count) AS avg_item_per_product
FROM (
		SELECT COUNT(product_id) as product_count,
		order_id
FROM order_products__train
GROUP BY order_id
		) AS avg_no_items;

## What days do customers shop the most
SELECT COUNT(order_id) as order_count,
		order_dow
FROM orders
GROUP BY order_dow
ORDER BY order_count DESC;

## At what hour of the day are most orders placed?
SELECT COUNT(order_id) AS order_count,
		order_hour_of_day
FROM orders
GROUP BY order_hour_of_day
ORDER BY order_count DESC;

SELECT COUNT(order_id) AS order_count,
		order_hour_of_day
FROM orders
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day ASC;

## What percentage of all prior purchases were reorders?
SELECT (
		COUNT(*)/ (SELECT COUNT(*)
			FROM order_products__prior)
            ) * 100 AS percentage_reordered
FROM order_products__prior
WHERE reordered= 1;

## Which products are reordered the most?
SELECT products.product_name,
		COUNT(order_products__prior.product_id) AS no_ordered
FROM products JOIN  order_products__prior
	ON products.product_id = order_products__prior.product_id
WHERE reordered = 1
GROUP BY products.product_name
ORDER BY no_ordered DESC;

## Which departments do customers buy from the most?
SELECT COUNT(order_products__prior.product_id) AS total_orders,
		departments.department
FROM order_products__prior JOIN products
	ON order_products__prior.product_id = products.product_id
JOIN departments ON products.department_id = departments.department_id
GROUP BY departments.department
ORDER BY total_orders DESC;

## How many total orders are there?
SELECT COUNT(DISTINCT order_id)
FROM orders;

## How many unique customers have placed orders?
SELECT COUNT(DISTINCT user_id)
FROM orders;