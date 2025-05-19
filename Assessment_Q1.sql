-- Identify customers with both savings and investment plans and sort by total deposits
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    SUM(s.confirmed_amount) AS total_deposits
FROM 
    users_customuser u
JOIN 
    plans_plan p ON u.id = p.owner_id
JOIN 
    savings_savingsaccount s ON p.id = s.plan_id
WHERE
	-- Ensuring funded plans
    s.confirmed_amount > 0
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    -- Must have at least one funded savings plan and at least one funded investment plan
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.plan_id END) >= 1
    AND 
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.plan_id END) >= 1
ORDER BY 
    total_deposits DESC;
