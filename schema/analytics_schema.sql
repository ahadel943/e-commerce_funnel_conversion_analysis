
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