WITH tgd AS
(
SELECT DISTINCT
e.id AS id,
CASE WHEN e.id IN (SELECT DISTINCT taggable_id FROM taggings) THEN 1 ELSE 0 END AS tagged
FROM events e
),
sends AS
(
SELECT
TO_CHAR(aar.sent_date, 'YYYY-MM-DD') AS day,
tgd.tagged,
SUM(aar.num_sent) AS sends
FROM action_alert_records aar
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON saa.id = aac.scheduled_action_alert_id
JOIN campaign_teams ct ON ct.id = saa.campaign_team_id
LEFT JOIN tgd ON tgd.id = aar.event_id
WHERE aar.sent_date >= GETDATE() - INTERVAL '7 DAYS'
AND aar.sent_date  < GETDATE()
AND LEFT(ct.name, 2)  = 'US'
GROUP BY 1,2
ORDER BY 1,2 ASC
)
SELECT 
s.day,
SUM(CASE WHEN s.tagged IS NULL THEN s.sends ELSE 0 END) AS no_event,
SUM(CASE WHEN s.tagged = 1 THEN s.sends ELSE 0 END) AS tagged,
SUM(CASE WHEN s.tagged = 0 THEN s.sends ELSE 0 END) AS not_tagged,
SUM(s.sends) AS total
FROM sends s
GROUP BY 1
ORDER BY 1 ASC
LIMIT {QUERY_LIMIT};