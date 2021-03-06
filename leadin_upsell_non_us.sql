--aguadamuz@change.org
WITH e AS
(
	SELECT DISTINCT e.id, e.status, case when e.title IS NULL then substring(e.description,4,125) else substring(title,1,125) end as title, e.change_id, e.total_signature_count, e.sponsored, e.relevant_location_id, l.country_code,
	'http://www.change.org/p/' || CAST(e.id as text) as url
	FROM events e
    LEFT JOIN locations l ON e.relevant_location_id = l.id
	WHERE e.deleted_at IS NULL
	AND e.status = 1 -- do we only want active petitions? I am assuming yes.
	--AND e.created_locale = 'en-US'
)
, uvo AS --upsell views and optins
(
	
with views as
(
SELECT upsell_id, petition_id, organization_name, targeting_type, SUM(views) AS views
FROM awang.kpi_dash_views
WHERE upsell_view_date >= current_date - interval '8 days' 
AND upsell_view_date <= current_date - interval '1 days' 
--AND country_code IN ('GB', 'AU', 'DE', 'FR', 'IT', 'ES', 'NL', 'BR', 'CA', 'AR', 'TH')
group by 1,2,3,4
),

optins as
(
SELECT upsell_id, petition_id, organization_name, targeting_type, SUM(optins) AS optins
FROM awang.kpi_dash_optins
WHERE upsell_optin_date >= current_date - interval '8 days' 
AND upsell_optin_date <= current_date - interval '1 days' 
--AND country_code IN ('GB', 'AU', 'DE', 'FR', 'IT', 'ES', 'NL', 'BR', 'CA', 'AR', 'TH')

group by 1,2,3,4
)

SELECT a.upsell_id, a.petition_id, a.organization_name, a.targeting_type, SUM(a.views) AS views, SUM(b.optins) AS optins
FROM views a
JOIN optins b on a.upsell_id = b.upsell_id and a.petition_id = b.petition_id and a.organization_name = b.organization_name and a.targeting_type = b.targeting_type
GROUP BY 1,2,3,4
)
, idft AS -- ids for tags
(
	SELECT id AS id
	FROM (
			SELECT upsell_id::int AS id FROM uvo
			UNION
			SELECT petition_id::int AS id FROM uvo
		)
	GROUP BY 1
)
, tag1 AS
(
	SELECT DISTINCT idft.id, t.name FROM idft
	JOIN taggings tgs ON tgs.taggable_id = idft.id
	JOIN tags t ON tgs.tag_id = t.id
	WHERE tgs.created_by_staff_member = 1
	--WHERE t.locale = 'en-US'
)
, tag2 AS 
(
	SELECT id, listagg(name, ' | ') within group (order by name) AS tags
	FROM tag1
	GROUP BY 1
)
, ut AS --upsell tags
(
	SELECT uvo.upsell_id, tag2.tags AS upsell_tags, uvo.petition_id, uvo.organization_name, uvo.targeting_type, uvo.views, uvo.optins
	FROM uvo
	LEFT JOIN tag2 on uvo.upsell_id = tag2.id
)
, ed1 AS --event details
(
	SELECT ut.upsell_id, ut.petition_id, ut.views AS upsell_views, ut.optins AS optins, tag2.tags AS leadin_tags, ut.upsell_tags AS upsell_tags, ut.organization_name, ut.targeting_type, 'http://www.change.org/p/' || CAST(ut.petition_id as text) as leadin_url, 'http://www.change.org/p/' || CAST(ut.upsell_id as text) as upsell_url
	FROM ut
	LEFT JOIN tag2 ON ut.petition_id = tag2.id
	ORDER BY ut.optins DESC
)
, title AS
(
	SELECT ed1.upsell_id, ed1.petition_id, ed1.upsell_views, ed1.optins, ed1.leadin_tags, ed1.upsell_tags, e.title AS leadin_title, e.country_code AS country_code, ed1.organization_name, ed1.targeting_type, ed1.leadin_url, ed1.upsell_url
	FROM ed1
	LEFT JOIN e ON ed1.petition_id = e.id
	ORDER BY ed1.optins DESC
)

SELECT title.upsell_views, title.optins, title.leadin_tags, title.upsell_tags, title.leadin_title, title.country_code AS leadin_country, e.title AS upsell_title, e.country_code AS upsell_country, title.organization_name, title.targeting_type, title.leadin_url, title.upsell_url, e.sponsored
FROM title
LEFT JOIN e ON title.upsell_id = e.id
ORDER BY title.optins DESC
LIMIT {QUERY_LIMIT}
