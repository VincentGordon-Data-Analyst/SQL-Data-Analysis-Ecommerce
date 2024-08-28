-- ORDERS TABLE
-- Daily Order Counts: How many orders are placed each day?
SELECT
	date,
	COUNT(*) AS order_count
FROM orders
GROUP BY date
ORDER BY date;

-- Order Value Trends: How does the average order value change over time?
SELECT
	TO_CHAR(date, 'YYYY-MM') AS month_of_year,
	AVG(total_amount) AS avg_order_value
FROM orders
GROUP BY TO_CHAR(date, 'YYYY-MM')
ORDER BY month_of_year;

-- Order Frequency per Customer: How often do customers place orders over time?
SELECT
	customer_id,
	TO_CHAR(date, 'YYYY-MM') AS month_of_year,
	COUNT(*) order_count
FROM orders
GROUP BY TO_CHAR(date, 'YYYY-MM'), customer_id
ORDER BY order_count DESC;

-- Monthly Order Trends: What are the monthly trends in the number of orders?

SELECT
	TO_CHAR(date, 'YYYY-MM') AS month_of_year,
	COUNT(*) AS order_count,
	REPEAT('*',COUNT(*)::int) AS order_viz
FROM orders
GROUP BY TO_CHAR(date, 'YYYY-MM')
ORDER BY month_of_year;

-- Order Status Changes: How does the distribution of order statuses (e.g., pending, shipped) change over time?
SELECT 
	TO_CHAR(date, 'YYYY-MM') AS year,
	status,
	COUNT(*) AS status_count
FROM orders
GROUP BY TO_CHAR(date, 'YYYY-MM'), status
ORDER BY year, status;

-- Order Peak Times: Identify the times or days when order volumes peak.
SELECT
	TO_CHAR(date, 'Day') AS day_of_week,
	COUNT(*) AS order_volume
FROM orders
GROUP BY TO_CHAR(date, 'Day')
ORDER BY order_volume DESC;


