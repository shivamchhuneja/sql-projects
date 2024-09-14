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


-- Google search non branded sessions on a week by week trend

select
    min(date(created_at)) as week_started_at,
    count(distinct website_session_id) as sessions
from website_sessions
where created_at < '2012-05-12'
	and utm_source = 'gsearch'
	and utm_campaign = 'nonbrand'
group by
	year(created_at),
	week(created_at);
    
-- After bid reduction there was about 20-30% reduction in sessions rendering this campaign fairly sensetive to bid changes.

-- Understand conversion rates for gsearch, nonbrand campaign based on the device type in order to figure out if there is a way to improve conversions this way.and

select
	count(distinct website_sessions.website_session_id) as sessions,
	count(distinct orders.order_id) as orders,
	device_type,
	count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conv_rate
from website_sessions
	left join orders
		on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-05-11'
	and utm_source = 'gsearch'
	and utm_campaign = 'nonbrand'
group by
	device_type
order by
	sessions desc;

-- Desktop conversion rate at 3.7% while mobile was 0.09% with 3911 sessions and 146 orders on desktop and 2492 sessions to 24 orders on mobile.

-- Recheck weekly trends and the net effect on device type of the bid change

select
	min(date(created_at)) as week_start_date,
	count(distinct case when device_type = 'desktop' then website_session_id else NULL end) as dtop_sessions,
	count(distinct case when device_type = 'mobile' then website_session_id else NULL end) as mob_sessions
from website_sessions
where created_at > '2012-04-15'
	and created_at < '2012-06-09'
	and utm_source = 'gsearch'
	and utm_campaign = 'nonbrand'
group by
	year(created_at),
	week(created_at);

-- Bid changes applied showed an about 40% increase in desktop traffic week of 20 May, while mobile showed a slight decrease.

-- 
