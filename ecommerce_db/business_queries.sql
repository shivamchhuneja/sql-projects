use mavenfuzzyfactory;

-- Which source has what conversion rate?

select 
	utm_content as session_source,
    count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id) as orders,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conv_rate
from website_sessions
	left join orders
		on orders.website_session_id = website_sessions.website_session_id
-- where website_sessions.website_session_id between 1000 AND 2000
group by
	utm_content
order by sessions desc;

-- Get sessions breakdown by UTM, campaign & referring domain

select
	utm_source,
    utm_campaign,
    http_referer,
    count(distinct website_session_id) as sessions
from website_sessions
where created_at < '2012-04-12'
group by
	utm_source,
    utm_campaign,
    http_referer
order by sessions desc;

-- Non branded sessions from google search were the highest at 3613.
-- So it would be a good idea to dig into what non branded keywords are resulting into so many sessions via Google Search.


-- Converstion rate from sessions into orders: If CVR < 4%, then bids would need to be reduced, else increase bids to drive more volume

select * from orders;

select
	count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id) as orders,
	count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conversion_rate
from website_sessions
	left join orders
		on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-04-14'
	and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
;

-- Session_count = 3895, Order_count = 112, Conversion_rate = 2.88% which is less than 4%, so search ad bids should be dialed down to curb overspending


-- 

	
