WITH untagged AS -- petitions without tags
(
SELECT DISTINCT
e.id,
e.slug,
e.created_locale
FROM events e
WHERE e.created_locale = 'en-US'
AND e.id NOT IN (SELECT taggable_id FROM taggings) -- pulling untagged petitions
),
a AS
(
SELECT
DATE(aar.sent_date) AS day, --action alert sent date
aar.subject as subject, -- action alert subject
aar.event_id as event, --petition_id from action_alert_records table
tgd.slug as slug, --slug
SUM(aar.num_sent) AS sends
FROM action_alert_records aar
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON saa.id = aac.scheduled_action_alert_id
JOIN campaign_teams ct ON ct.id = saa.campaign_team_id
JOIN untagged tgd ON aar.event_id = tgd.id 
WHERE aar.sent_date >= current_date - INTERVAL '1 DAY'
AND aar.sent_date  < current_date
AND LEFT(ct.name, 2)  = 'US'
GROUP BY 1,2,3,4
ORDER BY 1,2 ASC
)
SELECT day, event, sends, subject, slug
FROM a
WHERE day = current_date - INTERVAL '1 DAYS'
AND event IS NOT NULL
ORDER BY 1
LIMIT {QUERY_LIMIT}
;