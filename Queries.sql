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

