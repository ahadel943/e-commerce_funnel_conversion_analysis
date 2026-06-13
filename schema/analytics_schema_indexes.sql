/*
====================================================
            ANALYTICS SCHEMA INDEXES CREATION
====================================================
*/

-- events table indexes
create index idx_events_session on analytics.events(session_id);
create index idx_events_user on analytics.events(user_id);
create index idx_events_product on analytics.events(product_id);
create index idx_events_event_name on analytics.events(event_name);
create index idx_events_event_time on analytics.events(event_time);

-- sessions table indexes
create index idx_sessions_user on analytics.sessions(user_id);
create index idx_sessions_start on analytics.sessions(session_start);