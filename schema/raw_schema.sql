/*
====================================================
                  RAW SCHEMA CREATION
====================================================
*/

-- create the funnel_analysis database
create database funnel_analysis;

-- IMPORTANT NOTE 1: THEN SWITCH TO THE funnel_analysis database to create the schemas
 
-- create 'raw' schema to load the initial data and start insepecting and cleaning
create schema raw;

-- create the 'analytics' schema to store the ready cleaned data for analysis
create schema analytics;

-- IMPORTANT NOTE 2: remove primary keys in the raw schema because of the unique constraint, DATASET CONTAINS DUPLICATES THEY WILL PREVENT THE LOAD

-- creating the tables for the 'raw' schema
-- users table
create table raw.users (
    user_id uuid,
    signup_date timestamp,
    country varchar(50),
    acquisition_source varchar(50)
);

-- products table
create table raw.products (
  product_id uuid,
  product_name varchar(100),
  category varchar(50),
  price numeric(12, 2)
);

-- sessions tables
create table raw.sessions (
  session_id uuid,
  user_id uuid,
  session_start timestamp,
  device_type varchar(20),
  traffic_source varchar(50)
);

-- events table
create table raw.events (
  event_id uuid,
  session_id uuid,
  user_id uuid,
  product_id uuid,
  event_name varchar(50),
  event_time timestamp
);

-- IMPORTANT NOTE 3: create indexes after loading the data into the tables, creating indexes before loading the data will slow down the process