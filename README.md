SQL Window Functions Analysis – AdventureWorks

Project Overview

This project focuses on learning and applying SQL window functions using the AdventureWorks database in SQL Server Management Studio (SSMS). The analysis covers customer sales, product rankings, monthly sales comparisons, and customer ordering patterns.

Objective

- Understand and apply SQL window functions.
- Rank customers and products based on sales.
- Compare monthly sales using previous-period values.
- Analyze customer ordering patterns.
- Generate useful business insights using SQL.

Tools Used

- SQL Server Management Studio (SSMS)
- Microsoft SQL Server
- AdventureWorks Database

SQL Concepts Covered

- "ROW_NUMBER()"
- "RANK()"
- "DENSE_RANK()"
- "LAG()"
- "PARTITION BY"
- Common Table Expressions (CTEs)
- Aggregate functions such as "SUM()"
- Joins and date functions

Analysis Performed

The project includes 12 SQL queries:

1. Assign row numbers to sales orders.
2. Rank customers by total sales.
3. Rank products by total revenue.
4. Compare "RANK()" and "DENSE_RANK()".
5. Identify the top five customer sales ranks.
6. Rank products within each category.
7. Compare monthly sales with the previous month.
8. Calculate month-over-month sales changes.
9. Compare each customer's order with their previous order.
10. Calculate days between consecutive customer orders.
11. Identify the highest-revenue product in each category.
12. Combine customer sales ranking and "LAG()" for comparison.

Key Learnings

- Window functions allow calculations across related rows without collapsing the result into a single row per group.
- "ROW_NUMBER()" assigns a unique sequential number to each row.
- "RANK()" assigns the same rank to tied values and skips subsequent ranks.
- "DENSE_RANK()" assigns the same rank to tied values without skipping subsequent ranks.
- "LAG()" retrieves a value from a previous row.
- "PARTITION BY" restarts a window calculation for each group.

Business Applications

- Identify high-revenue customers.
- Find top-performing products within categories.
- Track monthly sales growth and decline.
- Understand the time between customer purchases.
- Compare customer sales performance.

Project Files

- "README.md" – Project overview, objectives, and learnings.
- "SQL_Window_Functions.sql" – SQL queries used in the analysis.

Conclusion

This project provided practical experience with SQL window functions and their applications in business data analysis. It helped build a better understanding of ranking, comparing records, and analyzing customer and product sales data using SQL.# SQL-Window-Function-Analysis
SQL Server project using AdventureWorks to analyze customer sales, rank products, compare monthly revenue, and explore customer ordering patterns using window functions such as ROW_NUMBER(), RANK(), DENSE_RANK(), and LAG().
