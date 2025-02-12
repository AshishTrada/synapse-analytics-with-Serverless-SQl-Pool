USE SALES_DW;

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name ='parquet_file_format')
  CREATE EXTERNAL FILE FORMAT parquet_file_format  
  WITH (  
        FORMAT_TYPE = PARQUET,  
        DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
       );

-- Create products Table
IF OBJECT_ID('silver.products_cleaned') IS NOT NULL
        DROP EXTERNAL TABLE  silver.products_cleaned ;

CREATE EXTERNAL TABLE silver.products_cleaned 
    WITH (
        DATA_SOURCE = sales_data_raw,
        LOCATION = 'silver/products_cleaned',
        FILE_FORMAT = parquet_file_format
    ) 
AS
    SELECT 
        p.ProductID,
        p.ProductName,
        p.Price,
        c.CategoryID,
        c.CategoryName,
        p.Class,
        TRY_CAST(p.ModifyDate AS DATE) AS ModifyDate,
        p.Resistant,
        p.IsAllergic,
        p.VitalityDays
    FROM 
        bronze.products AS p
    LEFT JOIN 
        bronze.categories AS c
    ON 
        p.CategoryID = c.CategoryID
    WHERE 
        p.ProductID IS NOT NULL AND p.Price > 0

select * from silver.products_cleaned;

--customers table
IF OBJECT_ID('silver.customers_cleaned') IS NOT NULL
    DROP EXTERNAL TABLE silver.customers_cleaned;

CREATE EXTERNAL TABLE silver.customers_cleaned
    WITH (
        DATA_SOURCE = sales_data_raw,
        LOCATION = 'silver/customers_cleaned',
        FILE_FORMAT = parquet_file_format
    )
AS
    SELECT 
        c.CustomerID,
        c.FirstName,
        c.MiddleInitial,
        c.LastName,
        c.Address,
        ci.CityID,
        ci.CityName,
        ci.Zipcode,
        co.CountryID,
        co.CountryName,
        co.CountryCode
    FROM 
        bronze.customers AS c
    LEFT JOIN 
        bronze.cities AS ci
    ON 
        c.CityID = ci.CityID
    LEFT JOIN 
        bronze.countries AS co
    ON 
        ci.CountryID = co.CountryID
    WHERE 
        c.CustomerID IS NOT NULL;

select * from silver.customers_cleaned

-- employee table
IF OBJECT_ID('silver.employees_cleaned') IS NOT NULL
    DROP EXTERNAL TABLE silver.employees_cleaned;

CREATE EXTERNAL TABLE silver.employees_cleaned
    WITH (
        DATA_SOURCE = sales_data_raw,
        LOCATION = 'silver/employees_cleaned',
        FILE_FORMAT = parquet_file_format
    )
AS
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.MiddleInitial,
        e.LastName,
        TRY_CAST(e.BirthDate AS DATE) AS BirthDate,
        e.Gender,
        e.HireDate,
        ci.CityID,
        ci.CityName,
        ci.Zipcode,
        co.CountryID,
        co.CountryName,
        co.CountryCode
    FROM 
        bronze.employees AS e
    LEFT JOIN 
        bronze.cities AS ci
    ON 
        e.CityID = ci.CityID
    LEFT JOIN 
        bronze.countries AS co
    ON 
        ci.CountryID = co.CountryID
    WHERE 
        e.EmployeeID IS NOT NULL;

SELECT * FROM silver.employees_cleaned;

-- countries table 
IF OBJECT_ID('silver.countries_cleaned') IS NOT NULL
    DROP EXTERNAL TABLE silver.countries_cleaned;

CREATE EXTERNAL TABLE silver.countries_cleaned
    WITH (
        DATA_SOURCE = sales_data_raw,
        LOCATION = 'silver/countries_cleaned',
        FILE_FORMAT = parquet_file_format
    )
AS
    SELECT 
        co.CountryID,
        co.CountryName,
        co.CountryCode,
        ci.CityID,
        ci.CityName,
        ci.Zipcode
    FROM 
        bronze.countries AS co
    LEFT JOIN 
        bronze.cities AS ci
    ON 
        co.CountryID = ci.CountryID
    WHERE 
        co.CountryID IS NOT NULL;

select * from silver.countries_cleaned;

-- sales table
IF OBJECT_ID('silver.sales_cleaned') IS NOT NULL
    DROP EXTERNAL TABLE silver.sales_cleaned;

CREATE EXTERNAL TABLE silver.sales_cleaned
    WITH (
        DATA_SOURCE = sales_data_raw,
        LOCATION = 'silver/sales_cleaned',
        FILE_FORMAT = parquet_file_format
    )
AS
    SELECT 
        s.SalesID,
        s.SalesPersonID,
        s.CustomerID,
        s.ProductID,
        TRY_CAST(s.SalesDate AS DATE) AS SalesDate,
        s.Quantity,
        ROUND(p.Price, 2) AS ProductPrice,
        TRY_CAST((s.Discount*100) AS FLOAT) AS 'Discount(%)',
        ROUND((s.Quantity * p.Price) * (1 - s.Discount), 2) AS Revenue -- derived column,
        s.TransactionNumber
    FROM 
        bronze.sales AS s
    LEFT JOIN 
        bronze.products AS p
    ON 
        s.ProductID = p.ProductID
    WHERE 
        s.SalesID IS NOT NULL AND s.Quantity > 0 AND p.ProductID IS NOT NULL;

SELECT * FROM silver.sales_cleaned;


