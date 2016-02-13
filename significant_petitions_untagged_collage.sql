WITH ewct AS --events with collage tags
(
SELECT e.id, COALESCE(e.title, e.ask) AS title, total_signature_count, 'http://www.change.org/p/' || e.id AS url, 'http://www.change.org/p/' || e.slug AS url2, relevant_location_id, t.name AS collage_tag
FROM events e
LEFT JOIN taggings tgs ON e.id = tgs.taggable_id
LEFT JOIN collage_tags ct ON e.id = ct.petition_id
LEFT JOIN tags t ON ct.tag_id = t.id
WHERE tgs.taggable_id IS NULL
AND e.created_locale = 'en-US'
AND e.status = 1
AND e.deleted_at IS NULL
AND e.total_signature_count >= 500
GROUP BY 1,2,3,4,5,6,7
ORDER BY 3 DESC
)
SELECT id, title, total_signature_count, url, url2, listagg(collage_tag, ' | ') within group (order by collage_tag) AS collage_tags
FROM ewct
GROUP BY 1,2,3,4,5
ORDER BY 3 DESC
LIMIT 5000;