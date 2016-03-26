
SELECT REPLACE(title, '"', '') AS title, REPLACE(letter_body, '"', '') AS letter_body, 'http://www.change.org/p/' || id AS URL, id
FROM 
(
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
SELECT REPLACE(COALESCE(e.title, e.ask), ',', '') AS title, REPLACE(e.letter_body, ',', '') AS letter_body, 'http://www.change.org/p/' || e.id AS URL, e.id
--, tgd.tags
FROM events e
JOIN taggings tgs ON e.id = tgs.taggable_id JOIN tags t ON t.id = tgs.tag_id JOIN tgd ON e.id = tgd.id
WHERE e.created_locale = 'en-US'
AND e.status > 0
AND e.deleted_at IS NULL
AND tgd.tags NOT ILIKE '%gun control%' 
AND tgd.tags NOT ILIKE'%gun safety%' 
AND tgd.tags NOT ILIKE '%gun rights%'
AND (
e.title ILIKE '% gun%'
OR e.title ILIKE '% rifle%'
OR e.title ILIKE '% arms%'
OR e.title ILIKE '% armed%'
OR e.title ILIKE '% second amendment%'
OR e.title ILIKE '%concealed carry %'
OR e.title ILIKE '%NRA%'
OR e.title ILIKE '%firearm%'
OR e.title ILIKE '%pistol%')
GROUP BY 1,2,3,4
ORDER BY 4 DESC
)