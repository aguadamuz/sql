WITH emailed_users AS
(
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
AND aaue.created_at >= current_date - interval '30 days'
AND ct.name = 'US_99'
)
--eligible users
SELECT u.id, u.email
FROM eligible_users eu
JOIN users u ON eu.id = u.id
LEFT JOIN emailed_users emu ON eu.id = emu.user_id
WHERE emu.user_id IS NULL
--WHERE u.id NOT IN (SELECT * FROM emailed_users)
AND u.country = 'US'
AND u.locale = 'en-US'
ORDER BY 1 DESC
LIMIT 9999999
;