# Credit-Card-Transactions
A data analytics project to uncover patterns in credit card usage, identify suspicious transactions, and generate actionable business insights using SQL.

🎯 Objective
To perform structured data analysis on credit card transaction data and:
*Understand customer spending behavior
*Identify peak usage trends and merchant types
*Detect unusual or fraudulent transaction patterns
*Support risk management and product strategy

🧰 Tools & Technologies

*SQL (PostgreSQL / MySQL / SQL Server)
*DBMS / DBeaver / pgAdmin (for execution)
*Excel or PowerPoint (for visualizations, if needed)

🗂️ Data Overview

Main Tables Used:
*transactions – Includes transaction ID, timestamp, amount, merchant, category
*customers – Customer demographics (age, city, income group)
*cards – Card type, issue date, status


🔍 Key Analyses Performed

🧾 Monthly transaction volume and total spend

💳 Spend distribution by card type (Gold, Platinum, etc.)

🌐 Most used merchant categories (e.g., Travel, Retail, Food)

📍 City-wise spending behavior

Tier-1 cities show higher average transaction values

Platinum card holders have fewer but higher value transactions

🚧 Challenges Faced

Data contained missing customer locations and card types
Needed to deduplicate transactions with same ID and timestamp
Handled outliers in amount distribution using percentiles

✨ Learnings

Strengthened SQL fluency with CTEs, window functions, and joins
Learned how to structure analysis in stages (ETL → insights → storytelling)
Understood real-world fraud indicators and risk triggers
