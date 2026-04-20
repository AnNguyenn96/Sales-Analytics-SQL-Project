-- QUESTION 1:
/* 
Write an SQL query to calculate the total sales for all products belonging to the 'Furniture' product line, 
grouped by quarter and year. Return two columns: Quarter_Year formatted as Q{quarter}-{year} (e.g. Q1-2014), 
and Total_Sales as the rounded total sales for that quarter. Order the results chronologically from the 
earliest to the most recent quarter.
*/

-- QUESTION 2:
/* 
For each product category, classify orders into four discount tiers: No Discount, Low, Medium, and High. 
For each category/tier combination, calculate the total number of order lines and total profit. 
Order results by category and discount tier.

Discount level tiers:
No Discount = 0%
0% < Low Discount <= 20%
20% < Medium Discount <= 50%
High Discount > 50% 
*/

-- QUESTION 3:
/* 
For each customer segment, aggregate total sales and total profit by product category, then rank the categories
within each segment by total profit (highest to lowest). Return only the top 2 ranked categories per segment, 
including their total sales, total profit, and profit rank.
*/

-- QUESTION 4
/*
For each employee, calculate the total profit per product category they have sold. Then compute each category's
profit contribution (%) as its share of that employee's overall total profit across all categories. Return the 
employee ID, employee name, category, total profit, and profit contribution percentage. Order the results by 
employee, then by profit contribution percentage from highest to lowest.
*/

-- QUESTION 5:
/*
Create a scalar user-defined function that takes an employee ID and a product category as inputs and returns 
the profitability ratio, defined as Total Profit / Total Sales for that employee–category combination 
(return NULL if total sales is zero or NULL). Then use this function in a report query that returns 
each employee's ID, name, product category, total sales, total profit, and the computed profitability ratio. 
Order results by employee, then by profitability ratio from highest to lowest.
*/

-- QUESTION 6:
/* 
Create a stored procedure that accepts EMPLOYEE_ID, StartDate, and EndDate as parameters and returns a single 
row containing the employee's ID, name, total sales, and total profit for all orders placed within the given 
date range (inclusive on both ends). If no orders exist for that employee in the specified range, the procedure
should return no rows.
Test with: 
EXEC GetEmployeeSalesProfit @EmployeeID = 3, @StartDate = '2016-12-01', @EndDate = '2016-12-31';
*/

-- QUESTION 7:
/*
Write a stored procedure using dynamic SQL that pivots total profit by the last 6 quarters found in the dataset,
with one row per state. The procedure should:
-	Automatically detect the 6 most recent quarters from the ORDERS table
-	Output one column per quarter, named in the format Q{quarter}-{year} (e.g. Q4-2017), ordered from most 
recent to oldest left to right
-	Output one row per customer STATE, showing the rounded total profit for each quarter (NULL if no orders 
existed for that state in that quarter)
-	Order rows alphabetically by state
The procedure must remain correct if new quarterly data is added in the future.
*/

