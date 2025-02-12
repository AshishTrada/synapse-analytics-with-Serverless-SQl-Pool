USE SALES_DW;

-- Sales Summary by Customer
IF OBJECT_ID('gold.sales_summary_by_customer') IS NOT NULL
    DROP VIEW gold.sales_summary_by_customer;

CREATE VIEW gold.sales_summary_by_customer AS
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.MiddleInitial, ' ', c.LastName) AS Customer_FullName,
    c.CityName,
    c.CountryName,
    COUNT(s.SalesID) AS TotalSales,
    SUM(s.Quantity) AS TotalQuantity,
    ROUND(SUM(s.Revenue), 2) AS TotalRevenue
FROM 
    silver.sales_cleaned AS s
INNER JOIN 
    silver.customers_cleaned AS c
ON 
    s.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerID, c.FirstName, c.MiddleInitial, c.LastName, c.CityName, c.CountryName;

SELECT * FROM gold.sales_summary_by_customer;

-- Sales by Product
IF OBJECT_ID('gold.sales_by_product') IS NOT NULL
    DROP VIEW gold.sales_by_product;

CREATE VIEW gold.sales_by_product AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.CategoryName,
    COUNT(s.SalesID) AS TotalSales,
    SUM(s.Quantity) AS TotalQuantitySold,
    Round(SUM(s.revenue),2) AS TotalRevenue
FROM 
    silver.sales_cleaned AS s
INNER JOIN 
    silver.products_cleaned AS p
ON 
    s.ProductID = p.ProductID
GROUP BY 
    p.ProductID, p.ProductName, p.CategoryName;

SELECT * FROM gold.sales_by_product;

-- Employee Performance
IF OBJECT_ID('gold.employee_performance') IS NOT NULL
    DROP VIEW gold.employee_performance;

CREATE VIEW gold.employee_performance AS
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.MiddleInitial, ' ', e.LastName) AS EmployeeFullName,
    e.CityName,
    e.CountryName,
    COUNT(s.SalesID) AS TotalSales,
    SUM(s.Quantity) AS TotalQuantitySold,
    ROUND(SUM(s.revenue),2) AS TotalRevenueGenerated
FROM 
    silver.sales_cleaned AS s
INNER JOIN 
    silver.employees_cleaned AS e
ON 
    s.SalesPersonID = e.EmployeeID
GROUP BY 
    e.EmployeeID, e.FirstName, e.MiddleInitial, e.LastName, e.CityName, e.CountryName;

SELECT * FROM gold.employee_performance;

-- Revenue by Country
IF OBJECT_ID('gold.revenue_by_country') IS NOT NULL
    DROP VIEW gold.revenue_by_country;

CREATE VIEW gold.revenue_by_country AS
SELECT 
    co.CountryID,
    co.CountryName,
    co.CityID,
    co.CityName,
    ROUND(SUM(s.revenue),2) AS TotalRevenue,
    COUNT(DISTINCT s.CustomerID) AS UniqueCustomers,
    COUNT(s.SalesID) AS TotalSales
FROM 
    silver.sales_cleaned AS s
INNER JOIN 
    silver.customers_cleaned AS c
ON 
    s.CustomerID = c.CustomerID
INNER JOIN 
    silver.countries_cleaned AS co
ON 
    c.CityID = co.CityID
GROUP BY 
    co.CountryID, co.CountryName, co.CityID, co.CityName;

select * from gold.revenue_by_country;

-- top products by revenue
IF OBJECT_ID('gold.top_products_by_revenue') IS NOT NULL
    DROP VIEW gold.top_products_by_revenue;

CREATE VIEW gold.top_products_by_revenue AS
SELECT TOP 10
    p.ProductID,
    p.ProductName,
    p.CategoryName,
    ROUND(SUM(s.Revenue),2) AS TotalRevenue,
    SUM(s.Quantity) AS TotalQuantitySold,
    COUNT(s.SalesID) AS TotalSales
FROM 
    silver.sales_cleaned AS s
INNER JOIN 
    silver.products_cleaned AS p
ON 
    s.ProductID = p.ProductID
GROUP BY 
    p.ProductID, p.ProductName, p.CategoryName
ORDER BY 
    TotalRevenue DESC;

select * from gold.top_products_by_revenue;

-- Sales Over Time
IF OBJECT_ID('gold.sales_over_time') IS NOT NULL
    DROP VIEW gold.sales_over_time;

CREATE VIEW gold.sales_over_time AS
SELECT 
    s.SalesDate,
    ROUND(SUM(s.Revenue),2) AS TotalRevenue,
    SUM(s.Quantity) AS TotalQuantitySold,
    COUNT(s.SalesID) AS TotalSales
FROM 
    silver.sales_cleaned AS s
WHERE 
    s.SalesDate IS NOT NULL
GROUP BY 
    s.SalesDate;

SELECT * FROM gold.sales_over_time ORDER BY SalesDate;

