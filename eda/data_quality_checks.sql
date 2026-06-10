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
select count(*) from raw.users where user_id is null;
select count(*) from raw.users where signup_date is null;
select count(*) from raw.users where country is null; -- 1,000 rows with missing 'country' value
select count(*) from raw.users where acquisition_source is null;

-- PK Uniqueness Check
select 
	count(*) as total_count,
	count(distinct user_id) as uniq_user_ids -- user_id uniqueness confirmed
from raw.users;

-- Orphan Records Check

-- Invalid Event Order Check

-- Timestamp Validation