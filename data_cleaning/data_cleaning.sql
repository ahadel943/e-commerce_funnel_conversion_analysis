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

-- transfering data to the events table in the analytics schema
-- and removing the 12,839 extra duplicates rows
-- and excluding the 6,567 orphan sessions
insert into analytics.events 
select
	evs.event_id,
  evs.session_id,
  evs.user_id,
  evs.product_id,
  evs.event_name,
  evs.event_time
from (
	select 
		*,
		row_number() over(
			partition by event_id, session_id, user_id, product_id, event_name, event_time
			order by ctid
		) as rn
	from raw.events
) as evs
inner join analytics.sessions as s
on evs.session_id = s.session_id
where rn = 1;

/*
 SQL Error [23505]: ERROR: duplicate key value violates unique constraint "events_pkey"
  Detail: Key (event_id)=(1108a6b9-39b4-49a1-8ea9-0d81914095fb) already exists.

Error position:*/

delete from analytics.events;
select * from analytics.events;













