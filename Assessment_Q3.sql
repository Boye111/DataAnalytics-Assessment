-- Finding all active accounts with no transactions in the last 1 year (365 days)

WITH latest_transactions AS (
    -- Get the most recent transaction date for each plan
    SELECT
        s.plan_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM
        savings_savingsaccount s
    WHERE
		-- Only consider inflow transactions
        s.confirmed_amount > 0  
    GROUP BY
        s.plan_id
)

SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    DATE_FORMAT(lt.last_transaction_date, '%Y-%m-%d') AS last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
FROM
    plans_plan p
LEFT JOIN
    latest_transactions lt ON p.id = lt.plan_id
WHERE
    -- Only include active plans
    p.is_archived = 0
    AND p.is_deleted = 0
    AND (
        -- Check for plans with no transactions at all and plans with old transactions (Over a year)
        lt.last_transaction_date IS NULL
        OR
        DATEDIFF(CURDATE(), lt.last_transaction_date) > 365
    )
    AND (
        -- Include only savings or investment plans
        p.is_regular_savings = 1 OR p.is_a_fund = 1
    )
ORDER BY
    inactivity_days DESC;
