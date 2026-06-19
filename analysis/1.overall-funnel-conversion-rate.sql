-- constructing funnel flags
select
	session_id,
	-- Product View
  max(case when event_name = 'product_view' then 1 else 0 end) as viewed,
  min(case when event_name = 'product_view' then event_time end) as view_time,
  -- Add to Cart
  max(case when event_name = 'add_to_cart' then 1 else 0 end) as carted,
  min(case when event_name = 'add_to_cart' then event_time end) as cart_time,
  -- Checkout
  max(case when event_name = 'begin_checkout' then 1 else 0 end) as checkout,
  min(case when event_name = 'begin_checkout' then event_time end) as checkout_time,
  -- Purchase
  max(case when event_name = 'purchase' then 1 else 0 end) as purchased,
  min(case when event_name = 'purchase' then event_time end) as purchase_time
from analytics.events
group by session_id;

-- conversion fuunel 
with session_flags_by_funnel_stage as (
	select
	session_id,
		-- Product View
  	max(case when event_name = 'product_view' then 1 else 0 end) as viewed,
  	min(case when event_name = 'product_view' then event_time end) as view_time,
  	-- Add to Cart
  	max(case when event_name = 'add_to_cart' then 1 else 0 end) as carted,
  	min(case when event_name = 'add_to_cart' then event_time end) as cart_time,
  	-- Checkout
  	max(case when event_name = 'begin_checkout' then 1 else 0 end) as checkout,
  	min(case when event_name = 'begin_checkout' then event_time end) as checkout_time,
  	-- Purchase
  	max(case when event_name = 'purchase' then 1 else 0 end) as purchased,
  	min(case when event_name = 'purchase' then event_time end) as purchase_time
	from analytics.events
	group by session_id
)
select 
	sum(ft.viewed) as "Product view Stage",
	sum(ft.carted) as "Add to Cart Stage",
	sum(ft.checkout) as "Begin Checkout Stage",
	sum(ft.purchased) as "Purchase Stage",
	round(sum(ft.carted) * 1.0 / sum(ft.viewed), 4) as "Add to Cart Survival Rate",
	round(sum(ft.checkout) * 1.0 / sum(ft.viewed), 4) as "Begin Checkout Survival Rate",
	round(sum(ft.purchased) * 1.0 / sum(ft.viewed), 4) as "Overall Conversion Rate"
from(
	select
		session_id,
		viewed,
		view_time,
		carted,
		cart_time,
		checkout,
		checkout_time,
		purchased,
		purchase_time,
		case -- sequential validation
			when viewed = 1
				and carted = 1
				and checkout = 1
				and purchased = 1
				and view_time < cart_time
				and cart_time < checkout_time
				and checkout_time < purchase_time
			then 1 else 0
		end as valid_funnel_session -- session that went through every stage and generated a purchase
	from session_flags_by_funnel_stage
) as ft;



