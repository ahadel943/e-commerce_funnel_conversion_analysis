-- data sample check
select * from raw.events e limit 10;
select * from raw.products p limit 10;
select * from raw.sessions s limit 10;
select * from raw.users u limit 10;

-- data size before data cleaning and processing
select count(*) from raw.events; -- 1,319,940 events
select count(*) from raw.products; -- 500 products
select count(*) from raw.sessions; -- 300,000 sessions
select count(*) from raw.users; -- 50,000 users


















