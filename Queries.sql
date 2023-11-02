-------------------- DATA CLEANING DONE for MOVIEDATA  -------------------
-- Removing inconsistent data --
DELETE 
FROM dbo.MarketingData
WHERE marital = 'primary'
;
-- Replacing O for NULL values --
UPDATE dbo.MovieData
SET budget = 0
WHERE budget IS NULL
;
UPDATE dbo.MovieData
SET revenue = 0
WHERE revenue IS NULL
;
-- Changing data type --
ALTER TABLE dbo.MovieData
ALTER COLUMN release_date date
;
-----------------------------------------------------------------------------


-- DAY 1/QUESTION 1: Using the Movie Data, write a query to show the titles of movies 
-- released in 2017 whose vote count is more than 15 and runtime is more than 100.
SELECT title
FROM dbo.MovieData
WHERE	DATEPART(year, release_date) = 2017 AND 
		vote_count > 15 AND 
		runtime > 100
;


-- DAY 2/QUESTION 2: Using the Pizza Data, write a query to show how many pizza were ordered.
SELECT COUNT(*) as total_pizza_ordered
FROM dbo.customer_orders
;


-- DAY 3/QUESTION 3: Using the Pizza Data, write a query to show how many succesful orders 
-- were delivered by each runner.
SELECT runner_id, COUNT(*) AS number_of_succesful_orders
FROM dbo.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id
;


-- DAY 4/QUESTION 4: Using the Movie Data, write a query to show the top 10 movie 
-- titles whose language are English & French and the budget is more than 1,000,000
SELECT TOP 10 title
FROM dbo.MovieData
WHERE	(original_language = 'en' OR original_language = 'fr') AND budget > 1000000
;


-- DAY 5/QUESTION 5: Using the Pizza Data, write a query to show the number of 
-- each type of pizza that was delivered.
SELECT	pizza_name, COUNT(*) as pizza_deliveries
FROM dbo.runner_orders as run
	JOIN dbo.customer_orders as cus
		ON run.order_id = cus.order_id
	JOIN dbo.pizza_names as piz
		ON cus.pizza_id = piz.pizza_id
WHERE cancellation IS NULL
GROUP BY pizza_name
;


-- DAY 6/BONUS QUESTION 1: Using the SampleStore Data, write a query to show the average delivery days
-- to Dallas, Los Angeles, Seattle & Madison. Only show the City & Average delivery days column
-- in your output
SELECT City, AVG(delivery_days) AS Average_delivery_days
FROM
(
	SELECT City, DATEDIFF(DAY, Order_Date, Ship_Date) AS delivery_days
	FROM dbo.SuperStoreOrders
	WHERE City IN ('Dallas', 'Los Angeles', 'Seattle', 'Madison')
) as delivery_days_subQ
GROUP BY City
;


-- DAY 7/QUESTION 6: Using the SampleStore Data, write a query to help the company identify the customer 
-- who made the highest sales ever and the categoty of business driving this sale.
SELECT TOP 1 Customer_Name, 
			 Category, 
			 ROUND(SUM(Sales), 0) AS Total_Sales
FROM dbo.SuperStoreOrders
GROUP BY Customer_Name, Category
ORDER BY 3 DESC
;


-- DAY 8/QUESTION 7: Using the SampleStore Data, write a query to show the total sales and percentage 
-- contribution by each category of The Briggs Company.
SELECT *, ROUND((Total_Sales/SUM(Total_Sales) OVER ())*100, 2) as Percentage
FROM
(
	SELECT Category, ROUND(SUM(Sales), 2) AS Total_Sales
	FROM dbo.SuperStoreOrders
	GROUP BY Category
) as subQ
ORDER BY 2 DESC
;


-- DAY 9/QUESTION 8: Using the SampleStore Data, write a query to show the total sales 
-- by each sub-category of The Briggs Company.
SELECT [Sub-Category], ROUND(SUM(Sales), 2) AS Total_Sales
FROm dbo.SuperStoreOrders
GROUP BY [Sub-Category]
ORDER BY 2 DESC
;


-- DAY 10/QUESTION 9: Using the SampleStore Data, write a query to show The Briggs
-- Company the breakdown of the total "phone sales" by year in descending order.
SELECT Sales_Year, ROUND(SUM(Sales), 2) as Total_Sales
FROM
(
	SELECT Sales, DATEPART(YEAR, Order_Date) AS Sales_Year
	FROM dbo.SuperStoreOrders
	WHERE [Sub-Category] = 'Phones'
) as subQ
GROUP BY Sales_Year
ORDER BY 2 DESC
;

