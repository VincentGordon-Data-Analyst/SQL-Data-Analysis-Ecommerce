-- Retrieve all product names, their category names, and their vendors' names.
SELECT
	p.product_name,
	c.category_name,
	v.vendor_name	
FROM vendors v
JOIN products p ON v.vendor_id = p.vendor_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY 
	v.vendor_name,
	c.category_name,
	p.product_name;
	
-- Find the total value of products supplied by each vendor, grouped by category.
SELECT
	v.vendor_name,
	c.category_name,
	SUM(p.price) AS total_product_value
FROM products p
JOIN vendors v ON p.vendor_id = v.vendor_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY 
	v.vendor_name,
	c.category_name
ORDER BY 
	v.vendor_name,
	total_product_value DESC;
	
-- Write a sub-query to list all products supplied by vendors who supply more than 10 products.
SELECT
	v.vendor_name,
	p.product_name
FROM vendors v
JOIN products p ON v.vendor_id = p.vendor_id
WHERE v.vendor_id IN
(
	SELECT
		vendor_id
	FROM products
	GROUP BY vendor_id
	HAVING COUNT(product_id) > 10
)
GROUP BY v.vendor_name, p.product_name;

-- Use a window function to rank vendors based on the total value of products they supply in each category. (CHECK)
SELECT
	v.vendor_name,
	c.category_name,
	SUM(p.price) AS total_product_value,
	DENSE_RANK() OVER(ORDER BY SUM(p.price) DESC) AS vendor_rank
FROM products p
JOIN vendors v ON p.vendor_id = v.vendor_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY 
	v.vendor_name,
	c.category_name
ORDER BY 
	vendor_rank;
	
-- 	Write a query to find the vendor who supplies the most expensive product in each category.
SELECT
	c.category_name,
	p.product_name,
	v.vendor_name,
	p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN vendors v ON p.vendor_id = v.vendor_id
WHERE p.price IN (
	SELECT MAX(p2.price)
	FROM products p2
	WHERE p2.category_id = p.category_id
);


-- Use a CTE to find the total number of products, the total value of products, and the average price for each vendor in each category.
WITH vendor_stats AS (
	SELECT
		vendor_id,
		category_id,
		COUNT(product_id) AS total_products,
		SUM(price) AS total_value,
		AVG(price) AS average_price
	FROM products
	GROUP BY vendor_id, category_id
)

SELECT
	v.vendor_name,
	c.category_name,
	vs.total_products,
	vs.total_value,
	vs.average_price	
FROM vendor_stats vs 
JOIN vendors v ON vs.vendor_id = v.vendor_id
JOIN categories c ON vs.category_id = c.category_id
;
	