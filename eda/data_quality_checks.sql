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

-- Evaluating the 'sessions' table
-- Duplicates Check
select
	session_id,
	user_id,
	session_start,
	device_type,
	traffic_source,
	count(*) as duplicates_count
from raw.sessions
group by
	session_id,
	user_id,
	session_start,
	device_type,
	traffic_source
having count(*) > 1; -- NO duplicated rows found
	
-- Missing Values Check
select count(*) as missing_session_id from raw.sessions where session_id is null; -- NO missing values found
select count(*) as missing_user_id from raw.sessions where user_id is null; -- NO missing values found
select count(*) as missing_session_start from raw.sessions where session_start is null; -- NO missing values found
select count(*) as missing_device_type from raw.sessions where device_type is null; -- NO missing values found
select count(*) as missing_traffic_source from raw.sessions where traffic_source is null; -- 9,000 missing values were found

-- PK Uniqueness Check
select
	count(*) as total_count,
	count(distinct session_id) as session_ids_count
from raw.sessions; session_id uniqueness confirmed

-- Orphan Records Check
select count(*) as orphans_count
from raw.sessions as s
left join analytics.users as u 
	on s.user_id = u.user_id 
where u.user_id is null; -- NO orphans records found in the sessions table, every user_id FK exists as PK in the users table

-- Timestamp Validation
-- Session activity spans from 2024-01-01 to 2025-12-30.
-- No future timestamps detected.
-- Daily session volume appears consistent (349–476 sessions/day, avg 411).

select count(*) as count
from raw.sessions
where session_start > now(); -- NO future timestamps found

select 
	min(session_start),
	max(session_start)
from raw.sessions; -- the data covers the period from 2024-01-01 to 2025-12-30

select
	max(sessions_count), min(sessions_count), round(avg(sessions_count))
from (
	select
		date(session_start),
		count(*) as sessions_count
	from raw.sessions
	group by date(session_start)
	order by date(session_start)
) as d; -- the daily sessions distribution is logical



-- Invalid Event Order Check

-- Timestamp Validation















