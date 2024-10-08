--Retrieve all product names along with their category names.
SELECT
	c.category_name,
	p.product_name
FROM categories c
JOIN products p ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;


-- Find all products and the names of their vendors
SELECT
	p.product_name,
	v.vendor_name
FROM products p
JOIN vendors v ON p.vendor_id = v.vendor_id
ORDER BY product_name;

-- Use a sub-query to list products along with their vendors' names, only if the product price is above the vendor's average price.
SELECT
	p.product_name,
	v.vendor_name,
	p.price
FROM vendors v
JOIN products p ON v.vendor_id = p.vendor_id
WHERE p.price > (SELECT AVG(price) FROM products p2 WHERE p2.vendor_id = v.vendor_id)
ORDER BY p.price;


-- Write a query to find the total value of products supplied by each vendor in each category.
WITH vendors_total_product_value AS (
	SELECT
		v.vendor_name,
		p.category_id,
		SUM(p.price) AS total_product_value
	FROM vendors v
	JOIN products p ON v.vendor_id = p.vendor_id
	GROUP BY v.vendor_name, p.category_id
)

SELECT
	vtpv.vendor_name,
	c.category_name,
	vtpv.total_product_value
FROM vendors_total_product_value vtpv
JOIN categories c ON vtpv.category_id = c.category_id
ORDER BY vtpv.total_product_value DESC;

--  Use a window function to rank categories based on the total revenue generated by their products.
SELECT
	c.category_name,
	SUM(p.price) AS total_revenue_generated,
 	DENSE_RANK() OVER(ORDER BY SUM(p.price) DESC)
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;


-- Use a CTE to calculate the average product price for each category, and then list all products that are priced above the average.
WITH avg_category_price AS (
SELECT
	category_id,
	AVG(price) AS avg_price
FROM products
GROUP BY category_id
)

SELECT
	acp.category_id,
	p.product_name,
	AVG(p.price) AS product_price,
	SUM(acp.avg_price) AS avg_category_price
FROM products p
JOIN avg_category_price acp ON p.category_id = acp.category_id
WHERE p.price > acp.avg_price
GROUP BY acp.category_id, p.product_name

