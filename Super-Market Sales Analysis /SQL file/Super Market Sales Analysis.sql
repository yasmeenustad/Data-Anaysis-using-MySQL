use sales_db;

-- Dataset:
select * from supermarket_sales1;

-- Length of the dataset:
select count(*) from supermarket_sales1;

-- Different Columns in the Dataset:
show columns from supermarket_sales1;


-- Different cities:
select distinct city from supermarket_sales1;


-- Calculate and Round Average Sales per City to Two Decimal Points:
select city, round(avg(total),2) as total_avg from supermarket_sales1
group by city
order by total_avg;

-- What are the primary payment types utilized by each gender, displayed in separate columns?
select payment, 
count(case when gender = 'Female' then gender end) as Female,
count(case when gender = 'male' then gender end) as Male from supermarket_sales1
group by payment
order by payment;

-- What are the top 5 product lines based on the average Revenue?
select Product_line, round(avg(total),2) as total_avg from supermarket_sales1
group by 1
order by 2 desc limit 5;

-- Retrieve the Maximum and Minimum Ratings for Each Product, Organized Column-Wise.
select product_line, max(rating) as high_rating, min(rating) as low_rating from supermarket_sales1
group by product_line;

-- Show the Gender Distribution Across Customer Types, Presented in Columns.
select customer_type , 
count(case when gender = 'Male' then Invoice_id end) as Male,
count(case when gender = 'Female' then Invoice_id end) as Female
from supermarket_sales1
group by customer_type;

-- What percent of Member & Normal customer_types are Female?
select 
round((count(case when customer_type = 'Member' then Invoice_id end) / (select count(Invoice_id) from supermarket_sales1))*100,0) as 'Member_percent (%)',
round((count(case when customer_type = 'Normal' then Invoice_id end) / (select count(Invoice_id) from supermarket_sales1))*100,0) as 'Normal_percent (%)' 
from supermarket_sales1
where gender = 'Female';

-- What percent of Member & Normal customer_types are Male?
select 
round((count(case when customer_type = 'Member' then Invoice_id end) / (select count(Invoice_id) from supermarket_sales1))*100,0) as 'Member_percent (%)',
round((count(case when customer_type = 'Normal' then Invoice_id end) / (select count(Invoice_id) from supermarket_sales1))*100,0) as 'Normal_percent (%)' 
from supermarket_sales1
where gender = 'Male';


-- What is the Male and Female distribution for each Product Line?
select product_line, 
count(case when gender = 'Male' then invoice_id end) as Male,
count(case when gender = 'Female' then invoice_id end) as Female
from supermarket_sales1
group by product_line
order by 2,3;

-- What are top 5 Selling Product Lines?
select product_line, sum(quantity) as total_sales from supermarket_sales1
group by 1
order by 2 desc limit 5;
