--Revenue generated from German Promoted Petitions (by Cause) in the last two years
select 
name, 
count(distinct user_id) as user_count, 
sum(amount_cents::float)/100 as revenue
from

(
select c.name, vc.user_id, vc.amount_cents 
from victory_fund_credits vc
join victory_funds vf on vf.id = vc.victory_fund_id
join events e on vf.petition_id = e.id
left join changes c on e.change_id = c.id
join users u on vc.user_id = u.id
where vc.created_at >= current_date - interval '2 years'
and u.country = 'DE'
order by vf.petition_id desc
)
group by 1
order by 3 desc
;

--Alice's query modified for causes
with promoters as (
select user_id, count(*) as num_promotes
from victory_fund_credits vfc
where created_at::date >= current_date - interval '2 years'
group by 1)

, promoter_country as  (
select p.user_id, u.country
from promoters p
join users u on p.user_id = u.id
group by 1,2)

, repeat_promoters as (
select distinct user_id as user_id
from promoters p
where num_promotes > 1)


select ch.name, count(distinct vfc.user_id), sum(vfc.amount_cents)/100.0
from promoters r 
join victory_fund_credits vfc on r.user_id = vfc.user_id
join victory_funds vf on vfc.victory_fund_id = vf.id
join events e on e.id = vf.petition_id
join changes ch on e.change_id = ch.id
join promoter_country pc on r.user_id = pc.user_id
where 
pc.country = 'DE' and 
vfc.created_at::date >= current_date - interval '2 years'
group by 1
order by 3 desc
limit 100
