--High signature petitions with no tags
with collage as
(select petition_id, listagg(name, ' | ') within group (order by name) AS tags
FROM (select ct.petition_id, ct.tag_id, t.name from collage_tags ct join tags t on ct.tag_id = t.id)
GROUP BY 1)
select distinct e.created_at::date, e.id, 'http://www.change.org/p/' || e.id as url, coalesce(e.title, e.ask) as title, e.total_signature_count, c.tags as collage_recommendation, e.created_locale
from events e 
left join taggings tgs on e.id = tgs.taggable_id
left join collage c on e.id = c.petition_id
where tgs.taggable_id is null
and e.total_signature_count >= 50
and e.deleted_at is null
and e.status > 0
and e.created_locale = 'en-AU'
and e.created_at::date <= current_date - interval '1 day'
order by 5 desc
limit 100000;

--High signature petitions with <5 tags
with collage as
(select petition_id, listagg(name, ' | ') within group (order by name) AS tags
FROM (select ct.petition_id, ct.tag_id, t.name from collage_tags ct join tags t on ct.tag_id = t.id)
GROUP BY 1)
, tag_bundles as
(select taggable_id, listagg(name, ' | ') within group (order by name) AS tags
FROM (select tgs.taggable_id, tgs.tag_id, t.name from taggings tgs join tags t on tgs.tag_id = t.id)
GROUP BY 1)
select distinct e.created_at::date, e.id, 'http://www.change.org/p/' || e.id as url, coalesce(e.title, e.ask) as title, e.total_signature_count, tb.tags as tags_on_petiton, c.tags as collage_recommendation, e.created_locale, count(tgs.taggable_id) as tag_count
from events e join taggings tgs on e.id = tgs.taggable_id
left join collage c on e.id = c.petition_id
left join tag_bundles tb on e.id = tb.taggable_id
where e.total_signature_count >= 50
and e.deleted_at is null
and e.status > 0
and e.created_locale = 'en-AU'
and e.created_at::date <= current_date - interval '1 day'
group by 1,2,3,4,5,6,7,8
having count(tgs.taggable_id) < 5
order by 5 desc
limit 100000;


--how many petitions are being tagged daily
select tagged_date as date, count(distinct taggable_id) as petitions_tagged
from
(
with collage as
(select petition_id, listagg(name, ' | ') within group (order by name) AS tags
FROM (select ct.petition_id, ct.tag_id, t.name from collage_tags ct join tags t on ct.tag_id = t.id)
GROUP BY 1)
select distinct tgs.taggable_id, tgs.created_at::date as tagged_date, e.total_signature_count, e.created_locale, count(distinct tag_id)
from taggings tgs
join events e on e.id = tgs.taggable_id
left join collage c on e.id = c.petition_id
left join tags t on tgs.tag_id = t.id
where tgs.created_at::date >= current_date - interval '90 days'
and tgs.created_at::date < current_date
and e.created_locale = 'en-GB'
group by 1,2,3,4
order by tagged_date DESC
)
group by 1
order by 1 asc
limit 999
;

--details on the petitions tagged in the last 90 days 

with collage as
(select petition_id, listagg(name, ' | ') within group (order by name) AS tags
FROM (select ct.petition_id, ct.tag_id, t.name from collage_tags ct join tags t on ct.tag_id = t.id)
GROUP BY 1)
, petition_details as
(
select distinct tgs.taggable_id, tgs.created_at::date as tagged_date, tgs.tag_id, t.name, e.created_at::date, e.total_signature_count, e.created_locale
from taggings tgs
join events e on e.id = tgs.taggable_id
left join collage c on e.id = c.petition_id
left join tags t on tgs.tag_id = t.id
where tgs.created_at::date >= current_date - interval '90 days'
and e.created_locale = 'en-GB'
order by taggable_id DESC
)
, tag_details as
(select taggable_id, listagg(name, ' | ') within group (order by name) AS tags
FROM (select pd.taggable_id, pd.tag_id, pd.name from petition_details pd join tags t on pd.tag_id = t.id)
GROUP BY 1)
select distinct pd.tagged_date, pd.taggable_id, pd.total_signature_count, pd.created_locale, td.tags as tagged_with, c.tags as collage_recommendations
from petition_details pd
left join tag_details td on pd.taggable_id = td.taggable_id
left join collage c on pd.taggable_id = c.petition_id
order by 1 desc
limit 999;