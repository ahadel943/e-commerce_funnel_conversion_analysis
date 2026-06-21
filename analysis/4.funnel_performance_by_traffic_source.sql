-- 4. How does funnel performance differ by traffic source?

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
	s.traffic_source,
	sum(ft.viewed) as "Product View",
	sum(ft.carted) as "Add to Cart",
	sum(ft.checkout) as "Checkout",
	sum(ft.purchased) as "Purchase",
	round(sum(ft.purchased) * 1.0 / sum(ft.viewed), 4) as "Overall CR%"
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
		purchase_time
	from session_flags_by_funnel_stage	
) as ft
inner join analytics.sessions as s
on ft.session_id = s.session_id
group by s.traffic_source;



