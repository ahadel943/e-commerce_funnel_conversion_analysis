/*
====================================================
                    DATA CLEANING
====================================================
*/

-- loading 'users' data into the analytics.users table
-- 1,000 missing values were found in the 'country' column in the raw.users table
-- the missing values will be replaced with 'Unknown' to preserve user records while maintaining data completeness
insert into analytics.users
select 
	user_id,
	signup_date,
	coalesce(country, 'Unknown') as country,
	acquisition_source
from raw.users;

-- data validation
select count(*) from analytics.users;
select distinct country from analytics.users;
select * from analytics.users limit 10;

-- loading 'products' data into the analytics.products table
insert into analytics.products
select
	product_id,
	product_name,
	category,
	price
from raw.products;

-- data validation
select count(*) from analytics.products;
select * from analytics.products limit 10;


