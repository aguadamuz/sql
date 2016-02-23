SELECT 
e.created_at, COALESCE(e.title, e.ask), e.id, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count,
l.country_code, l.state_code, l.city, l.lat, l.lng, l.id AS location_id
FROM events e LEFT JOIN locations l ON e.relevant_location_id = l.id
WHERE e.created_at >= current_date - interval '90 days'
AND e.created_locale = 'en-US'
AND l.state_code IS NULL
AND l.city IS NULL 
AND l.lat IS NULL
AND l.lng IS NULL
AND country_code = 'US'
ORDER BY e.total_signature_count DESC
LIMIT 200;