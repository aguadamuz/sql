WITH email_recipients AS
(
--our cohort should consist of users that were NOT sent an action alert id 490962
SELECT DISTINCT
aaue.user_id
FROM action_alert_user_events aaue
JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct ON saa.campaign_team_id = ct.id
JOIN taggings tgs ON aac.event_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE aaue.event = 'new' -- new = sent
--AND aac.event_id = 4803238
AND aar.id = 490962
)
, signers as --our cohort is made up of first time signers with first sign on event 5115534 who also received an action alert id 490962
(
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select fs.created_at, fs.user_id, fs.petition_id, fs.sign_time
FROM first_sig fs --JOIN email_recipients er ON fs.user_id = er.user_id
WHERE fs.petition_id = 5115534
AND fs.user_id NOT IN (SELECT user_id FROM email_recipients)
GROUP BY 1,2,3,4
), count as 
-- we want to know how many of these users started new petitons, shared petitions, and had multiple actions
-- after signing the petition, we cannot know the actions after the sign as the count is an aggregate on the user table, but we can assume that
-- any count >1 was taken after the initial sign
-- the initial request asked for comments made by the users but that data is not in redshift (per Andy Veluswami)
(SELECT s.user_id,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM events WHERE id <> 5115534) THEN 1 ELSE 0 END AS starter,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM share_petition WHERE petition_id <> 5115534) THEN 1 ELSE 0 END AS sharer,
CASE WHEN s.user_id IN (SELECT DISTINCT id FROM users WHERE total_actions > 1) THEN 1 ELSE 0 END AS multiple_actions,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM signatures_petitions WHERE petition_id <> 5115534) THEN 1 ELSE 0 END AS signers
FROM signers s
)
SELECT count(distinct user_id), SUM(starter) AS starters, SUM(sharer) AS sharers, SUM(signers) AS signers, SUM(multiple_actions) AS multiple_actions
FROM count
;

WITH email_recipients AS
(
--our cohort should consist of users that were sent an action alert for event_id: 4803238
SELECT DISTINCT
aaue.user_id
FROM action_alert_user_events aaue
JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct ON saa.campaign_team_id = ct.id
JOIN taggings tgs ON aac.event_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE aaue.event = 'new' -- new = sent
--AND aac.event_id = 4803238
AND aar.id = 490962
)
, signers as --our cohort is made up of first time signers with first sign on event 5115534 who also received an action alert id 490962
(
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select fs.created_at, fs.user_id, fs.petition_id, fs.sign_time
FROM first_sig fs JOIN email_recipients er ON fs.user_id = er.user_id
WHERE fs.petition_id = 5115534
GROUP BY 1,2,3,4
), count as 
-- we want to know how many of these users started new petitons, shared petitions, and had multiple actions
-- after signing the petition, we cannot know the actions after the sign as the count is an aggregate on the user table, but we can assume that
-- any count >1 was taken after the initial sign
-- the initial request asked for comments made by the users but that data is not in redshift (per Andy Veluswami)
(SELECT s.user_id,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM events WHERE id <> 5115534) THEN 1 ELSE 0 END AS starter,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM share_petition WHERE petition_id <> 5115534) THEN 1 ELSE 0 END AS sharer,
CASE WHEN s.user_id IN (SELECT DISTINCT id FROM users WHERE total_actions > 1) THEN 1 ELSE 0 END AS multiple_actions,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM signatures_petitions WHERE petition_id <> 5115534) THEN 1 ELSE 0 END AS signers
FROM signers s
)
SELECT count(distinct user_id), SUM(starter) AS starters, SUM(sharer) AS sharers, SUM(signers) AS signers, SUM(multiple_actions) AS multiple_actions
FROM count
