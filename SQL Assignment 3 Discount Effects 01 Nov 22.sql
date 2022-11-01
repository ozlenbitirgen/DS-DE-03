WITH T1 AS(
		SELECT product_id, COUNT(product_id) discount_per_product, discount
		FROM sale.order_item
		GROUP BY product_id, discount
), T2 AS (
		SELECT product_id, discount_per_product, discount, AVG(discount_per_product) OVER (PARTITION BY product_id) avg_discount
		FROM T1
), T3 AS(
		SELECT *,
		CASE
			WHEN discount='0.20' OR discount='0.10' THEN discount_per_product
		END AS Positive,
        CASE
			WHEN discount='0.07' OR discount='0.05' THEN discount_per_product
		END AS Negative
FROM T2
), T4 AS(
SELECT product_id, SUM(Positive) OVER (PARTITION BY product_id) Positive_Effect,
       SUM(Negative) OVER (PARTITION BY product_id) Negative_Effect
FROM T3
) 
SELECT DISTINCT product_id,
       CASE 
			WHEN Positive_Effect>Negative_Effect THEN 'Positive'
			WHEN Positive_Effect<Negative_Effect THEN 'Negative'
			WHEN Positive_Effect=Negative_Effect THEN 'Neutral'
			ELSE 'Neutral'
  	   END AS Discount_Effect
FROM T4