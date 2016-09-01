with maxtime_pv as 
(
	select max(created_at) as max_time
	from petition_view
),

hours as 
(
select
	date_trunc('hour', created_at) as hour
from petition_view v
where created_at >= (select max_time from maxtime_pv) - interval '1 days'
group by 1
),

views as
(
select
	petition_id
  , country_code
  , ptime
  , sum(views) as views
  , sum(aaviews) as aaviews
  , sum(view_rise) as view_rise
from
	(
		SELECT
			petition_id
		  , country_code
		  , date_trunc('hour', created_at) AS ptime
		  , COUNT(*) AS views
		  , COUNT(CASE WHEN current_medium ilike '%email%' THEN 1 END ) AS aaviews
		  , COUNT(*) - lag(COUNT(*), 1) over(partition by petition_id ORDER BY ptime) AS view_rise
		FROM hours h
		join petition_view v on date_trunc('hour', created_at) between h.hour - interval '3 hour' and h.hour - interval '1 hour'
		GROUP BY 1,2,3

		UNION ALL

		SELECT
			petition_id
		  , country_code
		  , date_trunc('hour', created_at) AS ptime
		  , COUNT(*) AS views
		  , COUNT(CASE WHEN current_medium ilike '%email%' THEN 1 END ) AS aaviews
		  , COUNT(*) - lag(COUNT(*), 1) over(partition by petition_id ORDER BY ptime) AS view_rise
		FROM hours h
		join petition_update_view v on date_trunc('hour', created_at) between h.hour - interval '3 hour' and h.hour - interval '1 hour'
		GROUP BY 1,2,3

		UNION ALL

		SELECT
			petition_id
		  , country_code
		  , date_trunc('hour', created_at) AS ptime
		  , COUNT(*) AS views
		  , COUNT(CASE WHEN current_medium ilike '%email%' THEN 1 END ) AS aaviews
		  , COUNT(*) - lag(COUNT(*), 1) over(partition by petition_id ORDER BY ptime) AS view_rise
		FROM hours h
		join petition_sign_views v on date_trunc('hour', created_at) between h.hour - interval '3 hour' and h.hour - interval '1 hour'
		GROUP BY 1,2,3
	)
group by 1,2,3
),

signatures as
(
	SELECT
	    petition_id
	  , country_code
	  , date_trunc('hour', created_at) AS ptime
	  , COUNT(*) AS signatures
	FROM hours h
	join sign v on date_trunc('hour', created_at) between h.hour - interval '3 hour' and h.hour - interval '1 hour'
	GROUP BY 1,2,3
)

select distinct id, country, title, tag_name
from
(
SELECT
     v.petition_id AS id
   , v.country_code as country
   , (CASE WHEN e.title IS NULL THEN substring(e.ask, 1, 50) ELSE substring(e.title, 1, 50) END) AS title
   , c.tag_name as tag_name
   , (100*sum(v.aaviews)::float/sum(v.views)::float)::int as percent_aa
   , coalesce(sum(s.signatures)::char(6), 'N/A') as signatures
   , coalesce(((100.0*sum(s.signatures)/sum(v.views))::int)::char(3) || '%', 'N/A') as conversion_rate
   , MAX(v.view_rise) AS view_rise_per_hour
   , max(coalesce(s1.hours, s2.hours)) as interval
FROM views v
INNER JOIN events e ON e.id = v.petition_id
LEFT JOIN signatures s on v.petition_id = s.petition_id and v.country_code = s.country_code and v.ptime = s.ptime
LEFT JOIN 
	(
		select ev.id, max(coalesce(t1.name, t2.name)) as tag_name
		from events ev
		left join collage_tags tgs1 on ev.id = tgs1.petition_id
		left join tags t1 on tgs1.tag_id = t1.id
		left join taggings tgs2 on ev.id = tgs2.taggable_id
		left join tags t2 on tgs2.tag_id = t2.id 
		group by 1
	) c on c.id = e.id
LEFT JOIN spike_alerter_metrics s1 on s1.metric = 'petition views' and s1.country_code = v.country_code
LEFT JOIN spike_alerter_metrics s2 on s2.metric = 'petition views' and s2.country_code = 'default'
WHERE v.view_rise > coalesce(s1.threshold, s2.threshold)
GROUP BY 1,2,3,4
)
WHERE tag_name is null
ORDER BY 2,1,3,4	
;
