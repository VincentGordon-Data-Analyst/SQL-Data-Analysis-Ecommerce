-- PRODUCTS TABLE 
-- Daily Payment Totals: What is the total amount paid each day?
SELECT	
	payment_date,
	SUM(amount) AS total_amount
FROM payments
GROUP BY payment_date
ORDER BY payment_date;

-- Monthly Payment Trend: How has the total payment amount evolved month over month?
SELECT
	TO_CHAR(payment_date, 'YYYY-MM') AS month_year,
	SUM(amount) AS total_payment_amount
FROM payments
GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
ORDER BY month_year;

-- Payment Method Distribution Over Time: How does the use of different payment methods change over time?
SELECT 
	TO_CHAR(payment_date, 'YYYY-MM') AS month_year,
	payment_method,
	COUNT(*) AS payment_method_count
FROM payments
GROUP BY 
	TO_CHAR(payment_date, 'YYYY-MM'),
	payment_method
ORDER BY month_year, payment_method;

-- Cumulative Payments: What is the cumulative total of payments over time?
SELECT
	TO_CHAR(payment_date, 'YYYY-MM') AS month_year,
	SUM(amount) AS total_amount,
 	SUM(SUM(amount)) OVER(ORDER BY TO_CHAR(payment_date, 'YYYY-MM')) AS cumulative_total
FROM payments
GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
ORDER BY TO_CHAR(payment_date, 'YYYY-MM');

-- Payment Spike Analysis: Identify the days with payment amounts significantly higher than the daily average.
WITH daily_payment_totals AS (
    SELECT
        TO_CHAR(payment_date, 'YYYY-MM-DD') AS day_year,
        SUM(amount) AS total_amount,
        AVG(amount) AS daily_average
    FROM 
        payments
    GROUP BY 
        TO_CHAR(payment_date, 'YYYY-MM-DD')
)
SELECT
    day_year,
    total_amount,
    daily_average
FROM daily_payment_totals
WHERE total_amount > daily_average 
ORDER BY day_year;

-- Payment Method Shift: How does the distribution of payment methods change from year to year?
SELECT 
	TO_CHAR(payment_date, 'YYYY') AS payment_year,
	payment_method,
	COUNT(*) AS payment_method_count
FROM payments
GROUP BY TO_CHAR(payment_date, 'YYYY'), payment_method
ORDER BY payment_year, payment_method; 