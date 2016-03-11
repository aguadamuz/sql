--CHANGE-26863 pt1
--How many users are associated with each tag (irrespective of overlap)?
SELECT DISTINCT tt.name, COUNT(DISTINCT el.id) AS eligible_users
--, tt.id, tgs.taggable_id
FROM taggings tgs JOIN tags tt ON tgs.tag_id = tt.id
JOIN signatures_petitions sp ON tgs.taggable_id = sp.petition_id
JOIN eligible_users el ON sp.user_id = el.id
WHERE locale = 'en-US'
AND (tt.name ILIKE 'Migrant workers'
OR tt.name ILIKE 'anti-immigrant discrimination'
OR tt.name ILIKE 'deportation'
OR tt.name ILIKE 'detention'
OR tt.name ILIKE 'immigrant support services'
OR tt.name ILIKE 'immigration reform'
OR tt.name ILIKE 'temporary protected status'
OR tt.name ILIKE 'latino')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 999;

--CHANGE-26863 pt1
--How many unique individuals are represented among this group of tags?
SELECT DISTINCT COUNT(DISTINCT el.id) AS eligible_users
FROM taggings tgs JOIN tags tt ON tgs.tag_id = tt.id
JOIN signatures_petitions sp ON tgs.taggable_id = sp.petition_id
JOIN eligible_users el ON sp.user_id = el.id
WHERE locale = 'en-US'
AND (tt.name ILIKE 'Migrant workers'
OR tt.name ILIKE 'anti-immigrant discrimination'
OR tt.name ILIKE 'deportation'
OR tt.name ILIKE 'detention'
OR tt.name ILIKE 'immigrant support services'
OR tt.name ILIKE 'immigration reform'
OR tt.name ILIKE 'temporary protected status'
OR tt.name ILIKE 'latino')
LIMIT 1;

--CHANGE-26863 pt1
--How many users have 1 of these tags? 2? 3? etc.
SELECT count, COUNT(DISTINCT id)
FROM 
(SELECT el.id, COUNT(DISTINCT tt.name) AS count
FROM taggings tgs JOIN tags tt ON tgs.tag_id = tt.id
JOIN signatures_petitions sp ON tgs.taggable_id = sp.petition_id
JOIN eligible_users el ON sp.user_id = el.id
WHERE locale = 'en-US'
AND (tt.name ILIKE 'Migrant workers'
OR tt.name ILIKE 'anti-immigrant discrimination'
OR tt.name ILIKE 'deportation'
OR tt.name ILIKE 'detention'
OR tt.name ILIKE 'immigrant support services'
OR tt.name ILIKE 'immigration reform'
OR tt.name ILIKE 'temporary protected status'
OR tt.name ILIKE 'latino')
GROUP BY 1
)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--CHANGE-26863 pt2
--How many signatures are on these 4 petitions, irrespective of overlap?
SELECT sp.petition_id, COUNT(DISTINCT sp.user_id) AS total_users
FROM signatures_petitions sp JOIN eligible_users eu ON sp.user_id = eu.id 
WHERE sp.petition_id::int IN
(
5807578,
6272594,
4390287,
5576734
)
AND sp.country_code = 'US'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;

--CHANGE-26863 pt2
--How many unique individuals are represented?
SELECT sp.petition_id, COUNT(DISTINCT sp.user_id) AS total_users
FROM signatures_petitions sp JOIN eligible_users eu ON sp.user_id = eu.id 
WHERE sp.petition_id::int IN
(
5807578,
6272594,
4390287,
5576734
)
AND sp.country_code = 'US'
LIMIT 1
;

--CHANGE-26863 pt2
--How many users have signed 1, 2, 3, or all 4 of these petitions?
WITH petition_count AS
(
SELECT sp.user_id, COUNT(DISTINCT sp.petition_id) AS count
FROM signatures_petitions sp JOIN eligible_users eu ON sp.user_id = eu.id 
WHERE petition_id::int IN
(
5807578,
6272594,
4390287,
5576734
)
AND sp.country_code = 'US'
GROUP BY 1
)
SELECT count, COUNT(DISTINCT user_id)
FROM petition_count
GROUP BY 1
ORDER BY 1 ASC
LIMIT 999;

--CHANGE-26863 pt2
--Treating the signers of these petitions as a single cohort, what are the 500 petitions they have signed the most, as compared with email-eligible users? (The "sign proportion analysis.")
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
WHERE sp.petition_id IN
(
5807578,
6272594,
4390287,
5576734
)
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

--CHANGE-26863 pt3
--The other petitions are four we believe may have users who are similar to signers of the "core petitions" (in Part 2), but we're uncertain. What we'd like to determine is:
--CHANGE-26863 pt2
--How many signatures are on these four petitions?
SELECT sp.petition_id, COUNT(DISTINCT sp.user_id) AS total_users
FROM signatures_petitions sp JOIN eligible_users eu ON sp.user_id = eu.id 
WHERE sp.petition_id::int IN
(
2137764,
243223,
340352,
3646081
)
AND sp.country_code = 'US'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
;

--CHANGE-26863 pt3
--How many unique users do those signatures represent?
SELECT sp.petition_id, COUNT(DISTINCT sp.user_id) AS total_users
FROM signatures_petitions sp JOIN eligible_users eu ON sp.user_id = eu.id 
WHERE sp.petition_id::int IN
(
2137764,
243223,
340352,
3646081
)
AND sp.country_code = 'US'
LIMIT 1
;

--CHANGE-26863 pt3
--How many users have signed 1, 2, 3, or 4 of the "core petitions" from Part 2? (Note that this is about whether they've signed the above "core petitions," not whether they've signed the other petitions mentioned in Part 3.)

WITH target_petition_signers AS
(
SELECT DISTINCT sp.user_id AS user_id
FROM signatures_petitions sp JOIN eligible_users eu ON sp.user_id = eu.id 
WHERE sp.petition_id::int IN
(
2137764,
243223,
340352,
3646081
)
AND sp.country_code = 'US'
)
, petition_count AS
(
SELECT sp.user_id, COUNT(DISTINCT sp.petition_id) AS count
FROM signatures_petitions sp JOIN target_petition_signers tps ON sp.user_id = tps.user_id
WHERE petition_id::int IN
(
5807578,
6272594,
4390287,
5576734
)
AND sp.country_code = 'US'
GROUP BY 1
)
SELECT count, COUNT(DISTINCT user_id)
FROM petition_count
GROUP BY 1
ORDER BY 1 ASC
LIMIT 999;


