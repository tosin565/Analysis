CREATE DATABASE [Global Super Store];

SELECT *
FROM [Global Super Store Merge]

--What are the three countries that generated the highest total profit for Global Superstore in 2014?
SELECT TOP 3 ROUND(SUM(profit),2) Total_Profit, Country
FROM [Global Super Store Merge]
WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY country
ORDER BY Total_profit DESC

/* For each of these three countries, find the three products with the highest total profit.
Specifically, what are the products’ names and the total profit for each product?*/
-- FOR United States
SELECT TOP 3 ROUND(SUM(profit),2) Total_Profit, Country, Product_Name
FROM [Global Super Store Merge]
WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
AND country = 'United States'
GROUP BY country, Product_Name
ORDER BY Total_profit DESC

-- FOR China
SELECT TOP 3 ROUND(SUM(profit),2) Total_Profit, Country, Product_Name
FROM [Global Super Store Merge]
WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
AND country = 'China'
GROUP BY country, Product_Name
ORDER BY Total_profit DESC

--For India
SELECT TOP 3 ROUND(SUM(profit),2) Total_Profit, Country, Product_Name
FROM [Global Super Store Merge]
WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
AND country = 'India'
GROUP BY country, Product_Name
ORDER BY Total_profit DESC

--Identify the 3 subcategories with the highest average shipping cost in the United States.
SELECT  TOP 3 ROUND(AVG(shipping_cost),2) Avg_shipping, sub_category
FROM [Global Super Store Merge]
WHERE country = 'United States'
GROUP BY Sub_Category
ORDER BY Avg_shipping DESC

--Assess Nigeria’s profitability (i.e., total profit) for 2014. How does it compare to other African countries?
SELECT ROUND(SUM(profit),2) Total_Porfit, Country
FROM [Global Super Store Merge]
WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
AND Region = 'Africa'
GROUP BY Country
ORDER BY Total_Porfit
/* The organization did not make any profit in Nigeria. i.e there was a decline in profit in Nigeria during 2014 compare to other African countries.*/


/*What factors might be responsible for Nigeria’s poor performance? You might want to
investigate shipping costs and the average discount as potential root causes.*/
SELECT TOP 7 SUM(Shipping_Cost) Total_Shipping, Country
FROM [Global Super Store Merge]
WHERE Order_Date BETWEEN '2014-01-01' AND '2014-12-31'
AND Region = 'Africa'
GROUP BY Country
ORDER BY Total_Shipping DESC
-- From the result of the shipping cost. The shipping cost is the key factor responsible for the poor performance in Nigeria.

 /*Identify the product subcategory that is the least profitable in Southeast Asia.
Note: For this question, assume that Southeast Asia comprises Cambodia, Indonesia,
Malaysia, Myanmar (Burma), the Philippines, Singapore, Thailand, and Vietnam*/
SELECT SUM(profit) Total_Profit,COUNT(sub_category), Sub_Category
FROM [Global Super Store Merge]
WHERE Region = 'Southeast Asia'
GROUP BY Sub_Category
ORDER BY Total_Profit
--The sub_category with the least profit in South Asia is Furnishings

/*Which city is the least profitable (in terms of average profit) in the United States?
For this analysis, discard the cities with less than 10 Orders.*/
SELECT AVG(profit) Avg_Profit, COUNT(Order_ID), City
FROM [Global Super Store Merge]
WHERE Country = 'United States'
GROUP BY city
HAVING COUNT(Order_ID) > 10
ORDER BY Avg_Profit
--Portland is the least profitable city in (terms of average profit) in the United States with 0.40  and 24 orders.

--Why is this city’s average profit so low?
SELECT AVG(profit) Avg_Profit, AVG(shipping_cost) Shipping_cost, COUNT(Order_ID), City
FROM [Global Super Store Merge]
WHERE Country = 'United States'
GROUP BY city
HAVING COUNT(Order_ID) > 10
ORDER BY Shipping_cost DESC
--The average low profit in Portland can be traceable to the high rate on shipping costs. Shpping cost revealed that 23.8 was spent on shipping averagely.

--Which product subcategory has the highest average profit in Australia?
SELECT AVG(profit) Avg_profit, sub_category
FROM [Global Super Store Merge]
WHERE country = 'Australia'
GROUP BY sub_category
ORDER BY Avg_profit DESC
-- Appliances has the highest average profit in Australia with 139.01.


--Which customer returned items and what segment do they belong.
SELECT DISTINCT customer_name, segment
FROM [Global Super Store Merge]
WHERE Product_Returned IS NOT NULL	

--Who are the most valuable customers and what do they purchase?
SELECT TOP 5 SUM(sales) Total_sales, COUNT(Customer_name), product_name, Sub_Category
FROM [Global Super Store Merge]
GROUP BY product_name, Sub_Category, Customer_name
ORDER BY Total_sales DESC

--Percentage of Sales Category
SELECT category, SUM(Sales) * 100 / (SELECT SUM(sales) FROM Orders) PTR
FROM [Global Super Store Merge]
GROUP BY Category
ORDER BY PTR DESC

--Total Revenue
SELECT SUM(sales) Total_Revenue
FROM [Global Super Store Merge]

--Total product sold
SELECT SUM(Quantity) Total_product_sold
FROM [Global Super Store Merge]

--Total Order
SELECT COUNT(DISTINCT Order_id) Total_order
FROM [Global Super Store Merge]

--Daily Trend
SELECT DATENAME(DW, order_date) Order_date, COUNT(DISTINCT Order_id) Total_order
FROM [Global Super Store Merge]
GROUP BY DATENAME(DW, order_date)
ORDER BY Total_order DESC
--Tuesday has the highest number of total_order

--Monthly Trend
SELECT MONTH(order_date) AS Month_Number,
DATENAME(MONTH, order_date) Month_name, COUNT(DISTINCT Order_id) Total_order
FROM [Global Super Store Merge]
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date)
--December has the highest number of total_order

--Top and Bottom 5 Countries by Total Sales
WITH Countrysales AS (
    SELECT 
        Country, 
        ROUND(SUM(Sales),2) AS Total_sales
    FROM 
        [Global Super Store Merge]
    GROUP BY 
        Country
),
RankedSales AS (
    SELECT 
        Country, 
        Total_sales,
        ROW_NUMBER() OVER (ORDER BY Total_sales DESC) AS [Top],
        ROW_NUMBER() OVER (ORDER BY Total_sales ASC) AS Bottom
    FROM 
        Countrysales
)
SELECT 
    Country, 
    Total_sales
FROM 
    RankedSales
WHERE 
    [Top] < 6 OR Bottom< 6
ORDER BY 
    Total_sales DESC


