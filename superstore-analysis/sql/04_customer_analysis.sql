-- Q1 — How many unique customers are in the dataset, and how many orders has each segment placed?
SELECT COUNT(DISTINCT(c.customer_id)) AS unique_customers, c.segment
FROM customers AS c
GROUP BY c.segment;

-- Q2 — What is the total revenue, total profit, and average order value per customer segment?
SELECT
    c.segment,
    SUM(o.sales * o.quantity) AS total_revenue, 
    SUM(o.profit) AS total_profit,
    SUM(o.sales) / COUNT(DISTINCT(o.order_id)) AS avg_order_value
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
GROUP BY c.segment
ORDER BY 2,3,4 ASC;

-- Q3 — Who are the top 10 customers by total profit contributed?
SELECT c.customer_id, SUM(o.profit) AS total_profit
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_profit DESC
LIMIT 10;


-- Q4 — Which customers have placed the most orders? Show the top 10.
SELECT c.customer_id, c.name, COUNT(DISTINCT o.order_id) AS total_order
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_order DESC
LIMIT 10;


-- Q5 — What is the average number of orders per customer, broken down by segment?
SELECT c.segment, COUNT(o.order_id)::DECIMAL / COUNT(DISTINCT o.customer_id) AS avg_number_orders
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
GROUP BY c.segment
ORDER BY 2;

-- Q6 — Which customers have a negative total profit? List them with their total loss.
SELECT o.customer_id, c.name, SUM(o.profit) AS total_profit
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
GROUP BY 1, 2
HAVING SUM(o.profit) < 0
ORDER BY total_profit;

-- Q7 — Rank customers within each segment by their total profit.
SELECT 
    c.customer_id, 
    c.name,
    SUM(o.profit) AS total_profit,
    c.segment,
    DENSE_RANK() OVER(PARTITION BY c.segment ORDER BY SUM(o.profit) DESC) AS total_rank
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
GROUP BY 1, 2, 4;


-- Q8 — How many customers have only ever placed a single order? What percentage is that of all customers?
WITH customer_order_counts AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders AS o
    GROUP BY customer_id
)

SELECT 
    COUNT(CASE WHEN total_orders = 1 THEN 1 END) AS single_order_customers,
    ROUND(COUNT(CASE WHEN total_orders = 1 THEN 1 END)::NUMERIC / COUNT(*)::NUMERIC * 100, 2) AS percentage_of_all_customers
FROM customer_order_counts;

-- Q9 — What is the running total of revenue by customer segment over time?
WITH daily_segment_revenue AS (
    SELECT
        c.segment,
        o.order_date,
        SUM(o.sales) AS daily_revenue
    FROM orders AS o
    JOIN customers AS c
        ON c.customer_id = o.customer_id
    GROUP BY 1, 2
)

SELECT 
    d.segment,
    d.order_date,
    d.daily_revenue,
    SUM(daily_revenue) OVER(PARTITION BY segment ORDER BY order_date ASC) AS running_revenue
FROM daily_segment_revenue AS d
ORDER BY d.segment, d.order_date;


-- Task 10: Top 10 customers by total profit (orders + customers)
SELECT c.customer_id, c.name, SUM(o.profit) AS total_profit
FROM orders AS o
JOIN customers AS c 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_profit DESC
LIMIT 10;

-- Task 11: Rank customers within their segment by total profit:
SELECT c.name, c.segment, SUM(o.profit) AS total_profit,
    RANK() OVER(PARTITION BY c.segment ORDER BY SUM(o.profit) DESC) AS rank_in_segment
FROM orders AS o
JOIN customers AS c 
    ON o.customer_id = c.customer_id
GROUP BY c.name, c.segment;