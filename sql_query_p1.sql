/*sql retail sales analysis*/
CREATE DATABASE sql_project_2;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
where
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-------
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

/*How Many Sales we have?*/
SELECT COUNT(*) as total_sale FROM retail_sales

/*How Many unique customers we have*/
SELECT COUNT(distinct customer_id) as total_sale FROM retail_sales

/*how many unique category we have*/
SELECT distinct category FROM retail_sales


------- Data Analysis & Business key Problems & Answers ---

/*Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:*/

SELECT*
FROM retail_sales
WHERE sale_date='2022-11-05';


/*Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:*/
SELECT *
FROM retail_sales
WHERE category ='Clothing' 
	  AND  EXTRACT(MONTH FROM sale_date) =11 
	  AND EXTRACT(YEAR FROM sale_date) =2022
      AND (quantity)>=4;


/*Q.3 Write  SQL query to calculate the total sales (total_sale) for each category*/
SELECT category,
	   sum(total_sale) as net_sale,
	   count(*) as 	total_orders
FROM retail_sales
group by category;


/*Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.*/
SELECT category,
	  Round(AVG(age), 2) as Avg_age
FROM retail_sales
where category ='Beauty'
group by category;


/*Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.*/
SELECT*
FROM retail_sales
WHERE total_sale>1000;


/*Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.*/
SELECT category,
       gender,
	   count(transactions_id)
FROM retail_sales
group by category,gender
order by category;


/*Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year*/
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

/*Q.8 Write a SQL query to find the top 5 customers based on the highest total sales*/
SELECT customer_id,
	   sum(total_sale) as total_sales
FROM Retail_sales
group by customer_id
order by sum(total_sale) desc limit 5;

/*Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.*/
SELECT category,
	   count(Distinct customer_id) as customer_id
FROM Retail_sales
group by category;

/*Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)*/
WITH hourly_sale
as
(SELECT *,
	CASE 
	    WHEN EXTRACT (HOUR FROM sale_time)<12 THEN 'MORNING'
	    WHEN EXTRACT (HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'AFTERNOON'
	    ELSE 'EVENING'
	END as shift
FROM retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift


