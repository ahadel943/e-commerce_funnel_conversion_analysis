-- data sample check
select * from raw.events e limit 10;
select * from raw.products p limit 10;
select * from raw.sessions s limit 10;
select * from raw.users u limit 10;

-- data size before cleaning and processing
select count(*) from raw.events; -- 1,319,940 events
select count(*) from raw.products; -- 500 products
select count(*) from raw.sessions; -- 300,000 sessions
select count(*) from raw.users; -- 50,000 users

-- data size after cleaning and transfering to the analytics schema
select count(*) from analytics.events; -- 1,300,369 events
select count(*) from analytics.products; -- 500 products
select count(*) from analytics.sessions; -- 300,000 sessions
select count(*) from analytics.users; -- 50,000 users

-- data distribution
select * from analytics.users limit 10;

-- users by country
select
	country,
	count(user_id) as users_count,
	sum(count(*)) over() as total_users_count,
	round(count(user_id) / sum(count(*)) over(), 2) as perc
from analytics.users
group by country
order by users_count desc;

-- users by acquisition_source
select 
	acquisition_source,
	count(user_id) as users_count,
	sum(count(*)) over() as total_users_count,
	round(count(user_id) / sum(count(*)) over(), 2) as perc
from analytics.users
group by acquisition_source
order by users_count desc;


-- timeframe check
select
	min(signup_date)as signup_perid_start, -- 2024-01-01 00:10:36.000
	max(signup_date) as signup_period_end -- 2025-12-30 23:41:28.000
from analytics.users;

-- users signup trend
select
	extract(year from signup_date) as "year",
	extract(month from signup_date) as "month",
	to_char(signup_date, 'Mon') as month_name,
	count(user_id) as users_count
from analytics.users
group by "year", "month", month_name
order by "year", "month", month_name;

-- sessions count by user
select 
	user_sessions_count,
	count(user_id) as users_count
from (
	select 
		user_id,
		count(session_id) as user_sessions_count
	from analytics.sessions
	group by user_id
) as sessions_stats
group by user_sessions_count
order by user_sessions_count;

-- sessions summary stats by user count
select 
	min(user_sessions_count) as lowest_sessions_count,
	max(user_sessions_count) as highest_sesions_count,
	round(avg(user_sessions_count), 2) as avg_sesions_count,
	percentile_cont(0.5) within group (order by user_sessions_count) as median_sessions_count 
from (
	select 
		user_id,
		count(session_id) as user_sessions_count
	from analytics.sessions
	group by user_id	
) as sessions_stats;

-- sessions count by device type
select
	device_type,
	count(session_id) as sessions_count,
	sum(count(session_id)) over() as total_sessions_count,
	round(count(session_id) / sum(count(session_id)) over(), 2) as perc
from analytics.sessions
group by device_type;

-- sessions stats by device type
select 
	sessions_stats.device_type,
	min(sessions_stats.user_sessions_count) as lowest_sessions_count,
	max(sessions_stats.user_sessions_count) as highest_sesions_count,
	round(avg(sessions_stats.user_sessions_count), 2) as avg_sesions_count,
	percentile_cont(0.5) within group (order by sessions_stats.user_sessions_count) as median_sessions_count
from (
	select 
		user_id,
		device_type,
		count(session_id) as user_sessions_count
	from analytics.sessions
	group by user_id, device_type
) as sessions_stats
group by sessions_stats.device_type;

-- sessiosn count traffic_source
select 
	traffic_source,
	count(session_id) as sessions_count,
	sum(count(session_id)) over() as total_sessions_ccount,
	round(count(session_id) / sum(count(session_id)) over(), 2) as perc
from analytics.sessions
group by traffic_source
order by sessions_count desc;

select 
	sessions_stats.traffic_source,
	min(sessions_stats.user_sessions_count) as lowest_sessions_count,
	max(sessions_stats.user_sessions_count) as highest_sesions_count,
	round(avg(sessions_stats.user_sessions_count), 2) as avg_sesions_count,
	percentile_cont(0.5) within group (order by sessions_stats.user_sessions_count) as median_sessions_count
from (
	select 
		user_id,
		traffic_source,
		count(session_id) as user_sessions_count
	from analytics.sessions
	group by user_id, traffic_source
) as sessions_stats
group by sessions_stats.traffic_source;








