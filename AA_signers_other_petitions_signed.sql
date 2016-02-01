--for the past 28 days
--how many US users signed one or more animal petitions they were emailed
--and of those users, how many signed any US petition besides the animal petitions they were emailed
--whether those other petitions were emailed or not
--exclude upsells
​
--signers of emailed animal petitions
WITH us_animal_email_signers AS
(
--US users that signed animal petitions they were emailed
SELECT su.user_id, su.petition_id, su.user_id || su.petition_id AS a
FROM signatures_users su
JOIN taggings tgs on su.petition_id = tgs.taggable_id
WHERE su.signup_context ILIKE '%actionalert%'
AND su.country_code = 'US'
AND su.created_at >= current_date - interval '28 days'
AND su.created_at < current_date
AND tgs.tag_id = 7367 --7367 is the tag_id for 'animals'
GROUP BY 1,2
)
SELECT COUNT(DISTINCT user_id)
FROM us_animal_email_signers
LIMIT 1;
​
-----------------------------------------------------------
​
--number of those signers that signed other petitions (excluding upsells)
WITH us_animal_email_signers AS
(
--US users that signed animal petitions they were emailed
SELECT su.user_id, su.petition_id, su.user_id || su.petition_id AS a
FROM signatures_users su
JOIN taggings tgs on su.petition_id = tgs.taggable_id
WHERE su.signup_context ILIKE '%actionalert%'
AND su.country_code = 'US'
AND su.created_at >= current_date - interval '28 days'
AND su.created_at < current_date
AND tgs.tag_id = 7367
GROUP BY 1,2
)
,other_petitions_signed AS
(
SELECT su.user_id, su.petition_id, su.user_id || su.petition_id AS a
FROM signatures_users su
JOIN us_animal_email_signers uaes ON su.user_id = uaes.user_id
--JOIN taggings tgs ON su.petition_id = tgs.taggable_id
WHERE su.country_code = 'US'
AND su.created_at >= current_date - interval '28 days'
AND su.created_at < current_date
GROUP BY 1,2
)
SELECT COUNT(DISTINCT ops.user_id) 
--ops.user_id, ops.petition_id 
FROM other_petitions_signed ops
WHERE ops.a NOT IN (SELECT DISTINCT a FROM us_animal_email_signers)
AND ops.petition_id NOT IN (SELECT upsell_id FROM upsell_events WHERE created_at >= current_date - interval '28 days' AND created_at < current_date)
LIMIT 1;
​