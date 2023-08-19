-- ELECTRONIC PRODUCT SALES 
/* TASK:
1. What was the best month for sales? How much was earned that month?
2. What city had the highest number of sales?
3. What time should we display advertisement to maximize the likelihood of customer's buying product?
4. What product are often sold together?
5. What product sold the most? */

-- The dataset has been cleaned on microsoft excel

-- Creating a table for the dataset
CREATE TABLE sales_data2 (
order_id integer,
product text,
quantity_ordered integer,
price_each float,
sales float,
order_date text,
address text,
city text,
state text,
postal_code integer)
;

-- Inserting values into the created sales_data table
LOAD DATA INFILE 'sales_2019.csv'
INTO TABLE sales_data2
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Checking for duplication
SELECT records, count(*)
FROM
(
	SELECT order_id, product, quantity_ordered, price_each, sales, order_date, address, city, state, postal_code,
    count(*) as records
	FROM sales_data2
	GROUP BY 1,2,3,4,5,6,7,8,9,10
)a
WHERE records > 1
GROUP BY 1
;

-- Checking for missing values 
SELECT *
FROM sales_data2
WHERE order_id is null
  OR product is null
  OR quantity_ordered is null
  OR price_each is null
  OR sales is null
  OR order_date is null
  OR address is null
  OR city is null
  OR state is null
  OR postal_code is null
;

-- Checking for all columns
SELECT *
FROM sales_data2
WHERE extract(year from order_date) = 2019
;

-- Best month of sales in the year 2019
SELECT monthname(order_date) as month_name,
sum(sales) as sales
FROM sales_data2
WHERE extract(year from order_date) = 2019
GROUP BY 1  
;

-- Highest number of sales by city 
SELECT city, sum(sales) as sales
FROM sales_data2
WHERE extract(year from order_date) = 2019
GROUP BY 1
ORDER BY 2 DESC 
;

-- Products that are sold together
SELECT concat(product1, ', ', product2) as products, product_count 
FROM  
(
    SELECT a.product1, b.product2, count(*) as product_count
    FROM sales_data2 a
    JOIN sales_data b on a.order_id = b.order_id
    WHERE extract(year from a.order_date) = 2019 and a.product1 > b.product2
    GROUP BY 1,2
    ORDER BY 3 DESC
)a
ORDER BY 2 DESC
;

-- Product that sold the most 
SELECT product, sum(quantity_ordered) as qty_sold
FROM sales_data2
WHERE extract(year from order_date) = 2019
GROUP BY 1 
ORDER BY 2 DESC
;
-- Best time to display advertisement
SELECT extract(hour from order_date) as hour, count(*) AS order_count
FROM sales_data2
WHERE extract(year from order_date) = 2019
GROUP BY 1
ORDER BY 1
;

-- Best day to display advertisement
SELECT dayname(order_date) as day_name,
count(*) order_count
FROM sales_data2
WHERE extract(year from order_date) = 2019
GROUP BY 1
ORDER BY 2 DESC
;

-- CONCLUSION 
-- Best time for advertisement 
/* The best time for advertisement are the morning hours and evening hours. Due to the fact that orders are made
 mostly in the hours of 09:00-12.00 and 16:00-19:00. */

-- Best day for advertisement
/* All days have almost the same order count throughout the year, however, Tuesday and Monday has the
highest order count respectively. Tuesdays and Mondays are the best days for advertisement. */

-- Datasource: www.kaggle.com
