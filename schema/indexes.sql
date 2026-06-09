/*
====================================================
                  INDEXES CREATION
====================================================
*/

-- craeting indexes in the raw schema
-- events table indexes
create index idx_events_user on raw.events(user_id);
create index idx_events_session on raw.events(session_id);
create index idx_events_product on raw.events(product_id);
create index idx_events_event_name on raw.events(event_name);
create index idx_events_event_time on raw.events(event_time);

-- sessions table indexes
create index idx_sessions_user on raw.sessions(user_id);
create index idx_sessions_start on raw.sessions(session_start);