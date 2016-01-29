WITH us_signed_petitions AS
(SELECT created_at::date, petition_id, user_id
FROM signatures_petitions WHERE created_at::date >= '2015-12-12' AND country_code = 'US'
)
, us_events AS
(SELECT id, COALESCE(ask, title) AS title, 'http://www.change.org/p/' || CAST(id AS TEXT) AS url
FROM events WHERE created_locale = 'en-US' AND status > 0 AND deleted_at IS NULL)

SELECT use.title, use.url, COUNT(DISTINCT usp.user_id)
FROM us_signed_petitions usp JOIN us_events use ON usp.petition_id = use.id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 500;