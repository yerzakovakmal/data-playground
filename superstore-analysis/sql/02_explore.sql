-- View Tables
SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM locations;

SELECT * FROM orders;

-- == ROW COUNTS for every table ==
SELECT COUNT(*) AS customers_count FROM customers;
SELECT COUNT(*) AS products_count FROM products;
SELECT COUNT(*) AS locations_count FROM locations;
SELECT COUNT(*) AS orders_count FROM orders ;

-- == Distinct Values ==
SELECT DISTINCT(COUNT(*)) -- 793
FROM customers;

SELECT DISTINCT(COUNT(*)) -- 1862
FROM products;

SELECT DISTINCT(COUNT(*)) -- 632
FROM locations;

SELECT DISTINCT(COUNT(*)) -- 9994
FROM orders;


-- Task 1: What is the earliest and latest order date in the dataset?
SELECT MIN(order_date) AS earliest_order, MAX(order_date) AS latest_order
FROM orders;

-- Task 2: Order count by region
SELECT  l.region, COUNT(*)
FROM orders AS o
JOIN locations AS l
    ON l.location_id = o.location_id
GROUP BY l.region;

-- Task 3: Total sales by region (orders + locations)
SELECT l.region, SUM(o.sales) AS total_sales
FROM orders AS o
JOIN locations AS l
    ON l.location_id = o.location_id
GROUP BY l.region;

-- Task 4: States with 100+ orders AND over $10K total profit
SELECT l.state, SUM(o.profit) AS total_profit, COUNT(o.order_id) AS orders
FROM orders AS o
JOIN locations AS l
    ON l.location_id = o.location_id
GROUP BY l.state
HAVING SUM(o.profit) > 10000 AND COUNT(o.order_id) > 100
ORDER BY orders DESC;