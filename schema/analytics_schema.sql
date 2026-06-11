
-- create 'users' table in the 'analytics' schema
create table analytics.users (
	user_id uuid primary key,
	signup_date timestamp,
	country varchar(50),
	acquisition_source varchar(50)
);

-- create 'products' table in the 'analytics' schema
create table analytics.products (
	product_id uuid primary key,
	product_name varchar(100),
	category varchar(50),
	price numeric(12, 2)
);

-- create 'sessions' table in the 'analytics' schema
create table analytics.sessions (
	session_id uuid primary key,
	user_id uuid references analytics.users(user_id),
	session_start timestamp not null,
	device_type varchar(20) not null,
	traffic_source varchar(50) not null
);



