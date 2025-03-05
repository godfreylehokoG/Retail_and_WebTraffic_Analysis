-- Query 6: MySQL RFM Analysis - Segments customers by recency, frequency, and monetary value
WITH customer_rfm AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF('2023-12-31', MAX(o.order_date)) AS recency,
        COUNT(o.order_id) AS frequency,
        SUM(o.order_amount) AS monetary
    FROM retail_analysis.customers c
    JOIN retail_analysis.orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, customer_name
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM customer_rfm
)
SELECT 
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_score,
    CASE 
        WHEN (r_score >= 4 AND f_score >= 4 AND m_score >= 4) THEN 'Champions'
        WHEN (r_score >= 3 AND f_score >= 3 AND m_score >= 3) THEN 'Loyal Customers'
        WHEN (r_score >= 3 AND f_score <= 2 AND m_score >= 3) THEN 'Potential Loyalists'
        WHEN (r_score <= 2 AND f_score <= 2 AND m_score <= 2) THEN 'At Risk'
        WHEN (r_score = 1 AND f_score >= 3) THEN 'Can\'t Lose Them'
        WHEN (r_score <= 2 AND f_score >= 4 AND m_score >= 4) THEN 'Need Attention'
        WHEN (r_score >= 4 AND f_score <= 2 AND m_score <= 2) THEN 'New Customers'
        WHEN (r_score >= 4 AND f_score <= 1 AND m_score <= 1) THEN 'Promising'
        WHEN (r_score <= 2 AND f_score <= 1 AND m_score <= 1) THEN 'About to Sleep'
        ELSE 'Others' 
    END AS segment
FROM rfm_scores
ORDER BY segment, monetary DESC;