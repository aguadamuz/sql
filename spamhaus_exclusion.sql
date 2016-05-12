with emailed as
	(SELECT DISTINCT aaue.user_id
	FROM action_alert_user_events aaue
	WHERE aaue.event = 'new'
	AND aaue.created_at >= current_date - interval '90 days')

, openers as --users that opened an email in the last 90 days
(SELECT DISTINCT aaue.user_id
FROM action_alert_user_events aaue
WHERE aaue.event = 'open'
AND aaue.created_at >= current_date - interval '90 days')
--pull emailed and exclude openers to get the non-openers

,nonopeners as
(select e.user_id 
	from emailed e 
	left join openers o on e.user_id = o.user_id
where o.user_id is null)

select user_id 
from nonopeners nop 
join users u on nop.user_id = u.id
where u.created_at <= current_date - interval '7 days'
group by 1
order by 1 desc
\g ~/Downloads/keria_exclusions_spamhouse_20160502.csv