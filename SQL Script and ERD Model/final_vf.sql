USE supplychaindb;

-- ============================================
-- SCHEMA CREATION
-- ============================================
CREATE TABLE calendar (
    date_value DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    quarter INT
);

-- Create Category Table
CREATE TABLE dimcategory (
    categoryKey INT PRIMARY KEY AUTO_INCREMENT,
    categoryName VARCHAR(50) NOT NULL
);

-- Create Customer Table
CREATE TABLE dimcustomer (
    customerID VARCHAR(50) PRIMARY KEY,
    City VARCHAR(50) NOT NULL
);

-- Create Payment Table
CREATE TABLE dimpayment (
    payment_sk INT PRIMARY KEY AUTO_INCREMENT,
    paymentType VARCHAR(50) NOT NULL
);

-- Create Product Table
CREATE TABLE dimproduct (
    productID VARCHAR(50) PRIMARY KEY,
    categoryKey INT NOT NULL,
    FOREIGN KEY (CategoryKey) REFERENCES dimcategory(CategoryKey)
);

-- Create Seller Table
CREATE TABLE dimseller (
    SellerId VARCHAR(50) PRIMARY KEY
);

-- Create Fact Orders Table
CREATE TABLE factOrders(
    OrderId VARCHAR(50) PRIMARY KEY,
    OrderStatus VARCHAR(50) NOT NULL, 
    PurchaseDate DATE NOT NULL,
    EstimatedDeliveryDate DATE NOT NULL,
    DeliveredDate DATE NOT NULL,
    CustomerId VARCHAR(50) NOT NULL,
    ProductId VARCHAR(50) NOT NULL,
    SellerId VARCHAR(50) NOT NULL,
    payment_sk INT NOT NULL,                  
    Price DECIMAL(10,2) NOT NULL,
    ShippingCharges DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (CustomerId) REFERENCES dimCustomer(CustomerId),
    FOREIGN KEY (ProductId) REFERENCES dimProduct(ProductId),
    FOREIGN KEY (SellerId) REFERENCES dimSeller(SellerId),
    FOREIGN KEY (payment_sk) REFERENCES dimpayment(payment_sk)
);

-- ============================================
-- STEP 1: PREPARE STAGING TABLE
-- ============================================

-- Drop old staging table if exists
DROP TABLE IF EXISTS stagingtable;

-- Create new staging table matching your CSV structure (NO ApprovedDate)
CREATE TABLE stagingtable (
    CustomerID VARCHAR(50),
    CustomerName VARCHAR(255),
    CustomerCity VARCHAR(100),
    OrderID VARCHAR(50),
    ProductID VARCHAR(50),
    ProductName VARCHAR(255),
    COGS DECIMAL(10, 2),
    CategoryID VARCHAR(50),
    CategoryName VARCHAR(100),
    SupplierID VARCHAR(50),
    SupplierName VARCHAR(255),
    Price DECIMAL(10, 2),
    ShippingCharges DECIMAL(10, 2),
    OrderStatus VARCHAR(50),
    PaymentID VARCHAR(50),
    PaymentType VARCHAR(50),
    PurchaseDate DATE,
    ExpectedDeliveryDate DATE,
    ActualDeliveryDate DATE
);

-- ============================================
-- STEP 2: IMPORT YOUR DATA INTO stagingtable
-- Use the Python script to insert data here
-- Run: python import_script.py
-- ============================================

-- ============================================
-- STEP 3: POPULATE CALENDAR TABLE
-- ============================================

-- Find date range from staging data
SET @StartDate = (SELECT MIN(PurchaseDate) FROM stagingtable WHERE PurchaseDate IS NOT NULL);
SET @EndDate = (SELECT MAX(COALESCE(ActualDeliveryDate, ExpectedDeliveryDate, PurchaseDate)) 
                FROM stagingtable 
                WHERE COALESCE(ActualDeliveryDate, ExpectedDeliveryDate, PurchaseDate) IS NOT NULL);
SET SESSION cte_max_recursion_depth = 5000;

-- Generate calendar dates
INSERT INTO calendar (date_value, year, month, day, quarter)
SELECT 
    date_value,
    YEAR(date_value),
    MONTH(date_value),
    DAY(date_value),
    QUARTER(date_value)
FROM (
    WITH RECURSIVE CalendarCTE AS (
        SELECT @StartDate AS date_value
        UNION ALL
        SELECT DATE_ADD(date_value, INTERVAL 1 DAY)
        FROM CalendarCTE
        WHERE DATE_ADD(date_value, INTERVAL 1 DAY) <= @EndDate
    )
    SELECT date_value FROM CalendarCTE
) AS temp;

-- ============================================
-- STEP 4: POPULATE DIMENSION TABLES
-- ============================================

-- Insert into dimcategory
INSERT INTO dimcategory(categoryName)
SELECT DISTINCT 
    COALESCE(NULLIF(CategoryName, ''), 'Unknown') AS categoryName
FROM stagingtable
WHERE CategoryName IS NOT NULL OR CategoryName = '';

-- Insert into dimproduct 
INSERT INTO dimproduct(productID, categoryKey)
SELECT DISTINCT 
    s.ProductID,
    c.categoryKey
FROM stagingtable s
JOIN dimcategory c ON COALESCE(NULLIF(s.CategoryName, ''), 'Unknown') = c.categoryName
WHERE s.ProductID IS NOT NULL;

-- Insert into dimseller 
INSERT INTO dimseller(SellerId)
SELECT DISTINCT SupplierID
FROM stagingtable
WHERE SupplierID IS NOT NULL;

-- Insert into dimcustomer 
INSERT INTO dimcustomer(customerID, City)
SELECT DISTINCT 
    CustomerID,
    COALESCE(CustomerCity, 'Unknown') AS City
FROM stagingtable
WHERE CustomerID IS NOT NULL;

-- Insert into dimpayment
INSERT INTO dimpayment(paymentType)
SELECT DISTINCT 
    COALESCE(PaymentType, 'Unknown') AS paymentType
FROM stagingtable
WHERE PaymentType IS NOT NULL OR PaymentType = '';

-- ============================================
-- STEP 5: POPULATE FACT TABLE
-- ============================================

INSERT INTO factorders(
    OrderId, 
    OrderStatus,
    PurchaseDate, 
    EstimatedDeliveryDate, 
    DeliveredDate,
    CustomerId, 
    ProductId, 
    SellerId,
    payment_sk, 
    Price, 
    ShippingCharges
)
SELECT 
    s.OrderID,
    MAX(s.OrderStatus) AS OrderStatus,
    MAX(s.PurchaseDate) AS PurchaseDate,
    MAX(s.ExpectedDeliveryDate) AS EstimatedDeliveryDate,
    MAX(s.ActualDeliveryDate) AS DeliveredDate,
    MAX(s.CustomerID) AS CustomerId,
    s.ProductID,
    MAX(s.SupplierID) AS SellerId,
    MAX(dp.payment_sk) AS payment_sk,
    SUM(COALESCE(s.Price, 0)) AS Price,
    SUM(COALESCE(s.ShippingCharges, 0)) AS ShippingCharges
FROM stagingtable s
JOIN dimcustomer dc ON dc.customerID = s.CustomerID
JOIN dimseller ds ON ds.SellerId = s.SupplierID
JOIN dimpayment dp ON dp.paymentType = COALESCE(s.PaymentType, 'Unknown')
WHERE s.OrderID IS NOT NULL 
  AND s.ProductID IS NOT NULL
GROUP BY s.OrderID, s.ProductID;

-- ============================================

-- Check for NULL dates
SELECT 
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN DeliveredDate IS NULL THEN 1 ELSE 0 END) AS MissingDeliveredDate,
    SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
FROM factorders;