select date, petition_id, name, sponsored, media, count
from
(
select s.petition_id, t.name, e.sponsored, s.location as media, s.created_at::date as date, count(s.uuid) as count
from share_petition s join events e on s.petition_id = e.id join taggings tgs on s.petition_id = tgs.taggable_id join tags t on tgs.tag_id = t.id
where s.created_at::date >= '2016-01-01'
and s.country_code = 'US'
and t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
group by 1,2,3,4,5
union all
select s.petition_id, t.name, e.sponsored, s.location as media, s.created_at::date as date, count(s.uuid) as count
from share_update s join events e on s.petition_id = e.id join taggings tgs on s.petition_id = tgs.taggable_id join tags t on tgs.tag_id = t.id
where s.created_at::date >= '2016-01-01'
and s.country_code = 'US'
and t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
group by 1,2,3,4,5
)
limit 999

--avg number of shares by social media last 31 days
select media, avg(count)
from
(
select s.petition_id, e.sponsored, s.location as media, count(s.uuid) as count
from share_petition s join events e on s.petition_id = e.id join taggings tgs on s.petition_id = tgs.taggable_id join tags t on tgs.tag_id = t.id
where s.created_at::date between current_date - interval '31 days' and current_date - interval '1 days'
and s.country_code = 'US'
and t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
group by 1,2,3
union all
select s.petition_id, e.sponsored, s.location as media, count(s.uuid) as count
from share_update s join events e on s.petition_id = e.id join taggings tgs on s.petition_id = tgs.taggable_id join tags t on tgs.tag_id = t.id
where s.created_at::date between current_date - interval '31 days' and current_date - interval '1 days'
and s.country_code = 'US'
and t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
group by 1,2,3
having count(s.uuid) > 0
order by 1 asc
)
group by 1
limit 999


--avg number of shares by social media Q1 2016
select media, avg(count)
from
(
select s.petition_id, e.sponsored, s.location as media, count(s.uuid) as count
from share_petition s join events e on s.petition_id = e.id join taggings tgs on s.petition_id = tgs.taggable_id join tags t on tgs.tag_id = t.id
where s.created_at::date between '2016-01-01' and '2016-03-31'
and s.country_code = 'US'
--and t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
group by 1,2,3
union all
select s.petition_id, e.sponsored, s.location as media, count(s.uuid) as count
from share_update s join events e on s.petition_id = e.id join taggings tgs on s.petition_id = tgs.taggable_id join tags t on tgs.tag_id = t.id
where s.created_at::date between '2016-01-01' and '2016-03-31'
and s.country_code = 'US'
--and t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
group by 1,2,3
having count(s.uuid) > 0
order by 1 asc
)
where sponsored = 0
group by 1
limit 999