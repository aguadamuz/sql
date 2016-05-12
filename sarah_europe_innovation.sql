--average number of signatures across all petitions last 90 days
SELECT AVG(sigcount)
FROM
(SELECT e.id, COUNT(DISTINCT su.user_id) AS sigcount
FROM events e JOIN signatures_petitions su ON e.id = su.petition_id
WHERE e.total_signature_count >= 2
AND su.created_at::date between current_date - interval '91 days' and current_date - interval '1 days'
--AND e.created_locale = 'en-US'
AND e.status > 0
AND e.deleted_at IS NULL
--AND e.sponsored = 0
GROUP BY 1
HAVING COUNT(DISTINCT su.user_id) > 1);

--avg petition shares last 90 days
select avg(count)
from
(
select s.petition_id, count(s.uuid) as count
from share_petition s join events e on s.petition_id = e.id
where s.created_at::date between current_date - interval '91 days' and current_date - interval '1 days'
and e.total_signature_count > 1
and e.deleted_at is null
and e.status > 0
group by 1
union all
select s.petition_id, count(s.uuid) as count
from share_update s join events e on s.petition_id = e.id
where s.created_at::date between current_date - interval '91 days' and current_date - interval '1 days'
and e.total_signature_count > 1
and e.deleted_at is null
and e.status > 0
group by 1
order by 1 asc
);

--MIU from shares
WITH sh_miu AS
(
with 
-- get all signed in users since 1/1/15
data as (
select tad.user_id::integer as id, tad.created_at, tad.created_at::date as date, tad.first_ts::date as firstdate, tad.country_code, u.state,
case when tad.current_source='action_alert' then 'action_alert'
when tad.current_source='petition_update' then 'petition_update'
when tad.current_source='share_petition' and current_medium='facebook' then 'share facebook'
when tad.current_medium='copylink' then 'copylink'
    when tad.current_medium='vk' then 'vk'
when tad.current_source='share_petition' and current_medium='whatsapp' then 'share whatsapp'
when tad.current_source='share_petition' and current_medium not in ('facebook','copylink','whatsapp','vk') then 'share other'
when tad.current_source IS null and current_medium IS null then 'direct'
else 'other' end as source
from tanya.a_user_day tad LEFT JOIN users u ON tad.user_id = u.id
where tad.created_at::date between '2015-01-01' and current_date::date-1
group by 1,2,3,4,5,6,7
)
-- sample data 1% and assign new or returning user type
, sampledata as (
select a.id, a.date::date, a.country_code, a.state, a.source, a.created_at,
case when a.date::date between a.firstdate::date and a.firstdate::date+27 then 'new' else 'returning' end as type
from (
select id as id, left(right(id,4),2) as sample, country_code, state, created_at, source, date::date as date, firstdate::date as firstdate
from data
group by 1,2,3,4,5,6,7,8
) a
where a.sample='08'
group by 1,2,3,4,5,6,7
)
-- date table
, dates as (
select date::date as date
from data
group by 1
order by 1
)
-- mau by new or returning by dau date, using 28 day period for cyclicality
select x.date::date as date, x.state,
case when x.country in ('US','ES','GB','RU','TR','FR','AU','CA','AR','IT','DE','IN','BR','MX','ID','ZA','CO','IE','JP','TH','PH','CL','PE','EC','VE','CR','UY','GT','NI','SV','PA','HN','PY','BO','CU','PR','DO') then x.country else 'Other' end as country, x.source,
100*count(distinct case when x.type='new' then x.id else null end) as new_user, 
100*count(distinct case when x.type='returning' then x.id else null end) as return_user
from
(
select a.date::date as date, id, b.country_code as country, b.state, b.source, b.type, b.created_at, row_number() over (partition by id, a.date::date order by b.created_at) as rank
from dates a left join sampledata b
on b.date::date between a.date::date-27 and a.date::date
where a.date::date between '2015-01-29' and current_date::date-1
group by 1,2,3,4,5,6,7
order by 1,2
)x
where x.rank=1
group by 1,2,3,4
order by 1,2,3,4
)

select date, --state, 
sum(new_user) as new_user_miu, sum(return_user) as return_user_miu, 
sum(new_user)+sum(return_user) as total_miu 
from sh_miu
where date::date between current_date::date-91 and current_date::date-1
and source in ('share facebook', 'share whatsapp', 'share other')
group by 1
order by 1
LIMIT 999
;