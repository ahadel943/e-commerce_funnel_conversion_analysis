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

-- Duplicates Check
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
having count(*) > 1; -- duplicated rows found

select 
	sum(d.duplicates_count) as total_duplicated_rows,
	sum(duplicates_count - 1) as rows_to_be_removed
from (
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
) as d; -- 25,678 duplicated rows found, and 12,839 extra rows to be removed
	
-- Missing Values Check
select count(*) as missing_event_id from raw.events where event_id is null; -- NO missing values found
select count(*) as missing_session_id from raw.events where session_id is null; -- NO missing values found
select count(*) as missing_user_id from raw.events where user_id is null; -- NO missing values found
select count(*) as missing_product_id from raw.events where product_id is null; -- NO missing values found
select count(*) as missing_event_name from raw.events where event_name is null; -- NO missing values found
select count(*) as missing_event_time from raw.events where event_time is null; -- NO missing values found

-- PK Uniqueness Check
select 
	count(*) as total_count,
	count(distinct event_id) as event_ids_count
from raw.events; -- total_count is 1,319,940 and event_ids_count is 1,300,369 so duplicates event_id found

select d.total_count - d.event_ids_count as duplicated_event_ids_count
from (
	select 
		count(*) as total_count,
		count(distinct event_id) as event_ids_count
	from raw.events
) as d; -- 19,571 duplicated event_id

select event_id, count(*) as ids_count
from raw.events
group by event_id
having count(*) > 1
order by ids_count desc; -- event ids uniqueness violations confirmed

-- there are duplicated event ids with 2 duplictate records and 3 duplictate records
-- 120 event ids have 3 records with the same id, 19,331 event ids have 2 records with the id
select count(data.event_id) as cnt, data.ids_count
from (
	select event_id, count(*) as ids_count
	from raw.events
	group by event_id
	having count(*) > 1
	order by ids_count desc
) as data
group by data.ids_count;

select *
from raw.events 
where event_id = '7f1ec1e5-4de5-4c52-b849-000e2cf12ecd'; -- check

select 
	evs.event_id,
	count(*) as ids_count
from (
	select *,
	row_number() over(
		partition by event_id, session_id, user_id, product_id, event_name, event_time
		order by ctid
	) as rn
	from raw.events
) as evs
inner join analytics.sessions as s
on evs.session_id = s.session_id
where evs.rn = 1
group by evs.event_id
having count(*) > 1;

-- duplicates sample check
/*
1.000def79-1627-4902-b0f2-2f386a798e89 => 2 rows, exact duplicates
2.091066e6-7b11-45f5-9ef4-a9bdc68ceca8 => 2 rows, exact duplicates
3.0d751912-f16c-4ac4-99cd-f614b795455d => 2 rows, exact duplicates
4.12b66eeb-fa34-4e97-ba37-3e3def791e5e => 2 rows, exact duplicates
5.2112edfc-087b-4cae-84e2-ed2dd1c3db19 => 2 rows, exact duplicates
6.2f18f5bc-d161-48b9-8cdb-4f7c5f633cf0 => 2 rows, exact duplicates
7.3501a5bd-c5f9-42ec-8760-03a9c77ade25 => 2 rows, NO exact duplicates, 
																					event_name has 2 different values, product_view and purchase
																					every other column has the same exact value which is ODD
8.3e22457f-2cec-4f9b-846b-7368104ccb12 => 2 rows, NO exact duplicates,
																				event_name has 2 different values, begin_checkout and product_view
																				every other column has the same exact value 
9.403a34c5-0391-4ef1-9d21-2f3ff8779efa => 3 rows, NO exact duplicates, 2 rows are exact match,
																				1 rows has different session_id but every other column is exact match
10.44cb5d02-77e1-4822-96b8-7586cb53d35b => 2 rows, exact duplicates
*/
select * from raw.events where event_id = '44cb5d02-77e1-4822-96b8-7586cb53d35b';

-- Orphan Records Check

-- session_id orphan check
select count(*) as rows_count
from raw.events as e
left join analytics.sessions as s 
on s.session_id = e.session_id
where s.session_id is null; -- 6,567 orphan sessions were found

select count(distinct session_id)
from analytics.sessions

select count(distinct session_id)
from raw.sessions

select count(distinct e.session_id) as rows_count
from raw.events as e
left join analytics.sessions as s 
on s.session_id = e.session_id
where s.session_id is null; -- 6,567 affected sessiosns

select distinct e.session_id
from raw.events e
left join analytics.sessions s
on e.session_id = s.session_id
where s.session_id is null
limit 20; -- sample

-- user_id orphan check
select count(*) as rows_count
from raw.events as e
left join analytics.users as u 
on e.user_id = u.user_id
where u.user_id is null; -- NO orphan records by user_id

-- product_id orphan check
select count(*) as rows_count
from raw.events as e
left join analytics.products as p
on e.product_id = p.product_id 
where p.product_id is null; -- NO orphan records by product_id

-- Timestamp Assessment
select min(event_time), max(event_time)
from raw.events;

select min(session_start), max(session_start)
from raw.sessions;












