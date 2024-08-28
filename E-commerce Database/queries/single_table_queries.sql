-- PRODUCTS TABLES --
-- Retrieve all product name and prices
SELECT
	product_name,
	price
FROM products
ORDER BY price DESC;

-- Find the product with the highest price
SELECT
	product_name,
	price
FROM products
ORDER BY price DESC
LIMIT 1;

-- Calculate the average price of all products.
SELECT	AVG(price) AS averge_price
FROM products;

-- List all products with a price above the average price
SELECT * 
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Count the total number of products in each category
SELECT
	category_id,
	COUNT(product_id) AS total_products
FROM products
GROUP BY category_id
ORDER BY category_id;

-- Use a window function to rank products by price within each category.
SELECT
	category_id,
	product_name,
	sum(price),
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY SUM(price) DESC) AS price_rank
FROM products
GROUP BY category_id, product_name
ORDER BY category_id, price_rank;


-- Write a query to find the most expensive product in each category using a sub-query
SELECT
	p.category_id,
	p.product_name,
	max_product_price.max_price
FROM products p
JOIN (SELECT
		category_id,
		MAX(price) AS max_price
	FROM products
	GROUP BY category_id
) AS max_product_price 
ON max_product_price.category_id = p.category_id
AND p.price = max_product_price.max_price;


-- Calculate the total revenue if each product is sold 100 times
SELECT
	SUM(price * 100) AS revenue_sold_100_time
FROM products;

-- Write a CASE statement to categorize products as 'Cheap', 'Affordable', or 'Expensive' based on their prices
SELECT
	*,
	CASE
		WHEN price BETWEEN 1.99 AND 250 THEN 'Cheap'
		WHEN price BETWEEN 251 AND 500 THEN 'Affordable'
		ELSE 'Expensive'
	END AS product_affordability
FROM products;

-- Find the minimum, maximum, and average price for each category using an aggregate function
SELECT
	category_id,
	MIN(price) AS min_price,
	MAX(price) AS max_price,
	AVG(price) AS avg_price
FROM products
GROUP BY category_id
ORDER BY category_id;


-- CATEGORIES TABLE --
--  List all category names and their IDs.
SELECT * FROM categories;

-- Write a query to list all categories that have products with a price greater than $100 (use a sub-query)
SELECT DISTINCT
	c.category_name
FROM categories c
WHERE c.category_id IN (
	SELECT DISTINCT p.category_id
	FROM products p
	WHERE p.price > 100
);


-- Calculate the average price of products in each category using a CTE
WITH avg_product_price AS (
	SELECT 
		category_id,
		AVG(price) AS avg_price
	FROM products
	GROUP BY category_id
)
SELECT
	c.category_name,
	avg_product_price.avg_price
FROM categories c
JOIN avg_product_price 
ON c.category_id = avg_product_price.category_id;

-- Write a query to display categories with at least one product priced above the average price of all products
WITH avg_product_price AS (
    SELECT 
        category_id,
        AVG(price) AS avg_price
    FROM products
    GROUP BY category_id
)
SELECT
    c.category_name,
    COUNT(p.product_name) AS product_count,
    avg_product_price.avg_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN avg_product_price ON c.category_id = avg_product_price.category_id
GROUP BY c.category_name, avg_product_price.avg_price
HAVING COUNT(p.product_name) > avg_product_price.avg_price;

-- Use a CASE statement to label categories as 'High-End', 'Mid-Range', or 'Budget' based on the average price of their products.
WITH avg_category_price AS (
	SELECT
		category_id,
		AVG(price) avg_price
	FROM products
	GROUP BY category_id
)

SELECT
	c.category_name,
	avg_category_price.avg_price,
	CASE
		WHEN avg_category_price.avg_price < 50 THEN 'Budget'
		WHEN avg_category_price.avg_price BETWEEN 50 and 150 THEN 'Mid-Range'
		ELSE 'High-End'
	END AS spending_range
FROM categories c
JOIN avg_category_price ON c.category_id = avg_category_price.category_id
ORDER BY c.category_name;


-- Find categories where all products are priced below $50
SELECT
	category_name
FROM categories
WHERE category_id IN (
	SELECT category_id
	FROM products
	WHERE price < 50);


-- VENDORS TABLE --
-- List all vendors and their IDs
SELECT * FROM vendors;

-- Find the total number of vendors.
SELECT COUNT(*) AS vendor_count
FROM vendors;


-- Count the number of products supplied by each vendor
WITH vendor_product_count AS (
	SELECT
		vendor_id,
		COUNT(product_id) AS product_count
	FROM products
	GROUP BY vendor_id
)

SELECT
	v.vendor_id,
	v.vendor_name,
	vendor_product_count.product_count
FROM vendors v
JOIN vendor_product_count ON v.vendor_id = vendor_product_count.vendor_id
ORDER BY v.vendor_id;


-- Identify vendors who supply products priced above $200.
SELECT	
	vendor_id,
	price
FROM products
WHERE price > 200
	