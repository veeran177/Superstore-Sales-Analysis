-- 1. Drop database if exists
DROP DATABASE IF EXISTS superstore;

-- 2. Create new database
CREATE DATABASE superstore;
USE superstore;

-- 3. Drop table if exists
DROP TABLE IF EXISTS sales;

-- 4. Create table with datatypes
CREATE TABLE sales (
    Row_ID INT,
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,2)
);

-- 5. Load CSV into table

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sample - Superstore.csv'
INTO TABLE sales
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  Row_ID,
  Order_ID,
  @var_order_date,
  @var_ship_date,
  Ship_Mode,
  Customer_ID,
  Customer_Name,
  Segment,
  Country,
  City,
  State,
  Postal_Code,
  Region,
  Product_ID,
  Category,
  Sub_Category,
  Product_Name,
  Sales,
  Quantity,
  Discount,
  Profit
)
SET
  Order_Date = STR_TO_DATE(@var_order_date, '%m/%d/%Y'),
  Ship_Date  = STR_TO_DATE(@var_ship_date, '%m/%d/%Y');
  
  SELECT * FROM sales;
  
  #1.Basic Checks 
  
  -- Total number of records
SELECT COUNT(*) AS total_records FROM sales;

-- Time range of orders
SELECT MIN(Order_Date) AS first_order, MAX(Order_Date) AS last_order FROM sales;

-- Distinct customers
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers FROM sales;

-- Distinct products
SELECT COUNT(DISTINCT Product_ID) AS unique_products FROM sales;

#2. Sales Overview

-- Total sales, total profit, avg discount
SELECT
	SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    AVG(Discount) AS avg_discount
FROM sales;    


-- Sales by Category
SELECT Category, ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY Category
ORDER BY total_sales DESC;

-- Sales by Sub-Category
SELECT Sub_Category, ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY Sub_Category
ORDER BY total_sales DESC;


#3. Customer Insights

-- Top 10 customers by sales
SELECT Customer_Name, ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY Customer_Name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 customers by profit
SELECT Customer_Name, ROUND(SUM(Profit),2) AS total_profit
FROM sales
GROUP BY Customer_Name
ORDER BY total_profit DESC
LIMIT 10;

#4. Regional Analysis

-- Sales by Region
SELECT Region, ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY Region
ORDER BY total_sales DESC;

-- Sales by State (Top 10)
SELECT State, ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY State
ORDER BY total_sales DESC
LIMIT 10;


#5. Time Based trends

-- Sales by Year
SELECT YEAR(Order_Date) AS year, ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY YEAR(Order_Date)
ORDER BY year;

-- Sales by Month-Year
SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS month_year,
       ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY month_year
ORDER BY month_year;



