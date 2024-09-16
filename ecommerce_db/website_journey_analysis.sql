-- Website content and journey analysis

-- Pageviews overview for different webpages

select
	pageview_url,
    count(distinct website_pageview_id) as pageviews
from website_pageviews
where website_pageview_id < 1000
group by pageview_url
order by pageviews desc;

-- Landing page sessions

drop temporary table if exists first_pageview;

create temporary table first_pageview
select
	website_session_id,
    min(website_pageview_id) as min_pv_id
from website_pageviews
where website_pageview_id < 1000 -- arbitraty
group by website_session_id;


select
    website_pageviews.pageview_url as landing_page,
    count(distinct first_pageview.website_session_id) as sessions_for_landing_page
from first_pageview
	left join website_pageviews
    on first_pageview.min_pv_id = website_pageviews.website_pageview_id
group by
	website_pageviews.pageview_url;
    
-- Find most viewed website pages, ranked by session volume

select
	pageview_url,
    count(distinct website_session_id) as sessions
from website_pageviews
where created_at < '2012-06-09'
group by
    pageview_url
order by sessions desc;

-- Top entry/landing pages ranked by volume

create temporary table first_pv_per_session
select
	website_session_id,
    min(website_pageview_id) as first_pv
from website_pageviews
where created_at < '2012-06-12'
group by website_session_id;

select
	website_pageviews.pageview_url as landing_page,
    count(distinct first_pv_per_session.website_session_id) as sessions
from first_pv_per_session
	left join website_pageviews
		on first_pv_per_session.first_pv = website_pageviews.website_pageview_id
group by website_pageviews.pageview_url;