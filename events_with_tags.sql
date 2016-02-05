--input petition id
--query returns
--tags on other petitions signed by signers of the input petition
--the number of total eligible users for the tag
--the number of petitions signed with that tag signed by signers of the input petition 
--the number of eligible users that signed the input petition and another petition with that tag

WITH tp AS
(
WITH t AS --tagged petitions
(SELECT t.name, tgs.taggable_id
FROM taggings tgs JOIN tags t ON tgs.tag_id = t.id
WHERE t.locale = 'en-US'
)
SELECT t.name, count(distinct sp.user_id) AS tag_users
FROM signatures_petitions sp JOIN t ON sp.petition_id = t.taggable_id
WHERE sp.user_id IN (SELECT id FROM eligible_users)
GROUP BY 1
)
, ewt AS --events with tags
(
SELECT e.id, t.name FROM events e
JOIN taggings tgs ON e.id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE status > 0
AND deleted_at IS NULL
AND created_locale = 'en-US'
AND relevant_location_id = 96
)
, signers AS
(
SELECT DISTINCT sp.user_id
FROM signatures_petitions sp
WHERE sp.petition_id = 5115534
AND sp.country_code = 'US'
AND sp.user_id IN (SELECT id FROM eligible_users)
),
petitions AS
(
SELECT sp.petition_id, s.user_id
FROM signatures_petitions sp
JOIN signers s on s.user_id = sp.user_id
WHERE sp.petition_id != 5115534
AND s.user_id IN (SELECT id FROM eligible_users)
GROUP BY 1,2
), event AS
(
SELECT p.petition_id, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || CAST(p.petition_id AS TEXT) AS url
FROM petitions p
JOIN events e ON e.id = p.petition_id
)
SELECT ewt.name, tp.tag_users AS tag_eligible_users, count(distinct p.petition_id) AS petition_count, count(distinct p.user_id) AS petitions_eligible_signature_count
FROM petitions p LEFT JOIN ewt ON p.petition_id = ewt.id LEFT JOIN tp ON ewt.name = tp.name
GROUP BY 1,2
ORDER BY 4 DESC
;
--pull eligible US users by tag



--count of eligible US users that signed the petition
SELECT COUNT(DISTINCT sp.user_id)
FROM signatures_petitions sp
WHERE sp.petition_id = 4692014
AND sp.country_code = 'US'
AND sp.user_id IN (SELECT id FROM eligible_users)
;

