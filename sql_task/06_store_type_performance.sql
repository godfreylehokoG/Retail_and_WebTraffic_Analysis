WITH monthly_sales_by_type AS (
    SELECT 
        s.store_type,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS month,
        COUNT(DISTINCT s.store_id) AS store_count,
        COUNT(o.order_id) AS order_count,
        SUM(o.order_amount) AS total_sales,
        AVG(o.order_amount) AS avg_order_value
    FROM retail_analysis.stores s
    JOIN retail_analysis.orders o ON s.store_id = o.store_id
    GROUP BY s.store_type, DATE_FORMAT(o.order_date, '%Y-%m-01')
),
store_type_metrics AS (
    SELECT 
        store_type,
        month,
        store_count,
        order_count,
        total_sales,
        avg_order_value,
        total_sales / store_count AS sales_per_store,
        LAG(total_sales) OVER (PARTITION BY store_type ORDER BY month) AS prev_month_sales,
        LEAD(total_sales) OVER (PARTITION BY store_type ORDER BY month) AS next_month_sales
    FROM monthly_sales_by_type
)
SELECT 
    store_type,
    month,
    store_count,
    order_count,
    total_sales,
    avg_order_value,
    sales_per_store,
    CASE 
        WHEN prev_month_sales IS NULL THEN NULL
        ELSE (total_sales - prev_month_sales) / prev_month_sales * 100 
    END AS mom_growth_pct
FROM store_type_metrics
ORDER BY store_type, month;