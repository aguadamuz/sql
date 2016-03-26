--how many en-US petitions need to be geo-tagged

SELECT COUNT(DISTINCT e.id)
FROM events e JOIN locations l ON e.relevant_location_id = l.id
WHERE e.status = 1
AND e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.total_signature_count >= 2
AND (l.state_code IS NULL OR l.city IS NULL)
LIMIT 999
;
