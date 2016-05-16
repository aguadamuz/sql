-- select pv.user_id, count(pv.petition_id)
-- from petition_view pv
-- join eligible_users eu on pv.user_id = eu.id
-- where user_id is not null
-- and created_at::date between current_date - interval '28 days' and current_date - interval '21 days'
-- limit 99999;

--users that signed a petition between 21 and 28 days ago and have not logged in since


-- eligible users whose last visit was 21 to 28 days ago
with visitors as
(
select aud.user_id, max(aud.first_ts)::date
from etl_queries.a_user_day aud
group by aud.user_id
having max(aud.first_ts) between current_date - interval '28 days' and current_date - interval '21 days'
)
--what petitions did those users sign during that time period
, sigs as
(
select su.created_at::date, su.user_id, su.petition_id
from signatures_users su join visitors v on su.user_id = v.user_id
where su.created_at::date between current_date - interval '28 days' and current_date - interval '21 days'
)
--which of those petitions had the most of those signers
select s.petition_id, 'http://www.change.org/p/' || s.petition_id as url, count(distinct s.user_id) as signers
from sigs s
group by 1,2
order by 3 DESC
limit 100;

--tags
-- eligible users whose last visit was 21 to 28 days ago
with visitors as
(
select aud.user_id, max(aud.first_ts)::date
from etl_queries.a_user_day aud
where aud.country_code = 'US'
group by aud.user_id
having max(aud.first_ts) between current_date - interval '28 days' and current_date - interval '21 days'
)
--what petitions did those users sign during that time period
, sigs as
(
select su.created_at::date, su.user_id, su.petition_id
from signatures_users su join visitors v on su.user_id = v.user_id
where su.created_at::date between current_date - interval '28 days' and current_date - interval '21 days'
)
--which of those petitions had the most of those signers
select t.name, count(distinct s.user_id) as signers
from sigs s join taggings tgs on tgs.taggable_id = s.petition_id join tags t on tgs.tag_id = t.id
group by 1
order by 2 DESC
limit 100;