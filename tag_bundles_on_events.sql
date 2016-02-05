
WITH tgd AS --tagg bundles on events
(
WITH ewt AS --events with tags
(
SELECT e.id, e.created_locale, t.name FROM events e
JOIN taggings tgs ON e.id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE status > 0
AND deleted_at IS NULL
)
SELECT id, created_locale, listagg(name, ' | ') within group (order by name) AS tags
FROM ewt
GROUP BY 1,2
)
, ed AS --event details
(SELECT id, COALESCE(ask, title) AS title FROM events WHERE deleted_at IS NULL)
, aa AS --action alerts
(
SELECT aar.event_id, SUM(aar.num_sent) AS num_sent, SUM(aar.num_views) AS num_views, SUM(aar.num_signatures) AS num_signatures, SUM(aar.num_unsubscribes) AS num_unsubscribes
FROM action_alert_records aar
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON saa.id = aac.scheduled_action_alert_id
JOIN campaign_teams ct ON ct.id = saa.campaign_team_id
JOIN events e ON e.id = aar.event_id
WHERE aar.sent_date::date >= '2015-01-01' AND aar.sent_date::date <= '2015-12-31'
AND e.created_locale = 'en-US'
GROUP BY 1
)
, ewbt AS-- events with bundled tags
(SELECT aa.event_id, tgd.tags, aa.num_sent, aa.num_views, aa.num_signatures, aa.num_unsubscribes
FROM aa LEFT JOIN tgd ON aa.event_id = tgd.id
ORDER BY 3 DESC
)
SELECT ewbt.event_id, ed.title, ewbt.tags, ewbt.num_sent, ewbt.num_views, ewbt.num_signatures, ewbt.num_unsubscribes
FROM ewbt LEFT JOIN ed ON ewbt.event_id = ed.id
ORDER BY 4 desc
LIMIT 2000;

