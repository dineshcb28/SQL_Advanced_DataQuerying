/*
Can you help me understand where the bulk of our website sessions are coming from, through yesterday?
I’d like to see a breakdown by UTM source , campaign and referring domain if possible. Thanks!
*/

SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id) AS Number_of_sessions
FROM 
	website_sessions
WHERE
	created_at < '2012-04-12'
GROUP BY
	1,2,3
ORDER BY 4 DESC;

/*
Sounds like gsearch nonbrand is our major traffic source, but we need to understand if those sessions are driving sales.
Could you please calculate the conversion rate (CVR) from session to order ? Based on what we're paying for clicks,
we’ll need a CVR of at least 4% to make the numbers work.
*/

SELECT
	COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
    COUNT(DISTINCT orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id)/COUNT(website_sessions.website_session_id) AS CVR
FROM website_sessions
LEFT JOIN orders ON website_sessions.website_session_id = orders.website_session_id
WHERE 
	orders.created_at < '2012-04-14' AND
    website_sessions.utm_source = 'gsearch' AND
    website_sessions.utm_campaign = 'nonbrand';
    
SELECT
	primary_product_id,
   COUNT(CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS One_item_Purchased,
   COUNT(CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS two_item_Purchased,
   COUNT(items_purchased) AS total_orders
FROM orders
GROUP BY 1;

/*
Based on your conversion rate analysis, we bid down gsearch nonbrand on 2012 04 15.
Can you pull gsearch nonbrand trended session volume, by
week , to see if the bid changes have caused volume to drop at all?
*/

SELECT
    MIN(DATE(created_at)) AS WEEK,
    COUNT(website_session_id) AS Sessions
FROM website_sessions
WHERE
	created_at < '2012-05-12' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
    WEEK(created_at);
    
/*
Could you pull conversion rates from session to order , by device type ?
*/

SELECT
	website_sessions.device_type,
    COUNT(orders.order_id) AS orders,
    COUNT(website_sessions.website_session_id) AS Sessions,
    COUNT(orders.order_id)/COUNT(website_sessions.website_session_id) AS CVR
FROM
	website_sessions
	LEFT JOIN orders ON
		website_sessions.website_session_id = orders.website_session_id
WHERE
	orders.created_at < '2012-05-11' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand'
GROUP BY website_sessions.device_type;

/*
Could you pull weekly trends for both desktop and mobile so we can see the impact on volume?
You can use 2012 04 15 until the bid change as a baseline.
*/

SELECT
	MIN(DATE(created_at)) AS Week_start_date,
    COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) as Mob_sessions,
	COUNT(CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) as Desk_sessions
FROM website_sessions
WHERE
	created_at < '2012-06-09' AND
    created_at > '2012-05-19' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
    WEEK(created_at);