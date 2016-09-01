with tagged_users as
(with project_tagged as
(select taggable_id
from taggings
where user_id in (533019575, 532971977))
select su.user_id, su.signup_context
from signatures_users su 
join project_tagged pt on su.petition_id = pt.taggable_id
join eligible_users eu on eu.id = su.user_id)
select * from signatures_users su join tagged_users tu on su.user_id = tu.user_id
where su.signup_context ILIKE '%actionalert%'
and su.created_at::date >= '2016-04-26'
limit 999


with tagged_users as
(with project_tagged as
(select taggable_id
from taggings
where user_id in (533019575, 532971977))
select su.user_id, su.signup_context
from signatures_users su 
join project_tagged pt on su.petition_id = pt.taggable_id
join eligible_users eu on eu.id = su.user_id)
select * from signatures_users su join tagged_users tu on su.user_id = tu.user_id
where su.signup_context ILIKE '%actionalert%'
and min(su.created_at)::date >= '2016-04-26'
limit 999


with tagged_users as
(with project_tagged as
(select taggable_id
from taggings
where user_id in (533019575, 532971977))
select su.user_id, su.petition_id, su.signup_context, su.created_at::date
from signatures_petitions su 
join project_tagged pt on su.petition_id = pt.taggable_id
join eligible_users eu on eu.id = su.user_id
where su.created_at::date >= '2016-04-26'
and su.signup_context ILIKE '%actionalert%')
--select * from tagged_users limit 999
select count(distinct petition_id) as action_alert_petitons, count(user_id) as signatures, count(distinct user_id) as users from tagged_users limit 999