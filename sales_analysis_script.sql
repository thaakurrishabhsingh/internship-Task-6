-- Task 6: Sales Trend Analysis

-- 1. Total Number of Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 2. Number of Unique Customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM customers;

-- 3. Top 5 Products by Sales Volume
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    total_quantity_sold DESC
LIMIT 5;

-- 4. Monthly Sales Revenue
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    DATE_FORMAT(order_date, '%Y-%m')
ORDER BY 
    month;

-- 5. Customer Segmentation Based on RFM Analysis
WITH rfm AS (
    SELECT 
        c.customer_id,
        DATEDIFF('2019-03-31', MAX(o.order_date)) AS recency,
        COUNT(o.order_id) AS frequency,
        SUM(oi.quantity * oi.unit_price) AS monetary
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        c.customer_id
)
SELECT 
    customer_id,
    recency,
    frequency,
    monetary,
    CASE 
        WHEN recency <= 30 AND frequency >= 5 AND monetary >= 1000 THEN 'Champions'
        WHEN recency <= 60 AND frequency >= 3 THEN 'Loyal Customers'
        WHEN recency > 60 AND frequency <= 2 THEN 'At Risk'
        ELSE 'Others'
    END AS segment
FROM 
    rfm;
