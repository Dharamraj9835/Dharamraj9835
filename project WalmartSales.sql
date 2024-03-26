show databases;
use walmartsales;
select * from invoices;

### Generic Question
-- How many unique cities does the data have?
SELECT COUNT(DISTINCT city) AS unique_city
FROM invoices;
-- 2. In which city is each branch?
select city from invoices
where branch in ("A","B","C")
order by City;
SELECT DISTINCT branch, city
FROM invoices;
select * from invoices;
### Product


-- 1. How many unique product lines does the data have?
SELECT COUNT(DISTINCT productline) AS unique_product_lines
FROM invoices;
-- 2. What is the most common payment method?
SELECT payment, COUNT(payment) AS payment_count
FROM invoices
GROUP BY payment
ORDER BY payment_count DESC
LIMIT 10;
select * from invoices;
-- 3. What is the most selling product line?
SELECT productline, SUM(quantity) AS mostsellingproduct
FROM invoices
GROUP BY productline
ORDER BY mostsellingproduct DESC
LIMIT 10;

-- 4. What is the total revenue by month?
    select sum(total)/1.18 as Total_Revenu_By_Month
from  invoices;
-- 5. What month had the largest COGS?
    select sum(cogs)/1.18 as the_largest_cogs
from  invoices;

-- 6. What product line had the largest revenue?
select Productline ,sum(total)/1.18 as Largest_Revenu from invoices 
group by Productline
order by  Largest_Revenu desc
limit 1;


-- 5. What is the city with the largest revenue?
select city ,sum(total)/1.18 as Largest_Revenu from invoices 
group by city
order by  Largest_Revenu desc
limit 1;
-- 6. What product line had the largest VAT?
select Productline ,sum('5\%' * COGS) as Largest_vat from invoices 
group by Productline
order by  Largest_vat desc
limit 1;
-- 7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select Productline,
case when (Sales > avg_sales) then 'Good'
else 'Bad'
end as 'Status'
from 
(select Productline,
sum('Tax 5%'+ 'cogs') as Sales,
avg(sum('Tax 5%' + 'cogs')) over() as avg_sales from invoices
group by Productline)y;

select *  from invoices;
-- 8. Which branch sold more products than average product sold?
select branch 
from 
(select branch, count(Productline) as Product_count from invoices group by branch) as branch_sales
where Product_count > (select avg(Product_count) 
            from 
			(select count(Productline) as Product_count  
            from invoices group by branch) as avg_sales);


-- 9. What is the most common product line by gender?
select Productline, count(Gender) As Most_Common_Product_By_Gender
From invoices
group by Productline
order by  Most_Common_Product_By_Gender desc
Limit 1;

-- 12. What is the average rating of each product line?
select Productline , avg(rating) from  invoices
group by Productline;

select *  from invoices;
### Sales

-- 1. Number of sales made in each time of the day per weekday
select weekday(time) as week_day,
case
    When hour(time) >= 0 AND hour(time) < 6 Then '00:00 - 06:00'
    When hour(time) >= 6 AND hour(time) < 12 Then '06:00 - 12:00'
    When hour(time) >= 12 AND hour(time) < 18 Then '12:00 - 18:00'
    When hour(time) >= 0 AND hour(time) < 24 Then '18:00 - 00:00'
    End AS Time_of_the_day,
    count(*) as sales_count
    from invoices
    group by weekday(time),time_of_the_day
    order by time_of_the_day;
select * from invoices;
SELECT 
    Date AS Weekday, 
    HOUR(Time) AS HourOfDay, 
    COUNT(*) AS SalesCount
FROM 
    invoices
GROUP BY 
    Date, HOUR(Time), Date; 
    
    select * from invoices;

-- 2. Which of the customer types brings the most revenue?
select Customertype, sum(total) as mostrevenue
from invoices
group by 1
order by Customertype desc
limit 1;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
select City, 'Tax 5%' as Largest_Tax,Sum('Tax 5%'*cogs) AS Largest_VAT from invoices
group by City 
order by avg ('Tax 5%')
limit 1;
select * from invoices;
SELECT 
    City, 
    MAX(Tax) AS MaxTaxPercent
FROM 
    invoices
GROUP BY 
    City;
-- 4. Which customer type pays the most in VAT?
SELECT 
    CustomerType, 
    avg(total) AS TotalVAT
FROM 
    invoices
GROUP BY 
    CustomerType
ORDER BY 
    TotalVAT DESC
LIMIT 1;
select * from invoices;
select customertype, avg(total) as VAT
from invoices
group by Customertype
order by VAT desc
Limit 1;
### Customer

-- 1. How many unique customer types does the data have?
SELECT COUNT(DISTINCT customertype) AS unique_customertype
FROM invoices;
-- 2. How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) AS unique_payment_method
FROM invoices;
select * from  invoices;
-- 3. What is the most common customer type?
select Customertype, count(*) as Common_Customer_type from invoices
group by Customertype
order by Customertype desc
limit 1;

-- 4. Which customer type buys the most?
select Customertype, count(*) as most_buys from invoices
group by Customertype
order by Customertype desc
limit 1;
-- 5. What is the gender of most of the customers?
select gender, count(*) as most_of_the_customer from invoices
group by gender
order by gender desc
limit 1;
-- 6. What is the gender distribution per branch?
select branch,gender, count(*) as distribution_per_branch from invoices
group by branch,gender
order by distribution_per_branch desc
limit 10;
-- 7. Which time of the day do customers give most ratings?
select Day(date) as Day_1,
case
    When hour(time) >= 0 AND hour(time) < 6 Then '00:00 - 06:00'
    When hour(time) >= 6 AND hour(time) < 12 Then '06:00 - 12:00'
    When hour(time) >= 12 AND hour(time) < 18 Then '12:00 - 18:00'
    When hour(time) >= 0 AND hour(time) < 24 Then '18:00 - 00:00'
    
END Time_of_the_day ,count(Rating) As Rating_of_the_day
from  invoices 
group by day_1,time_of_the_day
order by time_of_the_day;
-- 8. Which time of the day do customers give most ratings per branch?
select Day(date) as Day_1,branch,
case
    When hour(time) >= 0 AND hour(time) < 6 Then '00:00 - 06:00'
    When hour(time) >= 6 AND hour(time) < 12 Then '06:00 - 12:00'
    When hour(time) >= 12 AND hour(time) < 18 Then '12:00 - 18:00'
    When hour(time) >= 0 AND hour(time) < 24 Then '18:00 - 00:00'
    
END Time_of_the_day ,count(Rating) As Rating_of_the_day
from  invoices 
group by day_1,branch,time_of_the_day
order by Rating_of_the_day desc;

select * from invoices;

-- 9. Which day fo the week has the best avg ratings?
select dayname(date) as day_of_week,
avg(rating) as avg_rating from  invoices
group by Dayofweek(Date),dayname(date)
order by avg_rating desc
limit 1;
-- 10. Which day of the week has the best average ratings per branch?
select dayname(date) as date_of_week,branch,
avg(rating) as avg_rating from  invoices
group by dayofweek(date),Branch,dayname(date)
order by avg_rating desc
limit 1;

select * from invoices;



 ## Revenue And Profit Calculations

-- /*$ COGS = unitsPrice * quantity $

-- $ VAT = 5\% * COGS $

-- $VAT$ is added to the $COGS$ and this is what is billed to the customer.

-- $ total(gross_sales) = VAT + COGS $

-- $ grossProfit(grossIncome) = total(gross_sales) - COGS $

-- **Gross Margin** is gross profit expressed in percentage of the total(gross profit/revenue)

-- $ \text{Gross Margin} = \frac{\text{gross income}}{\text{total revenue}} $

-- <u>**Example with the first row in our DB:**</u>

-- **Data given:**

-- - $ \text{Unite Price} = 45.79 $
-- - $ \text{Quantity} = 7 $

-- $ COGS = 45.79 * 7 = 320.53 $

-- $ \text{VAT} = 5\% * COGS\\= 5\%  320.53 = 16.0265 $

-- $ total = VAT + COGS\\= 16.0265 + 320.53 = $336.5565$

-- -- $ \text{Gross Margin Percentage} = \frac{\text{gross income}}{\text{total revenue}}\\=\frac{16.0265}{336.5565} = 0.047619\\\approx 4.7619\% $/*
-- **Data given:**
-- Calculate COGS
SELECT 
    Unitprice * Quantity AS COGS
FROM 
    invoices
LIMIT 10;

-- Calculate VAT
SELECT 
    0.05 * (UnitPrice * Quantity) AS VAT
FROM 
    invoices
LIMIT 10;

-- Calculate total gross sales (including VAT)

SELECT 
    (Unitprice * Quantity) + (0.05 * (Unitprice * Quantity)) AS TotalGrossSales
FROM 
    invoices
LIMIT 50;

-- Calculate gross profit (gross income)
SELECT 
    ((UnitPrice * Quantity) + (0.05 * (UnitPrice * Quantity))) - (UnitPrice * Quantity) AS GrossProfit
FROM 
    invoices
LIMIT 10;

-- Calculate total revenue
SELECT 
    SUM((UnitPrice * Quantity) + (0.05 * (UnitPrice * Quantity))) AS TotalRevenue
FROM 
    invoices;

-- Calculate gross margin
SELECT 
    ((SUM((UnitPrice * Quantity) + (0.05 * (UnitPrice * Quantity)))) - SUM(UnitPrice * Quantity)) / SUM((UnitPrice * Quantity) + (0.05 * (UnitPrice * Quantity))) AS GrossMargin
FROM 
    invoices;
   -- or 
    SELECT GrossIncome / TotalRevenue AS GrossMargin
FROM invoices
LIMIT 10;
-- **Data given:**

-- - $ \text{Unite Price} = 45.79 $
SELECT 
    45.79 * Quantity AS COGS
FROM 
    invoices;
  --   - $ \text{Quantity} = 7 $
  SELECT 
    UnitPrice * 7 AS COGS
FROM 
    invoices;
    -- COGS = 45.79 * 7 = 320.53 $
SELECT 
    45.79 * 7 AS COGS from 
	invoices; 
    -- $ \text{VAT} = 5\% * COGS\\= 5\%  320.53 = 16.0265 $
     SELECT 
    0.05 * 320.53 AS VAT
    from 
	invoices;
   --  $ total = VAT + COGS\\= 16.0265 + 320.53 = $336.5565$
   SELECT 
    16.0265 + 320.53 AS Total
    from invoices;
    --  $ \text{Gross Margin Percentage} = \frac{\text{gross income}}{\text{total revenue}}\\=\frac{16.0265}{336.5565} = 0.047619\\\approx 4.7619\% $
SELECT 
    (16.0265 / 336.5565) * 100 AS GrossMarginPercentage
    from invoices;

    select * from invoices;

