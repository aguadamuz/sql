SELECT e.id, e.created_at::date, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.created_locale, e.total_signature_count, l.country_code, c.name AS cause
FROM events e
JOIN changes c ON e.change_id = c.id 
LEFT JOIN locations l ON e.relevant_location_id = l.id
WHERE c.name ILIKE '%animal%'
AND date(e.created_at) >= '2014-01-01'
AND date(e.created_at) <= '2014-12-31'
GROUP BY 1,2,3,4,5,6,7,8
ORDER BY 7 ASC, 6 DESC
LIMIT 9999;