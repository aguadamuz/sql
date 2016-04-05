SELECT distinct name FROM
(
with target_signers as
(select user_id FROM signatures_users WHERE petition_id = 6692852)
select su.petition_id, t.name FROM signatures_users su JOIN target_signers ts ON su.user_id = ts.user_id
JOIN taggings tgs ON su.petition_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
)





SELECT name, petition_id, user_id FROM
(
SELECT name, petition_id, user_id FROM
(with target_signers as
(select user_id FROM signatures_users WHERE petition_id = 6692852)
select su.petition_id, t.name FROM signatures_users su JOIN target_signers ts ON su.user_id = ts.user_id
JOIN taggings tgs ON su.petition_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id ))
GROUP BY 1
ORDER BY 2 DESC

SELECT name, COUNT(DISTINCT user_id) FROM
(
SELECT name, petition_id, user_id FROM
(with target_signers as
(select user_id FROM signatures_users WHERE petition_id = 6692852)
select su.petition_id, t.name, su.user_id FROM signatures_users su JOIN target_signers ts ON su.user_id = ts.user_id
JOIN taggings tgs ON su.petition_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id ))
GROUP BY 1
HAVING COUNT(DISTINCT user_id) >= 50
ORDER BY 2 DESC
LIMIT 9999


SELECT DISTINCT
t.name AS tags,
COUNT(DISTINCT aaue.user_id) AS id_count 
FROM action_alert_user_events aaue
JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct ON saa.campaign_team_id = ct.id
JOIN taggings tgs ON aac.event_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE aaue.event = 'view' -- new = sent
AND aaue.user_id IN
(select distinct user_id from signatures_users where petition_id = 6692852)
GROUP BY 1
ORDER BY 2 DESC
\g ~/Downloads/My_redshift_output2.csv
--AND aaue.created_at::date >= current_date - interval '90 days'
--AND ct.name = 'US_99'