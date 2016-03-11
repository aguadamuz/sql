--active en-US petitions with >= 100 signatures and no detailed geo-tag

SELECT 
--COUNT(DISTINCT e.id)
e.created_at, e.id, COALESCE(e.title, e.ask), e.total_signature_count, e.relevant_location_id, l.country_code, l.city, l.lat, l.lng
FROM events e JOIN locations l ON e.relevant_location_id = l.id
WHERE l.city IS NULL
AND l.lat IS NULL
AND l.lng IS NULL
AND e.created_locale = 'en-US'
AND e.status = 1
AND e.total_signature_count >= 100
ORDER BY 4 DESC
LIMIT 50000
;

--highly viewed victory petitions
SELECT pv.petition_id, COALESCE(e.title, e.ask), pv.locale, pv.country_code, e.total_signature_count, l.country_code AS location_country_code, l.city, l.lat, l.lng, COUNT(DISTINCT pv.uuid) AS views_last_90
FROM petition_view pv JOIN events e ON pv.petition_id = e.id JOIN locations l ON e.relevant_location_id = l.id
WHERE l.city IS NULL
AND l.lat IS NULL
AND l.lng IS NULL
AND e.created_locale = 'en-US'
AND e.status = 3
AND e.total_signature_count >= 500
AND pv.created_at::date >= current_date - interval '90 days'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY 10 DESC
LIMIT 50000
;

SELECT *
FROM events
WHERE created_at >= current_date - interval '180 days'
AND status = 1
AND deleted_at IS NULL
AND created_locale = 'en-US'
AND total_signature_count >= 50
AND (letter_body ILIKE '%election%'
OR letter_body ILIKE '%trump%'
OR letter_body ILIKE '%clinton%'
OR letter_body ILIKE '%Ted Cruz%'
OR letter_body ILIKE '%John Kasich%'
OR letter_body ILIKE '%marco rubio%'
OR letter_body ILIKE '%voter%'
OR letter_body ILIKE '%marco rubio%'
OR letter_body ILIKE '%congress%'
OR letter_body ILIKE '%supreme court%'
OR letter_body ILIKE '%potus%'
OR letter_body ILIKE '%flotus%'
OR letter_body ILIKE '%scotus%'
OR letter_body ILIKE '%first lady%'
OR letter_body ILIKE '%president of the united states%'
OR letter_body ILIKE '%senator%'
OR letter_body ILIKE '%senate%'
OR letter_body ILIKE '%scalia%'
)
LIMIT 60000;


SELECT *
FROM petition_view
LIMIT 99