-- =========================================================
-- Q1: Which shipping modes underperform within each market?
-- =========================================================


--Multiple rows per market = Shipping mode used and status of delivery.
WITH market_delivery_mode_status AS (
    SELECT
        shipping_mode,
       	delivery_status,
        market
    FROM shipping_modes AS sm
    INNER JOIN shipments AS s ON sm.mode_id = s.mode_id
    INNER JOIN orders AS o ON s.order_id = o.order_id
    INNER JOIN regions AS r ON o.region_id = r.region_id
    WHERE delivery_status <> 'Shipping canceled'
        AND o.order_status NOT IN ('CANCELED', 'SUSPECTED_FRAUD')
), 

--4 rows per market = late delivery rate of each shipping mode.
late_status_rate AS (
	SELECT 
		shipping_mode,
		market,
		ROUND(COUNT(*) FILTER(WHERE delivery_status = 'Late delivery')::numeric
            / COUNT(*) * 100, 2) AS late_rate
	FROM market_delivery_mode_status mdms
	GROUP BY market, shipping_mode
)

--5 rows per shipping mode = shipping mode ranked by late delivery rate within each market.
SELECT 
	*,
	RANK() OVER(PARTITION BY market ORDER BY late_rate DESC) AS late_rank
FROM late_status_rate lsr
ORDER BY late_rank;


-- ---------------------------------------------------------
-- Verification 1: Is First Class late by design? Check if
-- scheduled days ever exceeds real days (it shouldn't, if
-- every First Class order is structurally late).
-- ---------------------------------------------------------

--No rows 
SELECT
	shipping_mode,
	days_for_shipping_real,
	days_for_shipment_scheduled
FROM
	shipping_modes
INNER JOIN shipments ON shipments.mode_id = shipping_modes.mode_id
WHERE shipping_mode = 'First Class' AND days_for_shipment_scheduled >= days_for_shipping_real