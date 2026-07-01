-- 01_create_database_and_tables.sql
-- Dunkins Beverage Insights Portfolio Project
-- Synthetic dataset for learning/portfolio use only.

CREATE DATABASE DunkinsBeverageDB;
GO

USE DunkinsBeverageDB;
GO

IF OBJECT_ID('dbo.BeverageSales_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.BeverageSales_Staging;
GO

IF OBJECT_ID('dbo.BeverageSales_Clean', 'U') IS NOT NULL
    DROP TABLE dbo.BeverageSales_Clean;
GO

CREATE TABLE dbo.BeverageSales_Staging
(
    Order_ID VARCHAR(50),
    Order_Date VARCHAR(50),
    Store_ID VARCHAR(50),
    Store_Name VARCHAR(100),
    Region VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(50),
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(100),
    Product_Category VARCHAR(50),
    Beverage_Size VARCHAR(50),
    Temperature VARCHAR(50),
    Quantity VARCHAR(50),
    Unit_Price VARCHAR(50),
    Discount VARCHAR(50),
    Sales VARCHAR(50),
    Cost VARCHAR(50),
    Profit VARCHAR(50),
    Sales_Channel VARCHAR(50),
    Payment_Method VARCHAR(50),
    Customer_Type VARCHAR(50),
    Promo_Flag VARCHAR(50),
    Loyalty_Member VARCHAR(50),
    Order_Status VARCHAR(50),
    Weather VARCHAR(50),
    Daypart VARCHAR(50)
);
GO

CREATE TABLE dbo.BeverageSales_Clean
(
    Order_ID VARCHAR(50) PRIMARY KEY,
    Order_Date DATE,
    Store_ID VARCHAR(50),
    Store_Name VARCHAR(100),
    Region VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(50),
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(100),
    Product_Category VARCHAR(50),
    Beverage_Size VARCHAR(50),
    Temperature VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Discount DECIMAL(5,2),
    Sales DECIMAL(12,2),
    Cost DECIMAL(12,2),
    Profit DECIMAL(12,2),
    Sales_Channel VARCHAR(50),
    Payment_Method VARCHAR(50),
    Customer_Type VARCHAR(50),
    Promo_Flag VARCHAR(10),
    Loyalty_Member VARCHAR(20),
    Order_Status VARCHAR(50),
    Weather VARCHAR(50),
    Daypart VARCHAR(50)
);
GO

  --Select * from dbo.BeverageSales_Staging
  --Select * from dbo.BeverageSales_Clean