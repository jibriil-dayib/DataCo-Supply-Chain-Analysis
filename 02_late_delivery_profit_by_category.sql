-- ================================================================================
-- Q2: Do late orders earn less profit, and in which categories is the gap biggest?
-- ================================================================================


--Multiple rows per category = order profit and sales for each order, with LATE or NOT LATE labels.
WITH order_item_delivery_status AS (
	SELECT
		category_name,
		order_profit_per_order,
		sales,
		CASE 
			WHEN s.delivery_status = 'Late delivery' THEN 'LATE'
			ELSE 'NOT LATE'
		END AS delivery_status
	FROM categories c 
	INNER JOIN products p ON c.category_id = p.category_id 
	INNER JOIN order_items oi ON p.product_card_id = oi.order_item_cardprod_id 
	INNER JOIN shipments s ON oi.order_id = s.order_id 
	WHERE s.delivery_status <> 'Shipping canceled'
), 

--2 rows per category = total profit and profit margin for each category, with LATE or NOT LATE labels.
category_profit_by_status AS (
	SELECT 
		category_name,
		delivery_status,
		SUM(order_profit_per_order) AS profit_category_sum,
		ROUND(SUM(order_profit_per_order) / SUM(sales), 4) * 100 AS profit_margin
	FROM order_item_delivery_status 
	GROUP BY category_name, delivery_status 
)

-- 2 rows per category = total profit, profit margin and profit gap for each category, and total sum and average profit margin for each delivery status
SELECT 	
	*,
	MAX(profit_category_sum) OVER(PARTITION BY category_name) - MIN(profit_category_sum) OVER(PARTITION BY category_name) AS profit_gap,
	SUM(profit_category_sum) OVER(PARTITION BY delivery_status) AS status_profit_sum,
	ROUND(AVG(profit_margin) OVER(PARTITION BY delivery_status), 2) as profit_margin_avg
FROM category_profit_by_status
ORDER BY profit_category_sum DESC;

-- ---------------------------------------------------------
-- Verification: total late count vs. not late order count
-- ---------------------------------------------------------

--1 row per delivery status = total late order count vs. not late order count
SELECT
	CASE WHEN delivery_status = 'Late delivery' THEN 'LATE' ELSE 'NOT LATE' END as delivery_status,
	COUNT(*) as order_count
FROM shipments
WHERE delivery_status <> 'Shipping canceled'
GROUP BY 1