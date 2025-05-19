# Cowrywise DataAnalytics-Assessment BY AKINGBELURE ADEBOYE


# Question 1: High-Value Customers with Multiple Products

Find users who have both funded savings and investment plans, then rank them by total deposit amount.

### Approach:  
- Used JOIN clauses to combine users_customuser, plans_plan, and savings_savingsaccount tables
- Applied CASE logic to count distinct savings plans (is_regular_savings = 1) and investment plans (is_a_fund = 1) per user
- Concatenated first_name and last_name fields to create complete customer names
- Aggregated confirmed_amount to calculate total deposits
- Filtered for users with at least one funded savings plan AND one funded investment plan

### Challenges:  
- Ensuring only funded plans were considered.
- Preventing duplicate plan counts by using DISTINCT clause inside CASE clause statements.


# Question 2: Transaction Frequency Analysis  

Classify customers into High, Medium, or Low Frequency segments based on their monthly transaction behavior.

### Approach: 
- Used a first CTE (customer_monthly_transactions) to count transactions per user per month
- Used a second CTE (customer_avg_monthly) to calculate average monthly transactions for each customer
- Applied categorization logic with a CASE statement based on transaction frequency thresholds
- Final aggregation counted users per category and calculated average transactions within each segment.

### Challenges:  
- Grouping correctly by both YEAR and MONTH to handle date aggregation.
- Defining intuitive category thresholds (>=10, >=3) for segmentation.


# Question 3: Account Inactivity Alert In A Year  
My main objective was to Detect active (non-archived, non-deleted) savings/investment plans that haven't had inflow transactions in the past 365 days.

### Approach:  
- Created a CTE (latest_transactions) to get each plan's most recent inflow transaction.
- Used LEFT JOIN to account for plans with no transactions at all.
- Filtered for plans with either NULL last transaction date or inactivity > 365 days.
- Labeled plan type and calculated inactivity days using DATEDIFF.

### Challenges:  
- Accounting for plans with no transaction history ('IS NULL' logic).
- Ensuring only *active* plans and specific types (savings/investment) were considered.
  

# Question 4: Customer Lifetime Value (CLV) Estimation
My major object was to estimate CLV using account tenure and transaction behavior using this formula (CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)).

### Approach:
- Created a CTE to compute tenure in months, transaction count, and total amount.
- Used a simplified CLV formula:  
  CLV = (Monthly Txns) * 12 * (Avg Transaction Amount * 0.001) (since 0.1% is 0.001)
- 'NULLIF' was used to protect against division by zero in average calculations.

### Challenges:
- Handling edge cases like users with zero months of tenure.
- Ensuring only positive transactions were considered to reflect realistic CLV.

# NOTE.
All my calculations on the deposits or amount of any sort was left in kobo since there was no explicit instruction to convert it to Naira.
