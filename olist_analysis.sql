USE olist;
-- Query 1: Monthly orders and revenue
SELECT
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
  COUNT(DISTINCT o.order_id) AS total_orders,
  SUM(i.price) AS revenue
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
GROUP BY month
ORDER BY month;

-- Query 2: Repeat buyers (share of customers who ordered more than once)
WITH per_person AS (
  SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS n
  FROM orders o
  JOIN customers c ON c.customer_id = o.customer_id
  GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS total_customers,
       SUM(n > 1) AS repeat_customers,
       ROUND(100 * SUM(n > 1) / COUNT(*), 2) AS repeat_pct
FROM per_person;

-- Query 3: Late deliveries vs review score
WITH review_per_order AS (
  SELECT order_id, AVG(review_score) AS score
  FROM order_reviews
  GROUP BY order_id
)
SELECT
  CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
       THEN 'Late' ELSE 'On time' END AS delivery_status,
  COUNT(*) AS orders,
  ROUND(AVG(r.score), 2) AS avg_review
FROM orders o
JOIN review_per_order r ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

-- Query 4: Top 10 states by revenue

SELECT c.customer_state,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(i.price), 2) AS revenue,
       RANK() OVER (ORDER BY SUM(i.price) DESC) AS revenue_rank
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY revenue_rank
LIMIT 10;

-- Query 5: Month-over-month revenue growth
WITH monthly AS (
  SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
         SUM(i.price) AS revenue
  FROM orders o
  JOIN order_items i ON i.order_id = o.order_id
  GROUP BY month
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
WHERE month BETWEEN '2017-01' AND '2018-08'
ORDER BY month;