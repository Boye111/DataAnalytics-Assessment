-- Customer Lifetime Value (CLV) Estimation based on account tenure and transaction volume
WITH customer_metrics AS (
    SELECT
        u.id,
        u.first_name,
        u.last_name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) AS total_amount
    FROM
        users_customuser u
    JOIN
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE
		-- Only include positive transactions and avoiding division by zero for tenure
        s.confirmed_amount > 0
        AND TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) > 0 
    GROUP BY
        u.id, u.first_name, u.last_name, u.date_joined
)

SELECT
    cm.id AS customer_id,
    CONCAT(cm.first_name, ' ', cm.last_name) AS name,
    cm.tenure_months,
    cm.total_transactions,
    -- Calculate CLV with protection against division by zero
    ROUND(
        (cm.total_transactions / cm.tenure_months) 
        * 12 
        * (cm.total_amount * 0.001 / NULLIF(cm.total_transactions, 0)),
        2
    ) AS estimated_clv
FROM
    customer_metrics cm
ORDER BY
    estimated_clv DESC;
