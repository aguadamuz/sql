SELECT date(e.victory_date), date(e.created_at), COALESCE(e.title, e.ask) AS title, e.total_signature_count, 'http://www.change.org/p/' || e.id AS URL, l.country_code, e.created_locale
FROM events e
LEFT JOIN locations l ON e.relevant_location_id = l.id
WHERE e.status = 3
AND date(e.victory_date) >= current_date - interval '7 days'
GROUP BY 1,2,3,4,5,6,7
ORDER BY 1 ASC
LIMIT 9999;

SELECT *
FROM victory_requests
WHERE created_at 
LIMIT 99;

SELECT vp.victory_date::date, date(e.created_at), LEFT(COALESCE(e.title, e.ask), 50) AS title, e.total_signature_count, 'http://www.change.org/p/' || vp.petiiton_id AS URL, l.country_code, e.created_locale
FROM victory_petitions vp
JOIN events e ON vp.petition_id = e.id
LEFT JOIN locations l ON e.relevant_location_id = l.id
WHERE victory_date::date >= current_date - interval '7 days'
LIMIT 9999;


SELECT *
FROM victory_petitons
LIMIT 99;

SELECT *
FROM locations 
LIMIT 99;

SELECT e.victory_date, date(e.created_at), LEFT(COALESCE(e.title, e.ask), 50) AS title, e.total_signature_count, 'http://www.change.org/p/' || e.id AS URL, l.country_code, e.created_locale
FROM events e
LEFT JOIN locations l ON e.relevant_location_id = l.id
WHERE status = 3
AND date(victory_date) >= current_date - interval '7 days'
AND date(victory_date) < current_date
GROUP BY 1,2,3,4,5,6,7
ORDER BY 1 ASC
LIMIT 9999;