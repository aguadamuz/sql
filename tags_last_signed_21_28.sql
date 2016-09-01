with visitors as
(
select distinct aud.user_id
from etl_queries.a_user_day aud
group by aud.user_id
having max(aud.first_ts) between current_date - interval '28 days' and current_date - interval '21 days'
)
--what petitions did those users sign (all time)
, sigs as
(
select su.created_at::date, su.country_code, su.user_id, su.petition_id,
case when su.user_id in (select distinct id from eligible_users) then su.user_id else null end as eligible
from signatures_users su join visitors v on su.user_id = v.user_id
group by 1,2,3,4,5
)
--tags with signers and eligible signers
select distinct t.name, s.country_code, count(distinct s.user_id) as signers, count(distinct eligible) as eligible_signers
from sigs s join taggings tgs on tgs.taggable_id = s.petition_id join tags t on tgs.tag_id = t.id
group by 1,2
order by 3 DESC
LIMIT {QUERY_LIMIT}