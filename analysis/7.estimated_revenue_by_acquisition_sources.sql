-- 7. Which acquisition sources generate the highest estimated revenue?

select
	u.acquisition_source,
	count(*) as purchase_count, -- 45743
	round(sum(p.price)) as estimated_revenue,
	count(distinct e.user_id) as purchasing_users,
	round(sum(p.price) / count(distinct e.user_id)) as avg_estimated_revenue_per_user,
	round(sum(p.price) / count(*)) as avg_estimated_revenue_per_purchase
from analytics.events as e
join analytics.sessions as s
	on e.session_id = s.session_id
join analytics.products as p
	on e.product_id = p.product_id
join analytics.users as u
	on s.user_id = u.user_id
where e.event_name = 'purchase'
group by u.acquisition_source;






