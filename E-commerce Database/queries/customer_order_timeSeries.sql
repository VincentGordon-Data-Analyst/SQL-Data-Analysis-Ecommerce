-- CUSTOMERS/ORDERS TABLE
-- New Customer Acquisition Over Time: How many new customers are acquired each month?
SELECT
	TO_CHAR(registration_date, 'YYYY-MM') AS month_of_year,
	COUNT(*) AS registration_count
FROM customers
GROUP BY TO_CHAR(registration_date, 'YYYY-MM')
ORDER BY month_of_year;

-- Customer Order Frequency: How frequently do customers place orders each quarter?
SELECT 
	TO_CHAR(o.date, 'YYYY-Q') AS quarter,
	c.customer_id,
	COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, TO_CHAR(o.date, 'YYYY-Q')
ORDER BY quarter DESC;

-- Top Spending Customers Over Time: Who are the top spending customers each month?
WITH monthly_spending AS (
	SELECT
		customer_id,
		TO_CHAR(date, 'YYYY-MM') AS month,
		SUM(total_amount) AS total_spending
	FROM orders
	GROUP BY customer_id, TO_CHAR(date, 'YYYY-MM')
	ORDER BY month, total_spending
),
max_spenders AS (
	SELECT
		month,
		MAX(total_spending) AS max_spending
	FROM monthly_spending
	GROUP BY month
)
SELECT
	ms.month,
	ms.customer_id
FROM monthly_spending AS ms
JOIN max_spenders maxspen ON ms.month = maxspen.month 
AND ms.total_spending = maxspen.max_spending
GROUP BY
	ms.month,
	ms.customer_id;



