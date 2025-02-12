--create a database
CREATE DATABASE SALES_DW;

USE SALES_DW;

ALTER DATABASE SALES_DW COLLATE Latin1_General_100_CI_AI_SC_UTF8;

-- CREATE SCHEMA:
CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;

-- EXTERNAL DATA SOURCE
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'sales_data_raw')
    CREATE EXTERNAL DATA SOURCE sales_data_raw
    WITH (
            LOCATION = 'abfss://project-data@synapsedatasetadls.dfs.core.windows.net/sales-data',
            
        );

-- create a csv file format
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name ='csv_file_format_pv1')
  CREATE EXTERNAL FILE FORMAT csv_file_format_pv1 
  WITH (  
      FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS (  
        FIELD_TERMINATOR = ','  
      , STRING_DELIMITER = '"'
      , First_Row = 2
      , USE_TYPE_DEFAULT = FALSE 
      , Encoding = 'UTF8'
      , PARSER_VERSION = '1.0' )   
      );

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name ='csv_file_format_pv2')
  CREATE EXTERNAL FILE FORMAT csv_file_format_pv2
  WITH (  
      FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS (
        PARSER_VERSION = '2.0',
		FIRST_ROW = 2,
		FIELD_TERMINATOR = ',',
		STRING_DELIMITER = '"',
		USE_TYPE_DEFAULT = FALSE )  
      ); 

-- add raw data

-- Categories Table
CREATE EXTERNAL TABLE bronze.categories (
    CategoryID INT,
    CategoryName NVARCHAR(100)
)  
WITH (
    LOCATION = 'categories.csv',  
    DATA_SOURCE = sales_data_raw,  
    FILE_FORMAT = csv_file_format_pv1
);

SELECT * FROM bronze.categories;

-- Cities Table
CREATE EXTERNAL TABLE bronze.cities (
    CityID INT,
    CityName NVARCHAR(100),
    Zipcode NVARCHAR(10),
    CountryID INT
)  
WITH (
    LOCATION = 'cities.csv',  
    DATA_SOURCE = sales_data_raw,  
    FILE_FORMAT = csv_file_format_pv1
);

SELECT * FROM bronze.cities;

-- Countries Table
CREATE EXTERNAL TABLE bronze.countries (
    CountryID INT,
    CountryName NVARCHAR(100),
    CountryCode NVARCHAR(10)
)  
WITH (
    LOCATION = 'countries.csv',  
    DATA_SOURCE = sales_data_raw,  
    FILE_FORMAT = csv_file_format_pv1
);

SELECT * FROM bronze.countries;

-- Customers Table
CREATE EXTERNAL TABLE bronze.customers (
    CustomerID INT,
    FirstName NVARCHAR(100),
    MiddleInitial NVARCHAR(10),
    LastName NVARCHAR(100),
    CityID INT,
    Address NVARCHAR(255)
)  
WITH (
    LOCATION = 'customers.csv',  
    DATA_SOURCE = sales_data_raw,  
    FILE_FORMAT = csv_file_format_pv1
);
SELECT * FROM bronze.customers;

-- Employees Table
CREATE EXTERNAL TABLE bronze.employees (
    EmployeeID INT,
    FirstName NVARCHAR(100),
    MiddleInitial NVARCHAR(10),
    LastName NVARCHAR(100),
    BirthDate DATE,
    Gender NVARCHAR(10),
    CityID INT,
    HireDate DATE
)  
WITH (
    LOCATION = 'employees.csv',  
    DATA_SOURCE = sales_data_raw,  
    FILE_FORMAT = csv_file_format_pv1
);
SELECT * FROM bronze.employees;

-- Products Table
CREATE EXTERNAL TABLE bronze.products (
	ProductID bigint,
	ProductName nvarchar(4000),
	Price float,
	CategoryID bigint,
	Class nvarchar(4000),
	ModifyDate date,
	Resistant nvarchar(4000),
	IsAllergic nvarchar(4000),
	VitalityDays float
	)
	WITH (
	LOCATION = 'products.csv',
	DATA_SOURCE = sales_data_raw,
	FILE_FORMAT = csv_file_format_pv2
	)
GO

SELECT * FROM bronze.products;

-- Sales Table
CREATE EXTERNAL TABLE bronze.sales (
    SalesID INT,
    SalesPersonID INT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    Discount DECIMAL(5,2),
    TotalPrice DECIMAL(18,2),
    SalesDate DATE,
    TransactionNumber NVARCHAR(100)
)  
WITH (
    LOCATION = 'sales.csv',  
    DATA_SOURCE = sales_data_raw,  
    FILE_FORMAT = csv_file_format_pv1
);

SELECT * FROM bronze.sales;