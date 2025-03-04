WITH store_performance AS (
    SELECT 
        s.store_id,
        s.store_name,
        s.store_type,
        s.location,
        s.open_status,
        COUNT(o.order_id) AS order_count,
        SUM(o.order_amount) AS total_sales,
        AVG(o.order_amount) AS avg_order_value
    FROM retail_analysis.stores s
    LEFT JOIN retail_analysis.orders o ON s.store_id = o.store_id
    WHERE o.order_date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY s.store_id, s.store_name, s.store_type, s.location, s.open_status
)
SELECT 
    store_id,
    store_name,
    store_type,
    location,
    open_status,
    order_count,
    total_sales,
    avg_order_value,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    PERCENT_RANK() OVER (ORDER BY total_sales DESC) AS sales_percentile,
    NTILE(4) OVER (ORDER BY total_sales DESC) AS sales_quartile
FROM store_performance
ORDER BY total_sales DESC;