
-- create 'users' table
create table analytics.users (
	user_id uuid primary key,
	signup_date timestamp,
	country varchar(50),
	acquisition_source varchar(50)
);