--make sure the events viewed are active, en_US petitions
WITH us_events AS
(
SELECT id FROM events
WHERE status = 1 AND deleted_at IS NULL AND created_locale = 'en-US'
)
, petition_views AS
(
SELECT 
puv.created_at::date, puv.petition_id, COALESCE(CAST(puv.user_id AS TEXT), puv.uuid) AS user_id
FROM petition_update_view puv JOIN us_events use ON puv.petition_id = use.id
WHERE puv.country_code = 'US'
AND puv.created_at >= current_date - interval '7 days'

UNION

SELECT
pv.created_at::date, pv.petition_id, COALESCE(CAST(pv.user_id AS TEXT), pv.uuid) AS user_id
FROM petition_view pv JOIN us_events use ON pv.petition_id = use.id
WHERE pv.country_code = 'US'
AND pv.created_at >= current_date - interval '7 days'

UNION

SELECT
psv.created_at::date, psv.petition_id, COALESCE(CAST(psv.user_id AS TEXT), psv.uuid) AS user_id
FROM petition_sign_views psv JOIN us_events use ON psv.petition_id = use.id
WHERE psv.country_code = 'US'
AND psv.created_at >= current_date - interval '7 days'
)
, tagged_petitions AS --all tagged petitions
(SELECT DISTINCT taggable_id FROM taggings)
--tagged/untagged petitions
, tagged_untagged AS
(
SELECT pv.created_at, pv.petition_id, pv.user_id, 
CASE WHEN tp.taggable_id IS NULL THEN 0 ELSE 1 END AS tagged
FROM petition_views pv LEFT JOIN tagged_petitions tp ON pv.petition_id = tp.taggable_id
)
, total_views AS
(
SELECT created_at, COUNT(DISTINCT(user_id)) as total_views
FROM tagged_untagged
--WHERE created_at >= current_date - interval '30 days'
GROUP BY 1
)
SELECT tu.created_at, tv.total_views, COUNT(DISTINCT(tu.user_id)) as untagged_views, COUNT(DISTINCT(tu.user_id))/tv.total_views::real AS percentage_views_untagged
FROM tagged_untagged tu JOIN total_views tv ON tu.created_at = tv.created_at
--WHERE tu.created_at >= current_date - interval '30 days'
AND tu.tagged = 0
GROUP BY 1,2
ORDER BY 1 ASC
LIMIT 999;
