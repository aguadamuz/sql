--add the number of elgigible US users that signed the petitions

WITH grouped_tags AS
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
, signers AS
(
SELECT DISTINCT sp.user_id
FROM signatures_petitions sp
WHERE sp.petition_id = 5468586
),
petitions AS
(
SELECT sp.petition_id, count(distinct(s.user_id))
FROM signatures_petitions sp
JOIN signers s on s.user_id = sp.user_id
--WHERE petition_id != 4384233
GROUP BY 1
ORDER BY 2 DESC
), event AS
(
SELECT p.petition_id, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || CAST(p.petition_id AS TEXT) AS url, p.count
FROM petitions p
JOIN events e ON e.id = p.petition_id
ORDER BY 4 DESC
)
SELECT e.petition_id, e.title, e.url, e.count, gt.tags
FROM event e
LEFT JOIN grouped_tags gt ON e.petition_id = gt.id
ORDER BY 4 DESC
LIMIT 500;





-----with total eligible users by petition
WITH grouped_tags AS
(
WITH ewt AS --events with tags
(
SELECT e.id, e.created_locale, t.name FROM events e
JOIN taggings tgs ON e.id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE status > 0
AND created_locale = 'en-US'
AND deleted_at IS NULL
)
SELECT id, created_locale, listagg(name, ' | ') within group (order by name) AS tags
FROM ewt
GROUP BY 1,2
)
, signers AS
(
SELECT DISTINCT sp.user_id
FROM signatures_petitions sp
WHERE sp.petition_id = 4692014
AND sp.country_code = 'US'
),
petitions AS
(
SELECT sp.petition_id, count(distinct(s.user_id))
FROM signatures_petitions sp
JOIN signers s on s.user_id = sp.user_id
--WHERE petition_id != 4384233
GROUP BY 1
ORDER BY 2 DESC
), event AS
(
SELECT p.petition_id, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || CAST(p.petition_id AS TEXT) AS url, p.count
FROM petitions p
JOIN events e ON e.id = p.petition_id
ORDER BY 4 DESC
)
, total_eligible_users_by_petition AS
(
SELECT sp.petition_id, count(distinct(sp.user_id)) AS count
FROM signatures_petitions sp
JOIN petitions p ON sp.petition_id = p.petition_id
--JOIN signers s on s.user_id = sp.user_id
--WHERE petition_id != 4384233
WHERE sp.country_code = 'US'
GROUP BY 1
ORDER BY 2 DESC
)
SELECT e.petition_id, e.title, e.url, e.count AS eligible_signers_of_target_petition, teup.count AS total_eligible_users_on_petition, gt.tags
FROM event e
LEFT JOIN grouped_tags gt ON e.petition_id = gt.id
LEFT JOIN total_eligible_users_by_petition teup ON e.petition_id = teup.petition_id
ORDER BY 4 DESC
LIMIT 500;
