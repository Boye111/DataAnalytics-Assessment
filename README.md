# DataAnalytics-Assessment
# Cowrywise Assessement

# Question 1: High-Value Customers with Multiple Products

Find users who have both funded savings and investment plans, then rank them by total deposit amount.

Approach:  
- Used JOIN Clause to combine users, plans, and savings tables.
- Applied CASE clause logic to count distinct savings and investment plan types per user.
- Aggregated confirmed_amount to calculate total deposits.
- Filtered only users who have at least one funded savings plan and one funded investment plan.

Challenges:  
- Ensuring only funded plans were considered.
- Preventing duplicate plan counts by using DISTINCT clause inside CASE clause statements.


# Question 2: Transaction Frequency Analysis  

Classify customers into High, Medium, or Low Frequency segments based on their monthly transaction behavior.

Approach: 
- Used a Common Table Expression(CTE) (customer_monthly_transactions) to count monthly transactions per user.
- Used Another CTE (customer_avg_monthly) calculated the average monthly transactions.
- Categorized customers using a CASE expression.
- Final aggregation counted users per category and showed average transactions.

Challenges:  
- Grouping correctly by both YEAR and MONTH to handle date aggregation.
- Defining intuitive category thresholds (>=10, >=3) for segmentation.


# Question 3: Account Inactivity Alert In A Year  
My main objective was to Detect active (non-archived, non-deleted) savings/investment plans that haven't had inflow transactions in the past 365 days.

Approach:  
- Created a CTE (latest_transactions) to get each plan's most recent inflow transaction.
- Used LEFT JOIN to account for plans with no transactions at all.
- Filtered for plans with either NULL last transaction date or inactivity > 365 days.
- Labeled plan type and calculated inactivity days using DATEDIFF.

Challenges:  
- Accounting for plans with no transaction history ('IS NULL' logic).
- Ensuring only *active* plans and specific types (savings/investment) were considered.
  

# Question 4: Customer Lifetime Value (CLV) Estimation
My major object was to estimate CLV using account tenure and transaction behavior using this formula (CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)).

Approach:
- Created a CTE to compute tenure in months, transaction count, and total amount.
- Used a simplified CLV formula:  
  CLV = (Monthly Txns) * 12 * (Avg Transaction Amount * 0.001) (since 0.1% is 0.001)
- 'NULLIF' was used to protect against division by zero in average calculations.

Challenges:
- Handling edge cases like users with zero months of tenure.
- Ensuring only positive transactions were considered to reflect realistic CLV.
