
----------------------------
--condensed version
SELECT DISTINCT
aaue.user_id, 
aaue.action_alert_record_id,
aar.action_alert_content_id,
aac.scheduled_action_alert_id, 
aac.event_id,
saa.campaign_team_id,
ct.name,
t.name
FROM action_alert_user_events aaue
JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
JOIN action_alert_contents aac ON aar.action_alert_content_id = aac.id
JOIN scheduled_action_alerts saa ON aac.scheduled_action_alert_id = saa.id
JOIN campaign_teams ct ON saa.campaign_team_id = ct.id
JOIN taggings tgs ON aac.event_id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE aaue.event = 'new' -- new = sent
AND aaue.created_at >= current_date - interval '3 days'
AND ct.name = 'US_99'
ORDER BY 5,1
LIMIT 99;
----------------------------















WITH aaue AS --action alert user events
(
SELECT aaue.user_id, aaue.action_alert_record_id
FROM action_alert_user_events aaue
WHERE aaue.event = 'new' -- new = sent
AND aaue.created_at >= current_date - interval '30 days'
)
, aauec AS --action alert user events with aa_content_id
(
SELECT aaue.user_id, aaue.action_alert_record_id, aar.action_alert_content_id
FROM aaue JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
)
, aauecs AS -- action alert user events with aa_content_id and scheduled_action_alert_id
(
--join to action_alert_contents to get the scheduled_action_alerts_id
SELECT aauec.user_id, aauec.action_alert_record_id, aauec.action_alert_content_id, aac.scheduled_action_alert_id, aac.event_id
FROM aauec JOIN action_alert_contents aac ON aauec.action_alert_content_id = aac.id
)
, aauecst AS -- action alert user events with aa_content_id and scheduled_action_alert_id and campaign_team_id
(
--join to scheduled_action_alerts to get the team id
SELECT aauecs.user_id, aauecs.action_alert_record_id, aauecs.action_alert_content_id, aauecs.scheduled_action_alert_id, aauecs.event_id, saa.campaign_team_id
FROM aauecs JOIN scheduled_action_alerts saa ON aauecs.scheduled_action_alert_id = saa.id
)
, aauecstn AS-- action alert user events with aa_content_id, scheduled_action_alert_id, campaign_team_id, and campaign team name
(
--join to campaign_teams to get the team name
SELECT aauecst.user_id, aauecst.action_alert_record_id, aauecst.action_alert_content_id, aauecst.scheduled_action_alert_id, aauecst.event_id, aauecst.campaign_team_id, ct.name
FROM aauecst JOIN campaign_teams ct ON aauecst.campaign_team_id = ct.id
WHERE ct.name = 'US_99'
)
, tag_names AS
----pull the taggable_ids and tag names
(SELECT DISTINCT tgs.taggable_id, t.name FROM taggings tgs JOIN tags t ON tgs.tag_id = t.id WHERE t.locale = 'en-US')

SELECT aauecstn.user_id, aauecstn.action_alert_record_id, aauecstn.action_alert_content_id, aauecstn.scheduled_action_alert_id, aauecstn.event_id, aauecstn.campaign_team_id, aauecstn.name, tn.name
FROM aauecstn LEFT JOIN tag_names tn ON aauecstn.event_id = tn.taggable_id
ORDER BY 1 ASC
LIMIT 999;




--OK now I can join to the campaigns_team table to get the campaign team name on which we will filer for US_99 petitions


--join to scheduled_action_alerts to get the team id
--join to campaign_teams action alert user events with aa_content_id and scheduled_action_alert_id

SELECT *
FROM scheduled_action_alerts
LIMIT 99;

SELECT *
FROM action_alert_contents
LIMIT 99;




SELECT *
FROM action_alert_records
LIMIT 99;

--need to get the campaign team data
--this lives in scheduled_action_alerts
--join to action alert records
--then join ot action alert contents




, aaue_w_event AS
(
SELECT aaue.user_id, aaue.action_alert_record_id, aar.event_id
FROM aaue JOIN action_alert_records aar ON aaue.action_alert_record_id = aar.id
)
SELECT awe.user_id, awe.action_alert_record_id, awe.event_id, tgs.tag_id
FROM aaue_w_event awe LEFT JOIN taggings tgs ON awe.event_id = tgs.taggable_id
LIMIT 99;

SELECT *
FROM action_alert_records
LIMIT 99;

SELECT *
FROM action_alert_contents
LIMIT 99;

SELECT *
FROM scheduled_action_alerts
LIMIT 99;