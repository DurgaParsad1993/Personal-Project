-- Create database ---
CREATE DATABASE IF NOT EXISTS Walmart_sales_BA;


-- Create table ---
CREATE TABLE IF NOT EXISTS Walmart_Data (
    `Invoice Id` VARCHAR(30) PRIMARY KEY,
    `Branch` VARCHAR(5) NOT NULL,
    `City` VARCHAR(30) NOT NULL,
    `Customer type` VARCHAR(30) NOT NULL,
    Gender VARCHAR(30) NOT NULL,
    `Product line` VARCHAR(100) NOT NULL,
    `Unit Price` DECIMAL(10 , 2 ) NOT NULL,
    Quantity INT NOT NULL,
    `Tax 5%` FLOAT NOT NULL,
    Total DECIMAL(12 , 4 ) NOT NULL,
    `Date` DATE NOT NULL,
    `Time` TIME NOT NULL,
    Payment VARCHAR(15) NOT NULL,
    Cogs DECIMAL(10 , 2 ) NOT NULL,
    `Gross Margin %` FLOAT,
    `Gross Income` DECIMAL(12 , 4 ),
    rating FLOAT
);

--- Data file ( .CSV) Import From EXCEL --------

-- Data cleaning ---
SELECT * FROM walmart_data;

-- Add the time_of_day column ---
ALTER TABLE walmart_data
ADD COLUMN `Time Of Day` VARCHAR(20);

-- Update Values in Column Time of day ----
UPDATE walmart_data 
SET 
    `Time Of DAy` = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);

-- Add Day name column ----
ALTER TABLE walmart_data
ADD COLUMN `Day Name` VARCHAR(10);

--- Update Values in Day Name column ----
UPDATE walmart_data
SET `Day name` = DAYNAME(date);

-- Add Month Name column
ALTER TABLE walmart_data
ADD COLUMN `Month Name` VARCHAR(10);
 
--- Update values in Month Name Column ----
UPDATE Walmart_data
SET `Month Name` = MONTHNAME(date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic Questions ------------------------------
--------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT
    city
FROM
    walmart_data;

-- In which city is each branch?
SELECT DISTINCT
    city, Branch
FROM
    walmart_data;

-- --------------------------------------------------------------------
-- ---------------------------- Product Analysis -------------------------------
-- --------------------------------------------------------------------

 -- What are the Product lines does data have?
SELECT DISTINCT
    `Product line`
FROM walmart_data;

 -- What is the most common Payment method Customer used?
SELECT 
    Payment, COUNT(Payment) AS `Number of Payment`
FROM
    walmart_data
GROUP BY Payment
ORDER BY `Number of Payment` DESC
LIMIT 1;

-- What is the most selling product line?
SELECT 
    `Product line`, COUNT(Quantity) AS Quantity
FROM
    walmart_data
GROUP BY `Product line`
ORDER BY Quantity DESC;

-- What is the total revenue by month
SELECT 
    `Month Name`, SUM(Total) AS `Total Revenue`
FROM
    walmart_data
GROUP BY `Month Name`
ORDER BY `Total Revenue` DESC;

-- What month had the largest COGS?
SELECT 
    `Month Name`, SUM(Cogs) AS Cogs
FROM
    walmart_data
GROUP BY `Month Name`
ORDER BY Cogs DESC;

-- What product line had the largest revenue?
SELECT 
    `Product line`, SUM(Total) AS Revenue
FROM
    walmart_data
GROUP BY `Product line`
ORDER BY Revenue DESC;

-- What is the city with the largest revenue?
SELECT 
    City, Branch, SUM(Total) AS Revenue
FROM
    walmart_data
GROUP BY City , Branch
ORDER BY Revenue DESC;

-- What product line had the largest VAT?
SELECT 
    `Product line`, AVG(`Tax 5%`) AS VAT
FROM
    walmart_data
GROUP BY `Product line`
ORDER BY VAT DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT 
    `Product Line`,
    CASE
        WHEN
            AVG(Quantity) > (SELECT AVG(quantity) AS avg_qnty FROM walmart_data)
        THEN
            'Good'
        ELSE 'Bad'
    END AS Remarks
FROM
    walmart_data
GROUP BY `Product line`;

-- Which branch sold more products than average product sold?
SELECT 
    Branch, SUM(Quantity) AS Sold_product
FROM
    walmart_data
GROUP BY Branch
HAVING Sold_product > (SELECT AVG(Quantity) FROM walmart_data);

-- What is the most common product line by gender
SELECT 
    Gender, `Product line`, COUNT(Quantity) AS Sold
FROM
    walmart_data
GROUP BY Gender , `Product line`
ORDER BY Sold DESC;

-- What is the average rating of each product line
SELECT 
    `Product line`, ROUND(AVG(rating), 2) AS avg_rating
FROM
    walmart_data
GROUP BY `Product line`
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- ---------------------------- Sales Analysis -------------------------------
-- --------------------------------------------------------------------

-- Number of Sales made in each Time of Day per Weekday?
SELECT 
    `Day Name`, `Time Of Day`, COUNT(*) AS total_sales
FROM
    walmart_data
WHERE
    `Day Name` = 'Sunday'
GROUP BY `Time Of Day` , `Day Name`
ORDER BY total_sales DESC;

-- Evenings experience most sales,  And the stores are 
-- filled during the evening hours

-- Which of customer type brings the most revenue?
SELECT 
    `Customer type`, SUM(total) AS total_revenue
FROM
    walmart_data
GROUP BY `Customer type`
ORDER BY total_revenue DESC;

-- Which city has the largest tax/VAT percent (Value add tax)?
SELECT 
    city, ROUND(AVG(`Tax 5%`), 2) AS avg_tax_pct
FROM
    walmart_data
GROUP BY city
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT 
    `Customer type`, AVG(`Tax 5%`) AS total_tax
FROM
    walmart_data
GROUP BY `Customer type`
ORDER BY total_tax DESC;

-- --------------------------------------------------------------------
-- ---------------------------- Customer Analysis -------------------------------
-- --------------------------------------------------------------------

-- How many Unique Customer type does the data have?
SELECT DISTINCT
    `Customer type`
FROM
    walmart_data;

-- How many unique payment methods does the data have?
SELECT DISTINCT
    payment
FROM
    walmart_data;

-- What is the most common customer type?
SELECT 
    `Customer type`, COUNT(*) AS Purchase
FROM
    walmart_data
GROUP BY `Customer type`
ORDER BY Purchase DESC;

-- Which customer type buys the most?
SELECT 
    `Customer type`, COUNT(*) Bought_qnty
FROM
    walmart_data
GROUP BY `Customer type`
ORDER BY Bought_qnty DESC;

-- What is the gender of most of the customers?
SELECT 
    gender, COUNT(*) AS gender_cnt
FROM
    walmart_data
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT 
    Gender, Branch, COUNT(*) AS Gender_Distribution
FROM
    walmart_data
WHERE
    branch = 'A'
GROUP BY Branch , Gender
ORDER BY Gender_Distribution DESC;

--------- OR -------
SELECT 
    Gender, Branch, COUNT(*) AS Gender_Distribution
FROM
    walmart_data
WHERE
    branch = 'B'
GROUP BY Branch , Gender
ORDER BY Gender_Distribution DESC;

--------- OR -------
SELECT 
    Branch, Gender, COUNT(*) AS Gender_Distribution
FROM
    walmart_data
WHERE
    branch = 'C'
GROUP BY Branch, Gender
ORDER BY Gender_Distribution DESC;

-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of day do customers give most Ratings?
SELECT 
    `Time Of Day`, ROUND(AVG(rating), 2) AS Avg_rating
FROM
    walmart_data
GROUP BY `Time Of Day`
ORDER BY Avg_rating DESC;

-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter

-- Which time of day do customers give most Ratings per Branch?
SELECT 
    Branch, `Time Of Day`, ROUND(AVG(rating), 2) AS Avg_rating
FROM
    walmart_data
WHERE
    Branch = 'A'
GROUP BY Branch , `Time Of Day`
ORDER BY avg_rating DESC;

--------- OR -------
SELECT 
    Branch, `Time Of Day`, ROUND(AVG(rating), 2) AS Avg_rating
FROM
    walmart_data
WHERE
    Branch = 'B'
GROUP BY Branch , `Time Of Day`
ORDER BY avg_rating DESC;

--------- OR -------
SELECT 
    Branch, `Time Of Day`, ROUND(AVG(rating), 2) AS Avg_rating
FROM
    walmart_data
WHERE
    Branch = 'C'
GROUP BY Branch , `Time Of Day`
ORDER BY avg_rating DESC;

-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day of the week has the best AVG Ratings?
SELECT 
    `Day Name`, ROUND(AVG(rating), 2) AS avg_rating
FROM
    walmart_data
GROUP BY `Day Name`
ORDER BY avg_rating DESC;

-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?

-- Which day of the week has the best Average Ratings per Branch?
SELECT 
    `Day Name`, ROUND(AVG(Rating) , 2) as Ratings
FROM
	walmart_data
WHERE
	Branch = "A"
GROUP BY 
	`Day Name`
ORDER BY Ratings DESC;


-- ---------------------------- END ----------------------------------------
-- --------------------------------------------------------------------
