-- SHIPPMENTS TABLE
-- Shipment Volume Over Time: How many shipments were made each day?
SELECT
	TO_CHAR(shipping_date, 'YYYY-MM-DD') AS day_year,
	COUNT(*) AS shipment_count
FROM shipments
GROUP BY TO_CHAR(shipping_date, 'YYYY-MM-DD')
ORDER BY day_year;



-- Delayed Shipments: Identify the periods with the highest number of delayed shipments.
SELECT 
    TO_CHAR(shipping_date, 'YYYY-MM') AS month_year,
    COUNT(*) AS delayed_status_count
FROM 
    shipments
WHERE 
    status = 'Delayed'
GROUP BY 
    TO_CHAR(shipping_date, 'YYYY-MM')
ORDER BY 
    delayed_status_count DESC;

-- Weekly Shipping Trends: What are the weekly trends in the number of shipments?
SELECT
	TO_CHAR(shipping_date,'YYYY-W') AS week_of_year,
	COUNT(*) AS number_of_shipments,
	REPEAT('*', COUNT(*)::int) AS shipment_visualization
FROM shipments
GROUP BY TO_CHAR(shipping_date,'YYYY-W')
ORDER BY week_of_year;

-- Seasonal Shipping Trends: Are there specific times of the year with higher or lower shipping volumes?
SELECT
	TO_CHAR(shipping_date,'YYYY-MM') AS month_of_year,
	COUNT(*) AS shipping_volume,
	REPEAT('*', COUNT(*)::int) AS shipping_vol_viz
FROM shipments
GROUP BY TO_CHAR(shipping_date,'YYYY-MM')
ORDER BY month_of_year;


-- Shipment Status Changes: How does the distribution of shipment statuses (e.g., delivered, in transit) change over time?
SELECT
	TO_CHAR(shipping_date, 'YYYY-MM') AS month_of_year,
	status,
	COUNT(*) AS status_count
FROM shipments
GROUP BY TO_CHAR(shipping_date, 'YYYY-MM'), status
ORDER BY month_of_year, status_count DESC;

