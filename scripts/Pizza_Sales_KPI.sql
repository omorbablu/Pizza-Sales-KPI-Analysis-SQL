/* 
===============================================================================
Pizza Sales Analysis – Key Metrics & Trends
===============================================================================
This script includes core business KPIs and trends calculated from the 
`pizza_sales` dataset, covering performance summaries, category analysis, 
and time-based trends.
===============================================================================
*/

/* ===========================================================================
A. DATA PREVIEW
============================================================================ */
SELECT *
FROM pizza_sales;


/* ===========================================================================
B. KEY BUSINESS KPIs
============================================================================ */

/* 
--------------------------------------------------------------
1. Total Revenue
--------------------------------------------------------------
Definition: The sum of the total price of all pizza orders.
*/
SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales;


/* 
--------------------------------------------------------------
2. Average Order Value
--------------------------------------------------------------
Definition: The average amount spent per order, calculated by dividing 
total revenue by total number of unique orders.
*/
SELECT 
    SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM pizza_sales;


/* 
--------------------------------------------------------------
3. Total Pizzas Sold
--------------------------------------------------------------
Definition: Total quantity of pizzas sold across all orders.
*/
SELECT 
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales;


/* 
--------------------------------------------------------------
4. Total Orders
--------------------------------------------------------------
Definition: Total number of distinct pizza orders.
*/
SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;


/* 
--------------------------------------------------------------
5. Average Pizzas Per Order
--------------------------------------------------------------
Definition: Average number of pizzas per order.
*/
SELECT 
    CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
         CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) 
         AS Avg_Pizzas_Per_Order
FROM pizza_sales;


/* ===========================================================================
C. TIME-BASED TRENDS
============================================================================ */

/* 
--------------------------------------------------------------
6. Daily Order Trend
--------------------------------------------------------------
Definition: Number of orders by day of the week.
*/
SELECT 
    DATENAME(dw, order_date) AS Order_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(dw, order_date);


/* 
--------------------------------------------------------------
7. Hourly Order Trend
--------------------------------------------------------------
Definition: Orders distribution by hour of the day.
*/
SELECT 
    DATEPART(HOUR, order_time) AS Order_Hour,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY COUNT(DISTINCT order_id);


/* ===========================================================================
D. SALES DISTRIBUTION
============================================================================ */

/* 
--------------------------------------------------------------
8. % of Sales by Pizza Category
--------------------------------------------------------------
Definition: Contribution of each pizza category to total revenue.
*/
SELECT 
    pizza_category,
    SUM(total_price) AS Total_Sales,
    SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales) 
        AS Percentage_Of_Sales
FROM pizza_sales
GROUP BY pizza_category;


/* 
--------------------------------------------------------------
9. % of Sales by Pizza Size
--------------------------------------------------------------
Definition: Revenue distribution based on pizza sizes.
*/
SELECT 
    pizza_size,
    CAST(SUM(total_price) * 100.0 / 
         (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) 
         AS Percentage_Of_Sales_By_Size
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Percentage_Of_Sales_By_Size DESC;


/* ===========================================================================
E. CATEGORY PERFORMANCE
============================================================================ */

/* 
--------------------------------------------------------------
10. Total Pizzas Sold by Pizza Category
--------------------------------------------------------------
Definition: Total quantity sold per pizza category.
*/
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Pizzas_Sold_By_Category
FROM pizza_sales
GROUP BY pizza_category;


/* 
--------------------------------------------------------------
11. Top 10 Best-Selling Pizzas
--------------------------------------------------------------
Definition: Pizzas with highest total quantity sold.
*/
SELECT TOP 10 
    pizza_name,
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizzas_Sold DESC;


/* 
--------------------------------------------------------------
12. Bottom 5 Sellers by Total Pizzas Sold (January Only)
--------------------------------------------------------------
Definition: Least sold pizzas during January.
*/
SELECT TOP 5 
    pizza_name,
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_name
ORDER BY Total_Pizzas_Sold ASC;
