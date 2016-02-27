--for RA query

SELECT u.id FROM users u
JOIN emails em ON u.id = em.user_id
JOIN email_preferences ep ON u.id = ep.user_id
WHERE em.status = 2
AND u.this_login >= current_date - interval '1 year'
AND u.country = 'US'
AND ep.send_action_alert_emails = 1
ORDER BY random()
LIMIT 999
;



--campaign level data
SELECT ct.name, 
       aar.id                                              AS "Action Alert ID", 
       aac.subject                                         AS "Subject", 
       aac.from_column                                     AS "Sender", 
       aac.sidebar_callout                                 AS "Callout", 
       aac.button_text                                     AS "Button Text", 
       aar.ab_test                                         AS 
       "A/B Test (1 = Yes)", 
       'https://www.change.org/admin/action_alert_templates/' 
       || aac.action_alert_template_id 
       || '/preview'                                       AS "Template", 
       aar.sent_date                                       AS "Date Sent", 
       aar.num_sent                                        AS "Number Sent", 
       aar.num_opened                                      AS "Number Opened", 
       Round(( aar.num_opened / num_sent * 100 ), 2)       AS "Open Rate (%)", 
       aar.num_views                                       AS "Number Clicked", 
       Round(( aar.num_views / num_sent * 100 ), 2)        AS "CTR (%)", 
       Round(( num_opened / num_views ), 2) 
       || ':1'                                             AS "Open:Click", 
       aar.num_signatures                                  AS 
       "Number Signatures", 
       Round(( aar.num_signatures / num_sent * 100 ), 2)   AS "Sign Rate (%)", 
       aar.num_optins                                      AS "Number Optins", 
       Round(( aar.num_optins / num_sent * 100 ), 2)       AS "Optin Rate (%)", 
       aar.num_unsubscribes                                AS 
       "Number Unsubscribes", 
       Round(( aar.num_unsubscribes / num_sent * 100 ), 2) AS "Unsub Rate (%)", 
       aac.action_url                                      AS "URL", 
       saa.send_at                                         AS "Start Sending Time", 
       saa.finished_at                                     AS "Finished Sending Time", 
       aaug.description                                    AS "user grouping description", 
       aac.user_generated_content                          AS "UG content (1 = Yes)" 
FROM   action_alert_contents aac 
       JOIN action_alert_records aar 
         ON ( aac.id = aar.action_alert_content_id ) 
       JOIN scheduled_action_alerts saa 
         ON ( aac.scheduled_action_alert_id = saa.id ) 
       JOIN action_alert_user_groupings aaug 
         ON ( saa.id = aaug.scheduled_action_alert_id ) 
       JOIN campaign_teams ct 
         ON ct.id = saa.campaign_team_id 
WHERE  saa.campaign_team_id IN ( 6, 7, 22, 21, 40, 3, 41 )
       AND aar.num_sent > 0 
       AND aar.num_views > 0 
ORDER  BY aar.sent_date DESC
LIMIT 999;