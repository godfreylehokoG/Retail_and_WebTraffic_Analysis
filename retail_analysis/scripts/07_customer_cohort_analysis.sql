WITH customer_cohorts AS (
    SELECT 
        CONCAT(YEAR(c.registration_date), '-Q', QUARTER(c.registration_date)) AS cohort_quarter,
        COUNT(DISTINCT c.customer_id) AS cohort_size,
        SUM(CASE 
            WHEN o.order_date BETWEEN c.registration_date AND DATE_ADD(c.registration_date, INTERVAL 3 MONTH) 
            THEN o.order_amount ELSE 0 
        END) AS q0_spend,
        SUM(CASE 
            WHEN o.order_date BETWEEN DATE_ADD(c.registration_date, INTERVAL 3 MONTH) AND DATE_ADD(c.registration_date, INTERVAL 6 MONTH) 
            THEN o.order_amount ELSE 0 
        END) AS q1_spend,
        SUM(CASE 
            WHEN o.order_date BETWEEN DATE_ADD(c.registration_date, INTERVAL 6 MONTH) AND DATE_ADD(c.registration_date, INTERVAL 9 MONTH) 
            THEN o.order_amount ELSE 0 
        END) AS q2_spend,
        SUM(CASE 
            WHEN o.order_date BETWEEN DATE_ADD(c.registration_date, INTERVAL 9 MONTH) AND DATE_ADD(c.registration_date, INTERVAL 12 MONTH) 
            THEN o.order_amount ELSE 0 
        END) AS q3_spend
    FROM retail_analysis.customers c
    LEFT JOIN retail_analysis.orders o ON c.customer_id = o.customer_id AND o.order_date >= c.registration_date
    WHERE c.registration_date <= DATE_SUB('2023-12-31', INTERVAL 3 MONTH)  -- Ensure all cohorts have at least 3 months of data
    GROUP BY CONCAT(YEAR(c.registration_date), '-Q', QUARTER(c.registration_date))
)
SELECT 
    cohort_quarter,
    cohort_size,
    q0_spend,
    q1_spend,
    q2_spend,
    q3_spend,
    q0_spend / cohort_size AS q0_spend_per_customer,
    q1_spend / cohort_size AS q1_spend_per_customer,
    q2_spend / cohort_size AS q2_spend_per_customer,
    q3_spend / cohort_size AS q3_spend_per_customer,
    CASE 
        WHEN q0_spend = 0 THEN NULL
        ELSE q1_spend / q0_spend * 100 
    END AS q0_to_q1_retention_pct,
    CASE 
        WHEN q1_spend = 0 THEN NULL
        ELSE q2_spend / q1_spend * 100 
    END AS q1_to_q2_retention_pct,
    CASE 
        WHEN q2_spend = 0 THEN NULL
        ELSE q3_spend / q2_spend * 100 
    END AS q2_to_q3_retention_pct
FROM customer_cohorts
ORDER BY cohort_quarter;