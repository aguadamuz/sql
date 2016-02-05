--pull all untagged upsell events
WITH upsell AS
(
SELECT DISTINCT upsell_id, organization_name
FROM upsell_events
WHERE country_code = 'US'
)
, untagged AS
(
SELECT u.upsell_id, u.organization_name
FROM upsell u
WHERE u.upsell_id NOT IN (SELECT DISTINCT taggable_id FROM taggings)
)
, us_events AS 
(
SELECT id, relevant_location_id, created_locale, total_signature_count, COALESCE(title, ask) AS title
FROM events WHERE created_locale = 'en-US'
AND relevant_location_id = 96
)
SELECT u.upsell_id, e.title, u.organization_name, e.total_signature_count
FROM untagged u JOIN us_events e ON u.upsell_id = e.id
GROUP BY 1,2,3,4
ORDER BY 4 DESC
LIMIT 2000;