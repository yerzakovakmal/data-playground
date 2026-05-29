-- Q1 — What are the top 10 most profitable individual products?
SELECT p.product_id, p.product_name, p.category, SUM(o.profit) AS total_profit
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit DESC
LIMIT 10;

-- Q2 — What are the 10 biggest profit-destroying products?
SELECT p.product_id, p.product_name, p.category, SUM(o.profit) AS total_profit
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY 1, 2, 3
ORDER BY total_profit
LIMIT 10;


-- Q3 — How many distinct products exist in each category and sub-category?
SELECT 
    p.category,
    p.sub_category,
    COUNT(DISTINCT o.product_id) AS distinct_products_count
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY 1, 2
ORDER BY distinct_products_count DESC;


-- Q4 — What is the average discount applied per category?
SELECT 
    p.category,
    ROUND(AVG(o.discount), 2) AS avg_discount
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY 1
ORDER BY avg_discount;


-- Q5 — Which sub-category has the highest total quantity sold?
SELECT 
    p.sub_category,
    SUM(o.quantity) AS total_quantity
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY 1
ORDER BY total_quantity DESC;


-- Q6 — Which products have been ordered more than 10 times but still have a negative total profit?
SELECT 
    p.product_id,
    p.product_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.profit) AS total_profit
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
WHERE o.is_unprofitable IS TRUE
GROUP BY 1, 2
HAVING COUNT(o.order_id) > 10
ORDER BY order_count DESC;


-- Q7 — What is the profit margin for each sub-category, and how does it compare to the category average?
SELECT
    p.product_id,
    p.category,
    ROUND(AVG(o.profit_margin), 2) AS avg_profit_margin,
    ROUND(AVG(AVG(o.profit_margin)) OVER(PARTITION BY p.category), 2) AS category_avg_margin,
    ROUND(AVG(o.profit_margin), 2) - ROUND(AVG(AVG(o.profit_margin)) OVER(PARTITION BY p.category),2) AS difference
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
GROUP BY 1, 2
ORDER BY p.category, difference DESC;


-- Q8 — Rank products within each sub-category by total revenue.
SELECT  
    p.product_id,
    p.sub_category,
    SUM(o.sales) AS total_revenue,
    DENSE_RANK() OVER(PARTITION BY p.sub_category ORDER BY SUM(o.sales) DESC) AS product_rank
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY 1, 2
ORDER BY 2, product_rank;


-- Q9 — Which products have a discount applied on every single order?
SELECT
    p.product_id,
    p.product_name,
    MIN(o.discount * 100) AS lowest_discount
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY 1, 2
HAVING MIN(o.discount * 100) > 0.00;


-- Task 1: Sales and profit by category
SELECT p.category, SUM(o.profit) AS sum_profit, SUM(o.sales) AS sum_sales 
FROM orders AS o
JOIN products AS p 
    ON p.product_id = o.product_id
GROUP BY p.category;

-- Task 2: Average profit margin by sub-category, worst to best
SELECT p.sub_category, AVG(o.profit_margin) AS avg_profit_margin
FROM orders AS o
JOIN products as p 
    ON p.product_id = o.product_id
GROUP BY p.sub_category
ORDER BY avg_profit_margin ASC;

-- Task 3: Sub-categories with negative average margin
SELECT p.sub_category, AVG(o.profit_margin) AS avg_margin
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY p.sub_category
HAVING AVG(o.profit_margin) < 0
ORDER BY avg_margin DESC;

-- Task 4: Total profit by category (orders + products)
SELECT p.category, SUM(o.profit) AS total_profit
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.product_id
GROUP BY p.category;

-- Task 5: Each sub-category's share of total sales:
SELECT 
    p.sub_category,
    SUM(o.sales) AS subcat_sales,
    SUM(SUM(o.sales)) OVER() AS grand_total_sales,
    (SUM(o.sales) / SUM(SUM(o.sales)) OVER ()) * 100 AS percentage_share
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY percentage_share DESC;