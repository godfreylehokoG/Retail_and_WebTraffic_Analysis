WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.registration_date,
        COUNT(o.order_id) AS order_count,
        SUM(o.order_amount) AS total_spending,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date,
        AVG(o.order_amount) AS avg_order_value
    FROM retail_analysis.customers c
    JOIN retail_analysis.orders o ON c.customer_id = o.customer_id
    WHERE o.order_date >= c.registration_date  -- Only include orders after registration
    GROUP BY c.customer_id, c.first_name, c.last_name, c.registration_date
),
spending_metrics AS (
    SELECT 
        *,
        DATEDIFF(first_order_date, registration_date) AS days_to_first_purchase,
        DATEDIFF(last_order_date, registration_date) AS customer_tenure_days,
        DENSE_RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
    FROM customer_spending
)
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    registration_date,
    order_count,
    total_spending,
    avg_order_value,
    days_to_first_purchase,
    customer_tenure_days,
    spending_rank,
    CASE 
        WHEN spending_rank <= 100 THEN 'Top 100'
        WHEN spending_rank <= 500 THEN 'Top 500'
        ELSE 'Other'
    END AS customer_tier
FROM spending_metrics
ORDER BY total_spending DESC;