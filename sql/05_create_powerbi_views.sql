-- 05_create_powerbi_views.sql

USE DunkinsBeverageDB;
GO

CREATE OR ALTER VIEW dbo.vw_BeverageSales_Fact AS
SELECT
    Order_ID,
    Order_Date,
    Store_ID,
    Store_Name,
    Region,
    State,
    City,
    Product_ID,
    Product_Name,
    Product_Category,
    Beverage_Size,
    Temperature,
    Quantity,
    Unit_Price,
    Discount,
    Sales,
    Cost,
    Profit,
    Sales_Channel,
    Payment_Method,
    Customer_Type,
    Promo_Flag,
    Loyalty_Member,
    Order_Status,
    Weather,
    Daypart,
    FORMAT(Order_Date, 'yyyy-MM') AS Sales_Month,
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month_Number
FROM dbo.BeverageSales_Clean;
GO

CREATE OR ALTER VIEW dbo.vw_Beverage_KPI_Summary AS
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Units_Sold,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(SUM(Profit) / NULLIF(SUM(Sales), 0) AS DECIMAL(10,4)) AS Profit_Margin,
    CAST(SUM(Sales) / NULLIF(COUNT(DISTINCT Order_ID), 0) AS DECIMAL(10,2)) AS Average_Order_Value
FROM dbo.BeverageSales_Clean;
GO
