--Highly viewed victory petitions

WITH tgd AS --tagg bundles on events
(
WITH ewt AS --events with tags
(
SELECT e.id, e.created_locale, t.name FROM events e
JOIN taggings tgs ON e.id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE status > 0
AND deleted_at IS NULL
)
SELECT id, created_locale, listagg(name, ' | ') within group (order by name) AS tags
FROM ewt
GROUP BY 1,2
)

SELECT 'http://www.change.org/p/' || pv.petition_id, COUNT(DISTINCT pv.uuid), tgd.tags
FROM petition_view pv
JOIN events e ON pv.petition_id = e.id
LEFT JOIN tgd ON pv.petition_id = tgd.id
WHERE pv.created_at::date >= current_date - interval '365 days'
AND e.status = 3
AND e.created_locale = 'en-US'
AND e.deleted_at IS NULL
GROUP BY 1,3
HAVING COUNT(DISTINCT pv.uuid) >= 100
ORDER BY 2 DESC
LIMIT 9999;
