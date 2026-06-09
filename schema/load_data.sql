/*
====================================================
                DATA LOADING INSTRUCTIONS
====================================================
*/


/*
load datasets
using psql cli to load the data

- loading data to users table 
  \copy raw.users (user_id, signup_date, country, acquisition_source)
  from 'FILE_PATH\data\users.csv'
  with (format csv, header true);

- loading data to products table
  \copy raw.products (product_id, product_name, category, price)
  from 'FILE_PATH\data\products.csv'
  with (format csv, header true);

- loading data to sessions table
  \copy raw.sessions (session_id, user_id, session_start, device_type, traffic_source)
  from 'FILE_PATH\data\sessions.csv'
  with (format csv, header true);

- loading data to events table
  \copy raw.events (event_id, session_id, user_id, product_id, event_name, event_time)
  from 'FILE_PATH\data\events.csv'
  with (format csv, header true);
*/