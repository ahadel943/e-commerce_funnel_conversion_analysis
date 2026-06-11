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

-- No data quality issues were found in the products table.
-- Data transferred directly to analytics.products.
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

-- 'sessions' table 'traffic_source' missing values fix
-- 9,000 missing traffic source values (3% of sessions) were replaced with 'Unknown'
-- to preserve session records and avoid introducing bias through imputation.
insert into analytics.sessions
select
	session_id,
	user_id,
	session_start,
	device_type,
	coalesce(traffic_source, 'Unknown') as traffic_source
from raw.sessions;

-- data validation
select count(*) from analytics.sessions;
select * from analytics.sessions limit 10;
select distinct traffic_source from analytics.sessions;



