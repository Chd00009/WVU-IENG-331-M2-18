WITH revenue AS (
    SELECT
        product_id,
        SUM(price) AS total_revenue
   FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE ($1 IS NULL OR o.order_purchase_timestamp >= $1)
  AND ($2 IS NULL OR o.order_purchase_timestamp <= $2)
GROUP BY product_id
),
ranked AS (
    SELECT
        product_id,
        total_revenue,
        SUM(total_revenue) OVER () AS total_sum,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS cumulative_sum
    FROM revenue
)
SELECT
    product_id,
    total_revenue,
    cumulative_sum / total_sum AS cumulative_pct,
    CASE
        WHEN cumulative_sum / total_sum <= 0.8 THEN 'A'
        WHEN cumulative_sum / total_sum <= 0.95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM ranked;