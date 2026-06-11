-- Evaluating the 'users' table

-- Duplicates Check
select 
	user_id,
	signup_date,
	country,
	acquisition_source,
	count(*) as duplicates_count
from raw.users
group by 
	user_id,
	signup_date,
	country,
	acquisition_source
having count(*) > 1; -- NO duplicated rows found

-- Missing Values Check
select count(*) as missing_user_id from raw.users where user_id is null; -- NO missing values found
select count(*) as missing_signup_date from raw.users where signup_date is null; -- NO missing values found
select count(*) as missing_country from raw.users where country is null; -- 1,000 rows with missing 'country' value
select count(*) as missing_acquisition_source from raw.users where acquisition_source is null; -- NO missing values found

-- PK Uniqueness Check
select 
	count(*) as total_count,
	count(distinct user_id) as uniq_user_ids 
from raw.users; -- user_id uniqueness confirmed

-- Evaluating the 'products' table
-- Duplicates Check
select
	product_id,
	product_name,
	category,
	price,
	count(*) as duplicates_count
from raw.products
group by
	product_id,
	product_name,
	category,
	price
having count(*) > 1; -- NO duplicated rows found

-- Missing Values Check
select count(*) as missing_product_id from raw.products where product_id is null; -- NO missing values found
select count(*) as missing_product_name from raw.products where product_name is null; -- NO missing values found
select count(*) as missing_category from raw.products where category is null; -- NO missing values found
select count(*) as missing_price from raw.products where price is null; -- NO missing values found

-- PK Uniqueness Check
select
	count(*) as total_count,
	count(distinct product_id) as product_ids_count
from raw.products; -- product_id uniqueness confirmed

-- Orphan Records Check

-- Invalid Event Order Check

-- Timestamp Validation















