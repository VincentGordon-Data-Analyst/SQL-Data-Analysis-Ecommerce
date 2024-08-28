-- PRODUCTS/ORDERS/ORDER DETAILS TABLE
-- Product Sales Over Time: How do sales of different products change over time?	
SELECT	
	o.date,
	p.product_name,
	SUM(o.total_amount) AS total_sales
FROM orders o
JOIN orderdetails od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY o.date, p.product_name
ORDER BY o.date, p.product_name;

-- Top Selling Products by Month: Identify the top-selling products for each month.
WITH monthly_sales AS (
	SELECT
		TO_CHAR(o.date, 'YYYY-MM') AS month,
		p.product_name,
		SUM(od.quantity * od.price) AS total_sales
	FROM orders o
	JOIN orderdetails od ON o.order_id = od.order_id
	JOIN products p ON od.product_id = p.product_id
	GROUP BY 
		TO_CHAR(o.date, 'YYYY-MM'), 
		p.product_name
)
SELECT
	month,
	product_name,
	total_sales
FROM monthly_sales
WHERE (month, total_sales) IN (
	SELECT
		month,
		MAX(total_sales)
	FROM monthly_sales
	GROUP BY month
)
ORDER BY month, total_sales DESC;