create database Pizza_Sales;
Use Pizza_Sales;
SELECT * FROM dominoz;
 
Alter table dominoz
add Primary key (Pizza_id);

CREATE VIEW Table_Per_Order AS
    (SELECT 
        Order_id,
        SUM(Total_Price) AS Price_per_Order,
        SUM(Quantity) AS Pizza_per_Order
    FROM Dominoz
    GROUP BY Order_id);

-------------- A. Primary_KPI ------------------
#1. Total Revenue:
Select Round(Sum(Total_Price), 2) as `Total Revenue`
From Dominoz;

SELECT 
    ROUND(AVG(Price_Per_Order), 2) AS Avg_Order_Value
FROM Table_per_Order;

SELECT 
    SUM(Quantity) AS Total_Pizza_Sold
FROM Dominoz;

SELECT 
    COUNT(DISTINCT Order_id) AS Total_Order
FROM dominoz;

SELECT 
    ROUND(AVG(Pizza_per_Order), 2) AS Avg_Pizza_per_Order
FROM table_per_order;

-------------- B. Daily Trends For Total Orders ---------------
SELECT 
    DAYNAME(Order_Date) AS Weakday,
    COUNT(DISTINCT Order_id) AS 'Total Orders'
FROM Dominoz
GROUP BY Weakday
ORDER BY COUNT(DISTINCT Order_id) DESC;

-------------- C. Hourly Trends For Orders --------------
SELECT 
    EXTRACT(HOUR FROM Order_time) AS Hours,
    COUNT(DISTINCT Order_id) AS 'Total Order'
FROM dominoz
GROUP BY Hours
ORDER BY COUNT(DISTINCT Order_id) DESC;

-------------- D. % of Sales by Pizza Catagory -----------------
Select
	Pizza_Category,
    Round(Sum(Total_Price), 2) as Total_Revenue,
    Round(Sum(Total_Price) * 100 / (Select Sum(total_price) From Dominoz), 2) as Percent_Sales
From dominoz
Group by Pizza_Category
Order by Percent_Sales Desc;
    
----------------- E. % of Sales by Pizza size ---------------
Select
	Pizza_Size, 
    Round(Sum(Total_Price), 2) as Total_Revenue,
    Round(Sum(Total_Price) * 100 / (Select Sum(total_price) From Dominoz), 2) as Percent_Sales
From dominoz
Group by Pizza_Size
Order by Percent_Sales Desc;
    
-------------- F. Total Pizza Sold by Catagory -----------------
Select 
	Distinct Pizza_category,
	sum(Quantity) over(Partition by Pizza_category) as Pizza_Sold
From Dominoz
Order by Pizza_Sold Desc;

-------------- G. Top 5 Best seller by Total Pizza Sold ------------
Select 
	Distinct Pizza_Name,
    Sum(Quantity) over(Partition by Pizza_name) as Total_Pizza
From dominoz
Order by Total_pizza Desc
Limit 5; 

-------------- H. Bottom 5 Seller by Total Pizza Sold --------------
Select 
	Distinct Pizza_Name, 
    Sum(Quantity) over(Partition by Pizza_name) as Total_Pizza
From dominoz
Order by Total_pizza
Limit 5; 

------------------- END ---------------------










