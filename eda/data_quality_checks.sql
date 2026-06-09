
-- Duplicates Check
-- users table duplicated rows check
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

-- products table duplicated rows check
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

-- sessions table duplicated rows check
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

-- events table duplicated rows check
select	
	event_id,
	session_id,
	user_id,
	product_id,
	event_name,
	event_time,
	count(*) as duplicates_count
from raw.events
group by 
	event_id,
	session_id,
	user_id,
	product_id,
	event_name,
	event_time
having count(*) > 1; -- ==>> DUPLICATED ROWS FOUND <<==

with events_duplicates as (
	select	
	event_id,
	session_id,
	user_id,
	product_id,
	event_name,
	event_time,
	count(*) as duplicates_count
from raw.events
group by 
	event_id,
	session_id,
	user_id,
	product_id,
	event_name,
	event_time
	having count(*) > 1
)
select
	sum(duplicates_count) as total_duplicated_rows,
	sum(duplicates_count - 1) as extra_rows_to_be_removed
from events_duplicates; -- 25,678 total duplicated rows were found, 12,839 extra rows to be removed

-- PK Uniqueness Check

-- Missing Values Check

-- Orphan Records Check

-- Invalid Event Order Check

-- Timestamp Validation