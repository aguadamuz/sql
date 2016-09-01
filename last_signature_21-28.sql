with visitors as
(
select distinct aud.user_id
  --, max(aud.first_ts)::date
from etl_queries.a_user_day aud
group by aud.user_id
having max(aud.first_ts) between current_date - interval '28 days' and current_date - interval '21 days'
)
--what petitions did those users sign (all time)
, sigs as
(
select su.created_at::date, su.user_id, su.country_code, su.petition_id,
case when su.user_id in (select * from eligible_users) then 1 else 0 end as eligible
from signatures_users su join visitors v on su.user_id = v.user_id
)
--which of those petitions had the most of those signers
select s.petition_id, s.country_code, e.created_locale, 'http://www.change.org/p/' || s.petition_id as url, count(distinct s.user_id) as signers, sum(eligible) as eligible_signers
from sigs s join events e on s.petition_id = e.id
where e.deleted_at is null
group by 1,2,3,4
order by 5 DESC
LIMIT {QUERY_LIMIT}