-- ========================================================
-- Q5: Do customers with a late first order come back less?
-- ========================================================


--One row per customer = first order date and number of return orders.
WITH first_month AS (
	SELECT 
		o.order_customer_id AS customer_id,
		MIN(o.order_date) AS first_order,
		COUNT(DISTINCT o.order_id) - 1 AS return_order_count
	FROM orders o
	WHERE order_status NOT IN ('CANCELED', 'SUSPECTED_FRAUD')
	GROUP BY o.order_customer_id
),

--One row per customer = added LATE or NOT LATE labels to first order dates
first_month_status AS (
	SELECT
		fm.customer_id,
		fm.first_order,
		CASE
			WHEN s.delivery_status = 'Late delivery' THEN 'LATE'
			ELSE 'NOT LATE'
		END first_month_delivery_status,
		fm.return_order_count
	FROM first_month fm
	INNER JOIN orders o ON fm.customer_id = o.order_customer_id AND o.order_date = fm.first_order 
	INNER JOIN shipments s ON o.order_id = s.order_id
	WHERE s.delivery_status <> 'Shipping canceled'
)

--One row per first month delivery status = total customers, returned customers and return rate.
SELECT 
	first_month_delivery_status,
	COUNT(*) AS total_customers,
	COUNT(*) FILTER(WHERE return_order_count > 0) AS returned_customers,
	ROUND((COUNT(*) FILTER(WHERE return_order_count > 0)::numeric / COUNT(*) * 100), 2) AS return_rate
FROM first_month_status fms
GROUP BY first_month_delivery_status


