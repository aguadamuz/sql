WITH aa AS
(
SELECT DISTINCT
aaue.user_id
FROM action_alert_user_events aaue
JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct ON saa.campaign_team_id = ct.id
WHERE aaue.event = 'new' -- new = sent
AND aac.event_id = 4991122
)
SELECT DISTINCT sp.user_id
FROM signatures_petitions sp
WHERE sp.petition_id = 4991122
AND sp.country_code = 'US'
AND sp.user_id NOT IN (SELECT * FROM aa)


WITH aa AS
(
SELECT DISTINCT
aaue.user_id
FROM action_alert_user_events aaue
JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct ON saa.campaign_team_id = ct.id
WHERE aaue.event = 'new' -- new = sent
AND aac.event_id = 4991122
)
SELECT DISTINCT sp.user_id
FROM signatures_petitions sp
JOIN aa ON aa.user_id = sp.user_id
WHERE sp.petition_id = 4991122
AND sp.country_code = 'US'