-- ===================================================================================================
-- Q3: What are the top 3 products in each region, and how much of the region's profit do they carry? 
-- ===================================================================================================


--Multiple rows per region = product profit for each product in each region.
WITH region_product_profit AS (
	SELECT
		r.order_region,
		p.product_name,
		SUM(oi.order_profit_per_order) AS total_product_profit
	FROM products p
	INNER JOIN order_items oi ON p.product_card_id = oi.order_item_cardprod_id 
	INNER JOIN orders o ON oi.order_id = o.order_id 
	INNER JOIN regions r ON o.region_id = r.region_id 
	GROUP BY r.order_region, p.product_name
), 

--Multiple rows per region = profit per product, total region profit, percentage of product profit to total region profit, and product ranking within each region.
region_product_profit_ranked AS (
	SELECT 
		*,
		SUM(total_product_profit) OVER(PARTITION BY order_region) AS total_region_profit,
		ROUND((total_product_profit / SUM(total_product_profit) OVER(PARTITION BY order_region)) * 100, 2) AS perc_of_total,
		RANK() OVER(PARTITION BY order_region ORDER BY total_product_profit desc) AS profit_ranking
	FROM region_product_profit 
)

--3 rows per region = top 3 products by profit and percentage of product profit to total region profit.
SELECT 
	order_region,
	product_name,
	total_product_profit,
	perc_of_total
FROM region_product_profit_ranked 
WHERE profit_ranking < 4
