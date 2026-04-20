-- QUESTION 1:
/* 
Write an SQL query to calculate the total sales of furniture products, grouped by each quarter of the year, 
and order the results chronologically. 
*/
select  
concat('Q',DATEPART(QUARTER,o.ship_date),' - ',DATEPART(YEAR,O.Ship_date)) Quater_Year, 
round(sum(o.Sales),2) Total_Sales

from ORDERS o
left join product p on o.PRODUCT_ID = p.ID
where p.name = 'Furniture'
GROUP BY DATEPART(year, o.ship_date), DATEPART(quarter, o.ship_date)
order by DATEPART(year, o.ship_date), DATEPART(quarter, o.ship_date) asc


-- QUESTION 2:
/* 
Analyze the impact of different discount levels on sales performance across product categories, 
specifically looking at the number of orders and total profit generated for each discount classification.

Discount le
vel condition:
No Discount = 0
0 < Low Discount <= 0.2
0.2 < Medium Discount <= 0.5
High Discount > 0.5 
*/
Select p.CATEGORY, 
case 
	when o.DISCOUNT = 0 then 'No Discount'
	when 0 < o.DISCOUNT and o.DISCOUNT <= 0.2 then 'Low Discount'
	when 0.2 < o.DISCOUNT and o.DISCOUNT <= 0.5 then 'Medium Discount'
	when o.DISCOUNT > 0.5 then 'High Discount'
	End as DiscountLevel,
count(distinct o.ORDER_ID) TotalOrders, round(sum(o.PROFIT),2) Profit

from orders o
left join PRODUCT p on o.PRODUCT_ID = p.ID
group by p.CATEGORY,case 
	when o.DISCOUNT = 0 then 'No Discount'
	when 0 < o.DISCOUNT and o.DISCOUNT <= 0.2 then 'Low Discount'
	when 0.2 < o.DISCOUNT and o.DISCOUNT <= 0.5 then 'Medium Discount'
	when o.DISCOUNT > 0.5 then 'High Discount'
	End  
Order by p.CATEGORY


-- QUESTION 3:
/* 
Determine the top-performing product categories within each customer segment based on sales and profit, 
focusing specifically on those categories that rank within the top two for profitability. 
*/
With RankProduct as (
select c.SEGMENT, p.CATEGORY,
RANK() OVER (PARTITION BY c.segment ORDER BY sum(o.PROFIT) desc ) AS Profit_Rank, 
RANK() OVER (PARTITION BY c.segment ORDER BY sum(o.Sales) desc) AS Sale_Rank
from orders o 
left join CUSTOMER c on o.CUSTOMER_ID = c.ID
left join PRODUCT p on o.PRODUCT_ID = p.ID 
GROUP BY c.SEGMENT, p.CATEGORY
)

select rp.SEGMENT, rp.CATEGORY, Sale_Rank,

Profit_Rank

from RankProduct rp

where Profit_Rank <= 2
ORDER BY rp.SEGMENT, rp.Profit_Rank 



-- QUESTION 4
/*
Create a report that displays each employee's performance across different product categories, showing not only the 
total profit per category but also what percentage of their total profit each category represents, with the result 
ordered by the percentage in descending order for each employee.
*/


WITH ProfitByCategory AS (
    SELECT 
        o.ID_EMPLOYEE,
        p.CATEGORY,
        SUM(o.PROFIT) AS ProfitCategory
    FROM ORDERS o
    LEFT JOIN EMPLOYEES e ON o.ID_EMPLOYEE = e.ID_EMPLOYEE
    LEFT JOIN PRODUCT p ON o.PRODUCT_ID = p.ID
    GROUP BY o.ID_EMPLOYEE, p.CATEGORY
),
TotalProfitByEmployee AS (
    SELECT 
        ID_EMPLOYEE,
        SUM(ProfitCategory) AS TotalProfit
    FROM ProfitByCategory
    GROUP BY ID_EMPLOYEE
)
SELECT 
    pc.ID_EMPLOYEE,
    pc.CATEGORY,
    round(pc.ProfitCategory,2) Total_Profit,
    ROUND(pc.ProfitCategory * 100.0 / tp.TotalProfit, 2) AS ProfitPercentage
FROM ProfitByCategory pc
JOIN TotalProfitByEmployee tp 
    ON pc.ID_EMPLOYEE = tp.ID_EMPLOYEE
ORDER BY pc.ID_EMPLOYEE, ProfitPercentage desc



-- QUESTION 5:
/*
Develop a user-defined function in SQL Server to calculate the profitability ratio for each product category 
an employee has sold, and then apply this function to generate a report that sorts each employee's product categories
by their profitability ratio.
*/

DROP FUNCTION IF EXISTS dbo.ProfitabilityRatio;
GO

CREATE FUNCTION dbo.ProfitabilityRatio()
RETURNS @Result TABLE
(
    ID_Employee INT,
    CATEGORY NVARCHAR(100),
    Total_Sales DECIMAL(18,2),
    Total_Profit DECIMAL(18,2),
    ProfitabilityRatio DECIMAL(18,4)
)
AS
BEGIN
    INSERT INTO @Result
    SELECT 
        o.ID_EMPLOYEE,
        p.CATEGORY,
        SUM(o.Sales) AS Total_Sales,
        SUM(o.Profit) AS Total_Profit,
        SUM(o.Profit) * 1.0 / NULLIF(SUM(o.Sales), 0) AS ProfitabilityRatio
    FROM ORDERS o
    LEFT JOIN Product p 
        ON o.PRODUCT_ID = p.ID
    GROUP BY 
        o.ID_EMPLOYEE, 
        p.CATEGORY;

    RETURN;
END;
GO

SELECT *
FROM dbo.ProfitabilityRatio()
ORDER BY ID_Employee, ProfitabilityRatio DESC;

-- QUESTION 6:
/* 
Write a stored procedure to calculate the total sales and profit for a specific EMPLOYEE_ID over a specified date range. 
The procedure should accept EMPLOYEE_ID, StartDate, and EndDate as parameters.
*/
Drop PROCEDURE DBO.GetEmployeeSalesProfit
GO
CREATE PROCEDURE DBO.GetEmployeeSalesProfit
@Employee_ID INT,
@StartDate DATETIME,
@EndDate DATETIME 
AS
BEGIN
    SELECT e.NAME, round(sum(o.profit),2) Total_Profit, round(sum(o.sales),2) Total_Sales
    from orders o
    left join EMPLOYEES e on o.ID_EMPLOYEE = e.ID_EMPLOYEE
    where o.ID_EMPLOYEE = @Employee_ID
    and ORDER_DATE BETWEEN @StartDate AND @EndDate 
    group by e.NAME;
    END;
GO 

-- Gọi
EXEC dbo.GetEmployeeSalesProfit
    @Employee_ID = 3,
    @StartDate = '2016-12-01', 
    @EndDate   = '2016-12-31';

-- QUESTION 7:
/*
Write a query using dynamic SQL query to calculate the total profit for the last six quarters in the datasets, 
pivoted by quarter of the year, for each state.
*/


DECLARE @cols NVARCHAR(MAX);
DECLARE @sql  NVARCHAR(MAX);



SELECT @cols = STRING_AGG(
                   CAST(QUOTENAME(QuarterLabel) AS NVARCHAR(MAX)), ','
               ) WITHIN GROUP (ORDER BY YearVal desc, QuarterVal desc)

FROM (
    SELECT DISTINCT 
        CONCAT('Q', DATEPART(QUARTER, ORDER_DATE), ' - ', DATEPART(YEAR, ORDER_DATE)) AS QuarterLabel,
         DATEPART(YEAR, o.ORDER_DATE) AS YearVal,
        DATEPART(QUARTER, o.ORDER_DATE) AS QuarterVal

    FROM Orders o
    WHERE ORDER_DATE > DATEADD(QUARTER, -6, (SELECT MAX(ORDER_DATE) FROM Orders))
) AS q;  


SET @sql = '
SELECT State, ' + @cols + '
FROM (
    SELECT 
        State,
        CONCAT(''Q'', DATEPART(QUARTER, ORDER_DATE), '' - '', DATEPART(YEAR, ORDER_DATE)) AS QuarterLabel,
        Profit
    FROM Orders o
    left join customer c on c.id = o.customer_id
    WHERE ORDER_DATE > DATEADD(QUARTER, -6, (SELECT MAX(ORDER_DATE) FROM Orders))
) AS src
PIVOT (
    SUM(Profit)
    FOR QuarterLabel IN (' + @cols + ')
) AS pvt
ORDER BY state ;
';

EXEC sp_executesql @sql;




SELECT *
FROM Orders
WHERE Sales IS NULL OR Profit IS NULL


SELECT Order_ID, COUNT(*) Order_count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1


SELECT *
FROM Orders
WHERE Sales < 0 OR Profit < 0