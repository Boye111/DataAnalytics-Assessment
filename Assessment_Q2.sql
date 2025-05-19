-- Categorizing customers based on their transaction frequency
WITH customer_monthly_transactions AS (
    -- Calculate transactions per customer per month
    SELECT
        s.owner_id,
        YEAR(s.transaction_date) AS year,
        MONTH(s.transaction_date) AS month,
        COUNT(*) AS num_transactions
    FROM
        savings_savingsaccount s
    WHERE
		-- Count positive transactions
        s.confirmed_amount > 0  
    GROUP BY
        s.owner_id, YEAR(s.transaction_date), MONTH(s.transaction_date)
),
customer_avg_monthly AS (
    -- Calculate average monthly transactions for each customer
    SELECT
        owner_id,
        AVG(num_transactions) AS avg_transactions_per_month
    FROM
        customer_monthly_transactions
    GROUP BY
        owner_id
),

customer_categories AS (
    -- Categorizing customers based on average monthly transactions
    SELECT
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        owner_id,
        avg_transactions_per_month
    FROM
        customer_avg_monthly
)

-- Final Aggregation by category
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM
    customer_categories
GROUP BY
    frequency_category
ORDER BY
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END;
