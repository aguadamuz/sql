WITH last_petition_signed AS
(
--last petition signed by all users
SELECT user_id, petition_id, created_at::date, row_number
FROM (
SELECT user_id, petition_id, created_at, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC) FROM signatures_users
ORDER BY 1,4 DESC)
WHERE row_number = 1
)
, emailed_users AS
(
--pull the users that HAVE received an HT Action Alert, ML Action Alert, or Sweeps email in the last 365 days
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
AND aaue.created_at >= current_date - interval '365 days'
AND ct.name IN ('US_99', 'US_01', 'US_03') --users that received an AA, ML, or Sweeps email
)
,non_receivers AS
(
-- eligible US users that HAVE NOT received an HT Action Alert, ML Action Alert, or Sweeps email in the last 365 days
SELECT u.id, u.email, u.first_name, u.last_name, u.created_at, u.last_action_time, DATEDIFF(day, u.created_at, u.last_action_time) AS datediff
FROM eligible_users eu
JOIN users u ON eu.id = u.id
LEFT JOIN emailed_users emu ON eu.id = emu.user_id
WHERE emu.user_id IS NULL
AND u.country = 'US'
AND u.locale = 'en-US'
AND u.last_action_time <= current_date - interval '30 days' -- excludig users that have had a recent action as they may have not had time to receive an action alert
GROUP BY 1,2,3,4,5,6,7
ORDER BY 1 DESC
)
--last petition signed
SELECT nr.id, nr.email, nr.first_name, nr.last_name, nr.created_at::date AS user_created_date, nr.last_action_time::date AS last_action_time, nr.datediff AS days_between_creation_and_last_action, lps.created_at AS last_signature_date, lps.petition_id AS last_petition_signed
FROM non_receivers nr LEFT JOIN last_petition_signed lps ON nr.id = lps.user_id
LIMIT 10000;