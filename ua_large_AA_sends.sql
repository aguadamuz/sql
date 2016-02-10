--ua large AA sends

SELECT aar.id, aar.sent_date::date, aar.subject, aar.num_sent, aar.event_id, ct.name
FROM action_alert_records aar
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct on saa.campaign_team_id = ct.id
WHERE sent_date::date >= current_date - interval '90 days'
AND num_sent >= 10000
AND ct.name ILIKE '%us%'
GROUP BY 1,2,3,4,5,6
ORDER BY 2 ASC
LIMIT 9999;