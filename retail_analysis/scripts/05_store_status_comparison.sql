WITH store_status_sales AS (
    SELECT 
        s.open_status,
        COUNT(DISTINCT s.store_id) AS store_count,
        COUNT(o.order_id) AS order_count,
        SUM(o.order_amount) AS total_sales,
        AVG(o.order_amount) AS avg_order_value,
        SUM(o.order_amount) / COUNT(DISTINCT s.store_id) AS sales_per_store
    FROM retail_analysis.stores s
    LEFT JOIN retail_analysis.orders o ON s.store_id = o.store_id
    GROUP BY s.open_status
),
store_status_metrics AS (
    SELECT 
        *,
        (SELECT SUM(total_sales) FROM store_status_sales) AS company_total_sales,
        total_sales / (SELECT SUM(total_sales) FROM store_status_sales) * 100 AS pct_of_total_sales
    FROM store_status_sales
)
SELECT 
    open_status,
    store_count,
    order_count,
    total_sales,
    ROUND(pct_of_total_sales, 2) AS pct_of_total_sales,
    avg_order_value,
    sales_per_store
FROM store_status_metrics
ORDER BY total_sales DESC;