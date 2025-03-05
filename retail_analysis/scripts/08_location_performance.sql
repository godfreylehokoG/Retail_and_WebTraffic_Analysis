WITH location_sales AS (
    SELECT 
        s.location,
        COUNT(DISTINCT s.store_id) AS store_count,
        GROUP_CONCAT(DISTINCT s.store_type ORDER BY s.store_type SEPARATOR ', ') AS store_types,
        COUNT(o.order_id) AS order_count,
        SUM(o.order_amount) AS total_sales,
        AVG(o.order_amount) AS avg_order_value
    FROM retail_analysis.stores s
    LEFT JOIN retail_analysis.orders o ON s.store_id = o.store_id
    GROUP BY s.location
),
location_metrics AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
        PERCENT_RANK() OVER (ORDER BY total_sales DESC) AS sales_percentile,
        total_sales / store_count AS sales_per_store,
        NTILE(4) OVER (ORDER BY total_sales / store_count DESC) AS performance_quartile
    FROM location_sales
)
SELECT 
    location,
    store_count,
    store_types,
    order_count,
    total_sales,
    avg_order_value,
    sales_per_store,
    sales_rank,
    sales_percentile,
    CASE 
        WHEN performance_quartile = 1 THEN 'Top Performer'
        WHEN performance_quartile = 2 THEN 'Above Average'
        WHEN performance_quartile = 3 THEN 'Below Average'
        WHEN performance_quartile = 4 THEN 'Underperformer'
    END AS performance_category
FROM location_metrics
ORDER BY sales_per_store DESC;