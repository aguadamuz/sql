--will need to add a variable to the users (they will have needed to have either received or not received a specific email)

--users with Raven petition as their first petition
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select count(distinct user_id) AS first_time_signers
--created_at, user_id, petition_id, sign_time
FROM first_sig
WHERE petition_id = 4623766;
--GROUP BY 1,2,3,4;
----------------------------
----------------------------
--Raven first time signers users that started a petition after their Raven signature 

with signers as
(
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select created_at, user_id, petition_id, sign_time
FROM first_sig
WHERE petition_id = 4623766
GROUP BY 1,2,3,4
)
SELECT count(distinct e.user_id) AS petition_starters
FROM events e
JOIN signers s ON e.user_id = s.user_id 
AND e.created_at > s.created_at
LIMIT 1;

----------------------------
----------------------------
--Raven first time signers users that use social media share
with signers as
(
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select created_at, user_id, petition_id, sign_time
FROM first_sig
WHERE petition_id = 4623766
GROUP BY 1,2,3,4
)
SELECT count(distinct shp.user_id) AS sharers
FROM share_petition shp JOIN signers s ON shp.user_id = s.user_id
WHERE location IN ('facebook', 'twitter')
--AND shp.created_at > s.created_at
LIMIT 1;

----------------------------
----------------------------
--Raven first time signers users with more than one action
with signers as
(
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select created_at, user_id, petition_id, sign_time
FROM first_sig
WHERE petition_id = 4623766
GROUP BY 1,2,3,4
)
SELECT count(distinct u.id) AS two_or_more_actions
FROM users u JOIN signers s ON u.id = s.user_id
WHERE u.total_actions >= 2
LIMIT 1;

----------------------------
----------------------------
--consolidated version

with signers as
(
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select created_at, user_id, petition_id, sign_time
FROM first_sig
WHERE petition_id = 4623766
GROUP BY 1,2,3,4
), count as
(SELECT s.user_id,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM events WHERE id <> 4623766) THEN 1 ELSE 0 END AS starter,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM share_petition WHERE petition_id <> 4623766) THEN 1 ELSE 0 END AS sharer,
CASE WHEN s.user_id IN (SELECT DISTINCT id FROM users WHERE total_actions > 1) THEN 1 ELSE 0 END AS multiple_actions
FROM signers s
)
SELECT count(distinct user_id), SUM(starter) AS starters, SUM(sharer) AS sharers, SUM(multiple_actions) AS multiple_actions
FROM count


--------------------------------------
--------------------------------------
WITH email_recipients AS
(
--users that received a specific AA email
SELECT DISTINCT
aaue.user_id
--aaue.action_alert_record_id,
--aar.action_alert_content_id,
--aac.scheduled_action_alert_id, 
--aac.event_id,
--saa.campaign_team_id,
--ct.name,
--t.name
FROM action_alert_user_events aaue
JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct ON saa.campaign_team_id = ct.id
JOIN taggings tgs ON aac.event_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE aaue.event = 'new' -- new = sent
AND aac.event_id = 4803238
--aaue.created_at >= current_date - interval '3 days'
--AND ct.name = 'US_99'
--ORDER BY 5,1
), 
with signers as
(
with  first_sig as (
	select * from(
	select created_at, user_id, petition_id, rank() over(partition by user_id order by created_at asc) as sign_time
	from signatures_petitions) a
	where sign_time = 1)

select fs.created_at, fs.user_id, fs.petition_id, fs.sign_time
FROM first_sig fs JOIN email_recipients er ON fs.user_id = er.user_id
WHERE fs.petition_id = 4623766
GROUP BY 1,2,3,4
), count as
(SELECT s.user_id,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM events WHERE id <> 4623766) THEN 1 ELSE 0 END AS starter,
CASE WHEN s.user_id IN (SELECT DISTINCT user_id FROM share_petition WHERE petition_id <> 4623766) THEN 1 ELSE 0 END AS sharer,
CASE WHEN s.user_id IN (SELECT DISTINCT id FROM users WHERE total_actions > 1) THEN 1 ELSE 0 END AS multiple_actions
FROM signers s
)
SELECT count(distinct user_id), SUM(starter) AS starters, SUM(sharer) AS sharers, SUM(multiple_actions) AS multiple_actions
FROM count