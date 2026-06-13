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

-- check befre data insertion, total_rows and distinct_event_ids should be equal
with deduplicated_events as ( -- CTE to remove cxact duplicates
  select
  	*,
    row_number () over (
    		partition by event_id, session_id, user_id, product_id, event_name, event_time
        order by ctid
    ) as duplicate_rn
  from raw.events
),
valid_events as ( -- CTE to rank the rows, after removing exact duplicates, and keep only the first row
	select
    de.event_id,
    de.session_id,
    de.user_id,
    de.product_id,
    de.event_name,
    de.event_time,
    row_number() over (partition by d.event_id order by d.event_time) as event_id_rn
  from deduplicated_events as de
  inner join analytics.sessions as s
  on de.session_id = s.session_id
  where duplicate_rn = 1
)
select
  count(*) as total_rows,
  count(distinct event_id) as distinct_event_ids
from valid_events
where event_id_rn = 1;

-- transfer clean data to analytics.events
insert into analytics.events
with deduplicated_events as ( -- CTE to remove cxact duplicates
  select
  	*,
    row_number () over (
    		partition by event_id, session_id, user_id, product_id, event_name, event_time
        order by ctid
    ) as duplicate_rn
  from raw.events
),
valid_events as ( -- CTE to rank the rows, after removing exact duplicates, and keep only the first row
	select
    de.event_id,
    de.session_id,
    de.user_id,
    de.product_id,
    de.event_name,
    de.event_time,
    row_number() over (partition by de.event_id order by de.event_time) as event_id_rn
  from deduplicated_events as de
  inner join analytics.sessions as s
  on de.session_id = s.session_id
  where duplicate_rn = 1
)
select
	event_id,
  session_id,
  user_id,
  product_id,
  event_name,
  event_time
from valid_events
where event_id_rn = 1;











