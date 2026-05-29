-- Q1 — What is the total revenue, total profit, and overall profit margin across the entire dataset?
SELECT 
    SUM(o.sales * o.quantity) AS total_revenue, 
    SUM(o.profit) AS total_profit,
    SUM(profit_margin) AS overall_profit_margin
FROM orders AS o;

-- Q2 — What are total sales and total profit broken down by category?
SELECT p.category, SUM(o.sales) AS total_sales, SUM(o.profit) AS total_profit
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY p.category;
-- Q3 — Which sub-categories have a negative average profit margin?
SELECT p.sub_category, AVG(o.profit_margin) AS avg_profit_margin
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY p.sub_category
HAVING AVG(o.profit_margin) < 0
ORDER BY avg_profit_margin;
-- Q4 — How does the discount level affect average profit margin?
SELECT 
    o.discount * 100 AS discount, 
    COUNT(o.order_id) AS total_orders, 
    ROUND(AVG(o.profit_margin), 2) AS avg_profit_margin
FROM orders AS o
GROUP BY o.discount 
ORDER BY o.discount ASC;

-- Q5 — What is the monthly revenue trend over the full date range?
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS order_year,
    EXTRACT(MONTH FROM o.order_date) AS order_month,
    SUM(o.sales) AS monthly_revenue, 
    COUNT(o.order_id) AS total_orders
FROM orders AS o
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY order_year ASC, order_month ASC;

-- Q6 — Which US states have the highest total sales? Show the top 10.
SELECT l.state, SUM(o.sales) AS total_sales
FROM orders AS o
JOIN locations AS l
    ON l.location_id = o.location_id
GROUP BY l.state
ORDER BY total_sales DESC
LIMIT 10;

-- Q7 — What is the total profit and average profit margin by region?
SELECT l.region, SUM(o.profit) AS total_profit, AVG(o.profit_margin) AS avg_profit_margin
FROM orders AS o
JOIN locations AS l
    ON o.location_id = l.location_id
GROUP BY l.region
ORDER BY avg_profit_margin DESC;

-- Q8 — How many orders were unprofitable, and what percentage of all orders does that represent?
SELECT 
    COUNT(CASE WHEN is_unprofitable = TRUE THEN 1 END) AS unprofitable_orders_count, 
    COUNT(o.order_id) AS total_orders_count,
    ROUND(COUNT(CASE WHEN is_unprofitable = TRUE THEN 1 END) * 100.0 / COUNT(order_id), 2) AS percentage_unprofitable
FROM orders AS o;

-- Task 9: What is total profit as a percentage of total sales?
SELECT SUM(profit) / SUM(sales) * 100 AS overall_profit_margin
FROM orders;

-- Task 10: Orders placed in 2017 with negative profit
SELECT o.order_date, o.profit
FROM orders AS o
JOIN products AS p 
    ON p.product_id = o.product_id
WHERE o.profit < 0 AND o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-31'
ORDER BY o.order_date;

-- Task 11: Profit margin by category AND region (3-table join)
SELECT p.category, l.region, AVG(o.profit_margin) AS avg_margin
FROM orders AS o
JOIN products AS p 
    ON p.product_id = o.product_id
JOIN locations l 
    ON l.location_id = o.location_id
GROUP BY p.category, l.region
ORDER BY avg_margin DESC;