-- 04_analysis_queries.sql

USE DunkinsBeverageDB;
GO

-- 1. Overall KPI summary
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Units_Sold,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(SUM(Profit) / NULLIF(SUM(Sales), 0) AS DECIMAL(10,4)) AS Profit_Margin,
    CAST(SUM(Sales) / NULLIF(COUNT(DISTINCT Order_ID), 0) AS DECIMAL(10,2)) AS Average_Order_Value
FROM dbo.BeverageSales_Clean;

-- 2. Monthly sales trend
SELECT
    FORMAT(Order_Date, 'yyyy-MM') AS Sales_Month,
    SUM(Sales) AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit,
    COUNT(DISTINCT Order_ID) AS Orders
FROM dbo.BeverageSales_Clean
GROUP BY FORMAT(Order_Date, 'yyyy-MM')
ORDER BY Sales_Month;

-- 3. Sales by product category
SELECT
    Product_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Units_Sold
FROM dbo.BeverageSales_Clean
GROUP BY Product_Category
ORDER BY Total_Sales DESC;

-- 4. Sales by region
SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM dbo.BeverageSales_Clean
GROUP BY Region
ORDER BY Total_Sales DESC;

-- 5. Top 10 products
SELECT TOP 10
    Product_Name,
    Product_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Units_Sold
FROM dbo.BeverageSales_Clean
GROUP BY Product_Name, Product_Category
ORDER BY Total_Sales DESC;

-- 6. Channel performance
SELECT
    Sales_Channel,
    SUM(Sales) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Orders
FROM dbo.BeverageSales_Clean
GROUP BY Sales_Channel
ORDER BY Total_Sales DESC;

-- 7. Daypart performance
SELECT
    Daypart,
    SUM(Sales) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Orders
FROM dbo.BeverageSales_Clean
GROUP BY Daypart
ORDER BY Total_Sales DESC;

-- 8. Order status analysis
SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.BeverageSales_Clean
GROUP BY Order_Status
ORDER BY Orders DESC;
GO
