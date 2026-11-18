-- =========================================================
-- Q4: How is the late rate trending, and when did it spike?
-- =========================================================


--One row per month = monthly sales and late rate percentage.
WITH late_rate_per_month AS (
	SELECT
		DATE_TRUNC('month', order_date)::date AS order_month,
		SUM(sales) AS monthly_sales,
		ROUND((COUNT(DISTINCT oi.order_id) FILTER(WHERE delivery_status = 'Late delivery') / COUNT(DISTINCT oi.order_id)::NUMERIC) * 100, 2) AS late_rate
	FROM orders o 
	INNER JOIN shipments s  ON o.order_id = s.order_id
	INNER JOIN order_items oi ON o.order_id = oi.order_id
	WHERE delivery_status <> 'Shipping canceled'
	GROUP BY order_month
)

--One row per month = added diffference in late rate from previous month and a 3 month rolling average of late rate.
SELECT
	*,
	late_rate - LAG(late_rate) OVER(ORDER BY order_month) AS late_rate_diff,
	ROUND(AVG(late_rate) OVER(ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_average
FROM late_rate_per_month
ORDER BY order_month
