-- 02_bulk_insert_raw_data.sql
-- Update the file path to where you saved dunkins_beverage_raw_data.csv on your computer.

USE DunkinsBeverageDB;
GO

TRUNCATE TABLE dbo.BeverageSales_Staging;
GO

BULK INSERT dbo.BeverageSales_Staging
FROM 'D:\PROJECT_Dunkin_BI\data\dunkins_beverage_raw_data.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

SELECT TOP 10 *
FROM dbo.BeverageSales_Staging;
GO

SELECT COUNT(*) AS Raw_Row_Count
FROM dbo.BeverageSales_Staging;
GO
