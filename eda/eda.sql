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













select * from analytics.products limit 10;
select category, count(product_id) as products_count
from analytics.products
group by category;








