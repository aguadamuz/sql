with maxtime as 
(
	select max(created_at) as max_time
	from victory_fund_credits
),

tagged as
(	select taggable_id, count(distinct tag_id) as tag_count
	from taggings tgs
	group by 1
),

hours as 
(
select
	date_trunc('hour', created_at) as hour
from victory_fund_credits v
where created_at >= (select max_time from maxtime) - interval '1 days'
and date_part('hour', created_at) not in (0,1,2,6,7,8,12,13,14,18,19,20)
group by 1
)

select distinct petition_id, victory_fund_id, title, country, tag_count
from
(
select
	h.hour
  , f.petition_id
  , v.victory_fund_id
  , coalesce(e.title, initcap(replace(e.slug,'-',' '))) as title
  , country
  , s.hours as interval
  , tgd.tag_count
  , count(distinct v.user_id) as promoters
  , sum(v.amount_cents::float/100) as rev
 
from hours h
join victory_fund_credits v on v.created_at between h.hour - interval '6 hours' and h.hour
inner join victory_funds f on f.id=v.victory_fund_id
inner join events e on e.id=f.petition_id
join users u on e.user_id = u.id
join spike_alerter_metrics s on s.type = 'pp' and s.metric = 'pp rev'
left join tagged tgd on e.id = tgd.taggable_id
where v.user_id <> e.user_id
group by 1,2,3,4,5,6,7
having sum (v.amount_cents::float/100) >= max(s.threshold)
)
order by 1,2,3,4