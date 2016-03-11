SELECT created_at, title, total_signature_count, listagg(name, ' | ') within group (order by name) AS tags
FROM
(
SELECT e.created_at, e.id, COALESCE(e.title, e.ask) AS title, e.total_signature_count, t.name
FROM events e JOIN taggings tgs ON e.id = tgs.taggable_id JOIN tags t ON tgs.tag_id = t.id
WHERE e.created_locale = 'en-US'
AND e.status = 1
AND e.created_at >= current_date - interval '180 days'
AND  
(e.letter_body ILIKE '% gun%'
OR e.letter_body ILIKE '% rifle%'
OR e.letter_body ILIKE '%assault weapon%'
OR e.letter_body ILIKE '%2nd ammendment%'
OR e.letter_body ILIKE '%second ammendment%')
)
GROUP BY 1,2,3
ORDER BY total_signature_count DESC
LIMIT 999;

