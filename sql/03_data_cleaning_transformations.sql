-- 03_data_cleaning_transformations.sql
-- Clean and transform raw staging data into final clean table.

USE DunkinsBeverageDB;
GO

TRUNCATE TABLE dbo.BeverageSales_Clean;
GO

WITH Cleaned AS
(
    SELECT
        LTRIM(RTRIM(Order_ID)) AS Order_ID,
        TRY_CONVERT(DATE, LTRIM(RTRIM(Order_Date))) AS Order_Date,
        UPPER(LTRIM(RTRIM(Store_ID))) AS Store_ID,
        LTRIM(RTRIM(Store_Name)) AS Store_Name,
        CONCAT(UPPER(LEFT(LTRIM(RTRIM(Region)), 1)), LOWER(SUBSTRING(LTRIM(RTRIM(Region)), 2, 100))) AS Region,
        LTRIM(RTRIM(State)) AS State,
        LTRIM(RTRIM(City)) AS City,
        UPPER(LTRIM(RTRIM(Product_ID))) AS Product_ID,
        LTRIM(RTRIM(Product_Name)) AS Product_Name,
        CASE
            WHEN LOWER(LTRIM(RTRIM(Product_Category))) IN ('coffee','COFFEE') THEN 'Coffee'
            WHEN LOWER(LTRIM(RTRIM(Product_Category))) IN ('espresso') THEN 'Espresso'
            WHEN LOWER(LTRIM(RTRIM(Product_Category))) IN ('tea') THEN 'Tea'
            WHEN LOWER(LTRIM(RTRIM(Product_Category))) IN ('frozen drinks', 'frozen') THEN 'Frozen Drinks'
            WHEN LOWER(LTRIM(RTRIM(Product_Category))) IN ('refreshers', 'refresher') THEN 'Refreshers'
            WHEN LOWER(LTRIM(RTRIM(Product_Category))) IN ('bakery') THEN 'Bakery'
            ELSE LTRIM(RTRIM(Product_Category))
        END AS Product_Category,
        CASE
            WHEN UPPER(LTRIM(RTRIM(Beverage_Size))) IN ('SMALL', 'MEDIUM', 'LARGE', 'NA') 
                THEN CONCAT(UPPER(LEFT(LTRIM(RTRIM(Beverage_Size)), 1)), LOWER(SUBSTRING(LTRIM(RTRIM(Beverage_Size)), 2, 100)))
            ELSE 'Unknown'
        END AS Beverage_Size,
        CASE
            WHEN UPPER(LTRIM(RTRIM(Temperature))) IN ('HOT', 'ICED', 'FROZEN', 'NA') 
                THEN CONCAT(UPPER(LEFT(LTRIM(RTRIM(Temperature)), 1)), LOWER(SUBSTRING(LTRIM(RTRIM(Temperature)), 2, 100)))
            ELSE 'Unknown'
        END AS Temperature,
        TRY_CONVERT(INT, LTRIM(RTRIM(Quantity))) AS Quantity,
        TRY_CONVERT(DECIMAL(10,2), LTRIM(RTRIM(Unit_Price))) AS Unit_Price,
        TRY_CONVERT(DECIMAL(5,2), LTRIM(RTRIM(Discount))) AS Discount,
        TRY_CONVERT(DECIMAL(12,2), LTRIM(RTRIM(Sales))) AS Sales,
        TRY_CONVERT(DECIMAL(12,2), LTRIM(RTRIM(Cost))) AS Cost,
        TRY_CONVERT(DECIMAL(12,2), LTRIM(RTRIM(Profit))) AS Profit,
        LTRIM(RTRIM(Sales_Channel)) AS Sales_Channel,
        COALESCE(NULLIF(LTRIM(RTRIM(Payment_Method)), ''), 'Unknown') AS Payment_Method,
        LTRIM(RTRIM(Customer_Type)) AS Customer_Type,
        COALESCE(NULLIF(LTRIM(RTRIM(Promo_Flag)), ''), 'No') AS Promo_Flag,
        COALESCE(NULLIF(LTRIM(RTRIM(Loyalty_Member)), ''), 'Unknown') AS Loyalty_Member,
        LTRIM(RTRIM(Order_Status)) AS Order_Status,
        LTRIM(RTRIM(Weather)) AS Weather,
        LTRIM(RTRIM(Daypart)) AS Daypart,
        ROW_NUMBER() OVER (PARTITION BY LTRIM(RTRIM(Order_ID)) ORDER BY TRY_CONVERT(DATE, LTRIM(RTRIM(Order_Date)))) AS rn
    FROM dbo.BeverageSales_Staging
)
INSERT INTO dbo.BeverageSales_Clean
(
    Order_ID, Order_Date, Store_ID, Store_Name, Region, State, City,
    Product_ID, Product_Name, Product_Category, Beverage_Size, Temperature,
    Quantity, Unit_Price, Discount, Sales, Cost, Profit, Sales_Channel,
    Payment_Method, Customer_Type, Promo_Flag, Loyalty_Member, Order_Status,
    Weather, Daypart
)
SELECT
    Order_ID, Order_Date, Store_ID, Store_Name, Region, State, City,
    Product_ID, Product_Name, Product_Category, Beverage_Size, Temperature,
    Quantity, Unit_Price, Discount, Sales, Cost, Profit, Sales_Channel,
    Payment_Method, Customer_Type, Promo_Flag, Loyalty_Member, Order_Status,
    Weather, Daypart
FROM Cleaned
WHERE
    rn = 1
    AND Order_ID IS NOT NULL
    AND Order_Date IS NOT NULL
    AND Quantity IS NOT NULL
    AND Quantity > 0
    AND Unit_Price IS NOT NULL
    AND Sales IS NOT NULL
    AND Cost IS NOT NULL
    AND Profit IS NOT NULL;
GO

-- Validation checks
SELECT COUNT(*) AS Clean_Row_Count
FROM dbo.BeverageSales_Clean;

SELECT
    COUNT(*) AS Duplicate_Order_Count
FROM
(
    SELECT Order_ID
    FROM dbo.BeverageSales_Clean
    GROUP BY Order_ID
    HAVING COUNT(*) > 1
) d;


SELECT 
    COUNT(*) AS Missing_Important_Values
FROM dbo.BeverageSales_Clean
WHERE 
    Order_ID IS NULL
    OR Order_Date IS NULL
    OR Sales IS NULL
    OR Profit IS NULL
    OR Quantity IS NULL;

SELECT TOP 20 *
FROM dbo.BeverageSales_Clean
ORDER BY Order_Date;
GO
